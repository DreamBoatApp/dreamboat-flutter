import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class OpenAIService {
  static const String _mockTip = "Bugün, içsel yolculuğunu derinleştirmek için bir anı defteri tutmayı deneyebilirsin. Rüyalarında gördüğün çocukluk hâlinle bağ kurarak, o saf sevgiyi yeniden keşfetmek için birkaç dakikanı ayır ve hislerini kaleme al.";
  
  static bool _firebaseInitialized = false;
  static bool _appCheckActivated = false;
  
  /// Ensure Firebase is initialized and user is authenticated before making calls.
  /// Unlike the old version, this ALWAYS validates auth state — never caches a
  /// "ready" flag that could mask a failed sign-in.
  Future<void> _ensureFirebaseReady() async {
    // 1. Initialize Firebase if not done
    if (!_firebaseInitialized) {
      try {
        debugPrint('=== OpenAIService: Initializing Firebase... ===');
        await Firebase.initializeApp();
        _firebaseInitialized = true;
        debugPrint('=== OpenAIService: Firebase initialized ===');
      } catch (e) {
        if (e.toString().contains('already been initialized') || 
            e.toString().contains('[core/duplicate-app]')) {
          _firebaseInitialized = true;
          debugPrint('=== OpenAIService: Firebase was already initialized ===');
        } else {
          debugPrint('=== OpenAIService: Firebase init error: $e ===');
          rethrow;
        }
      }
    }
    
    // 2. ALWAYS ensure we have a valid authenticated user.
    //    Check on every call — don't cache _authReady.
    await _ensureAuthenticated();
    
    // 3. Activate App Check if not done
    if (!_appCheckActivated) {
      try {
        debugPrint('=== OpenAIService: Activating App Check... ===');
        await FirebaseAppCheck.instance.activate(
          androidProvider: kDebugMode 
              ? AndroidProvider.debug 
              : AndroidProvider.playIntegrity,
          appleProvider: kDebugMode 
              ? AppleProvider.debug 
              : AppleProvider.appAttest,
        );
        _appCheckActivated = true;
        debugPrint('=== OpenAIService: App Check activated (${kDebugMode ? "DEBUG" : "PLAY_INTEGRITY"}) ===');
      } catch (e) {
        debugPrint('=== OpenAIService: App Check error (continuing anyway): $e ===');
        _appCheckActivated = true;
      }
    }
  }

  /// Ensures we have a valid Firebase Auth user with a fresh token.
  /// Retries anonymous sign-in up to 3 times if no user exists.
  Future<void> _ensureAuthenticated() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser != null) {
      // User exists — force-refresh the ID token to ensure it's valid
      try {
        await currentUser.getIdToken(true);
        debugPrint('=== OpenAIService: Token refreshed (uid: ${currentUser.uid}) ===');
        return;
      } catch (e) {
        debugPrint('=== OpenAIService: Token refresh failed, re-authenticating: $e ===');
        // Fall through to sign-in below
      }
    }
    
    // No user or token refresh failed — sign in with retry
    await _signInWithRetry();
  }

  /// Attempts anonymous sign-in up to 3 times with exponential backoff.
  Future<void> _signInWithRetry() async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        debugPrint('=== OpenAIService: Anonymous sign-in attempt $attempt/3... ===');
        await FirebaseAuth.instance.signInAnonymously();
        debugPrint('=== OpenAIService: Signed in anonymously (uid: ${FirebaseAuth.instance.currentUser?.uid}) ===');
        return; // Success
      } catch (e) {
        debugPrint('=== OpenAIService: Sign-in attempt $attempt/3 failed: $e ===');
        if (attempt < 3) {
          await Future.delayed(Duration(seconds: attempt)); // 1s, 2s backoff
        }
      }
    }
    // All 3 attempts failed — this is a real problem
    debugPrint('=== OpenAIService: All sign-in attempts failed! ===');
    // Don't throw — let the Cloud Function call proceed anyway.
    // The _callFunction wrapper will catch the unauthenticated error and retry.
  }

  /// Force re-authenticate: sign out then sign back in.
  /// Used when a Cloud Function returns "unauthenticated" despite having a user.
  Future<void> _forceReAuth() async {
    try {
      debugPrint('=== OpenAIService: Force re-auth — signing out... ===');
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('=== OpenAIService: Sign-out error (ignoring): $e ===');
    }
    await _signInWithRetry();
  }

  /// Central wrapper for all Cloud Function calls.
  /// If the first call fails with "unauthenticated", it re-authenticates and retries ONCE.
  Future<Map<String, dynamic>> _callFunction(
    String name,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 90),
  }) async {
    await _ensureFirebaseReady();
    
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable(name)
          .call(params)
          .timeout(timeout);
      return result.data as Map<String, dynamic>;
    } on FirebaseFunctionsException catch (e) {
      // Auto-recover from auth errors
      if (e.code == 'unauthenticated' || e.code == 'UNAUTHENTICATED') {
        debugPrint('=== _callFunction($name): Unauthenticated! Attempting re-auth... ===');
        await _forceReAuth();
        
        // Retry once after re-auth
        final result = await FirebaseFunctions.instance
            .httpsCallable(name)
            .call(params)
            .timeout(timeout);
        return result.data as Map<String, dynamic>;
      }
      rethrow; // Other Firebase errors bubble up normally
    }
  }

  /// Interpret a dream - Returns title + interpretation
  Future<Map<String, String?>> interpretDream(String dreamText, String mood, String language) async {
    try {
      final data = await _callFunction('interpretDream', {
        'dreamText': dreamText,
        'mood': mood,
        'language': language,
      }, timeout: const Duration(seconds: 45));
      
      // Log Token Usage if present
      if (data.containsKey('usage')) {
        final usage = data['usage'];
        debugPrint("GPT Usage (interpretDream): Input: ${usage['prompt_tokens']}, Output: ${usage['completion_tokens']}, Total: ${usage['total_tokens']}");
      }

      return {
        'title': data['title'] as String?,
        'interpretation': data['interpretation'] as String?,
        'cosmicAnalysis': data['cosmicAnalysis'] as String?,
      };
    } on FirebaseFunctionsException catch (e) {
      debugPrint('=== interpretDream FirebaseError ===');
      debugPrint('Code: ${e.code}');
      debugPrint('Message: ${e.message}');
      debugPrint('Details: ${e.details}');
      debugPrint('Plugin: ${e.plugin}');
      debugPrint('StackTrace: ${e.stackTrace}');
      
      // Check for rate limit error
      if (e.code == 'resource-exhausted') {
        int resetMinutes = 5;
        if (e.details is Map && e.details['resetMinutes'] != null) {
          resetMinutes = e.details['resetMinutes'] as int;
        }
        return {
          'title': null,
          'interpretation': null,
          'error': 'rate_limit',
          'resetMinutes': resetMinutes.toString(),
        };
      }
      
      return {
        'title': null,
        'interpretation': null,
        'error': 'firebase_error',
        'details': '${e.code}: ${e.message}',
      };
    } catch (e, stackTrace) {
      debugPrint('=== interpretDream Unknown Error ===');
      debugPrint('Error Type: ${e.runtimeType}');
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      return {
        'title': null,
        'interpretation': null,
        'error': 'unknown_error',
        'details': e.toString(),
      };
    }
  }

  /// Generate daily dream tip
  Future<String> generateDailyTip(List<String> dreams, String language) async {
    try {
      final data = await _callFunction('generateDailyTip', {
        'language': language,
      }, timeout: const Duration(seconds: 20));
      
      // Log Token Usage if present
      if (data.containsKey('usage')) {
        final usage = data['usage'];
        debugPrint("GPT Usage (generateDailyTip): Input: ${usage['prompt_tokens']}, Output: ${usage['completion_tokens']}, Total: ${usage['total_tokens']}");
      }
      
      return data['result'] ?? _mockTip;
    } catch (e) {
      debugPrint('generateDailyTip Error: $e');
      return _mockTip;
    }
  }

  /// Analyze weekly dream patterns
  Future<String> analyzeDreams(List<String> dreams, String language) async {
    final data = await _callFunction('analyzeDreams', {
      'dreams': dreams,
      'language': language,
    });
    
    // Log Token Usage if present
    if (data.containsKey('usage')) {
      final usage = data['usage'];
      debugPrint("GPT Usage (analyzeDreams): Input: ${usage['prompt_tokens']}, Output: ${usage['completion_tokens']}, Total: ${usage['total_tokens']}");
    }

    return data['result'] ?? '';
  }

  /// Analyze dreams with moon phase correlation
  Future<String> analyzeMoonSync(List<Map<String, dynamic>> dreamData, String language) async {
    final data = await _callFunction('analyzeMoonSync', {
      'dreamData': dreamData,
      'language': language,
    });
    
    // Log Token Usage if present
    if (data.containsKey('usage')) {
      final usage = data['usage'];
      debugPrint("GPT Usage (analyzeMoonSync): Input: ${usage['prompt_tokens']}, Output: ${usage['completion_tokens']}, Total: ${usage['total_tokens']}");
    }

    return data['result'] ?? '';
  }
}
