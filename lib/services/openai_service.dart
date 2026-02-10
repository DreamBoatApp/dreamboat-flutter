import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

class OpenAIService {
  static const String _mockTip = "Bugün, içsel yolculuğunu derinleştirmek için bir anı defteri tutmayı deneyebilirsin. Rüyalarında gördüğün çocukluk hâlinle bağ kurarak, o saf sevgiyi yeniden keşfetmek için birkaç dakikanı ayır ve hislerini kaleme al.";
  
  static bool _firebaseInitialized = false;
  static bool _appCheckActivated = false;
  static bool _authReady = false;
  
  /// Ensure Firebase is initialized before making calls
  Future<void> _ensureFirebaseReady() async {
    // Initialize Firebase if not done
    if (!_firebaseInitialized) {
      try {
        debugPrint('=== OpenAIService: Initializing Firebase... ===');
        await Firebase.initializeApp();
        _firebaseInitialized = true;
        debugPrint('=== OpenAIService: Firebase initialized ===');
      } catch (e) {
        // Check if already initialized (that's OK)
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
    
    // Ensure anonymous auth is ready (required by Cloud Functions)
    if (!_authReady) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          debugPrint('=== OpenAIService: No user, signing in anonymously... ===');
          await FirebaseAuth.instance.signInAnonymously();
          debugPrint('=== OpenAIService: Signed in anonymously ===');
        } else {
          debugPrint('=== OpenAIService: Already signed in (uid: ${currentUser.uid}) ===');
        }
        _authReady = true;
      } catch (e) {
        debugPrint('=== OpenAIService: Auth error: $e ===');
        // Don't block - try anyway, main.dart might handle auth
        _authReady = true;
      }
    }
    
    // Activate App Check if not done
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
        // Don't rethrow - App Check errors shouldn't block functionality
        _appCheckActivated = true; // Mark as done to avoid repeated attempts
      }
    }
  }

  /// Interpret a dream - Returns title + interpretation
  Future<Map<String, String?>> interpretDream(String dreamText, String mood, String language) async {
    try {
      await _ensureFirebaseReady();
      
      final result = await FirebaseFunctions.instance.httpsCallable('interpretDream').call({
        'dreamText': dreamText,
        'mood': mood,
        'language': language,
      }).timeout(const Duration(seconds: 45));
      
      final data = result.data as Map<String, dynamic>;
      
      // Log Token Usage if present
      if (data.containsKey('usage')) {
        final usage = data['usage'];
        debugPrint("GPT Usage (interpretDream): Input: ${usage['prompt_tokens']}, Output: ${usage['completion_tokens']}, Total: ${usage['total_tokens']}");
      }

      return {
        'title': data['title'] as String?,
        'interpretation': data['interpretation'] as String?,
        'cosmicAnalysis': data['cosmicAnalysis'] as String?, // [NEW] Parse Journal content
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
      await _ensureFirebaseReady();
      
      final result = await FirebaseFunctions.instance.httpsCallable('generateDailyTip').call({
        'language': language,
      }).timeout(const Duration(seconds: 20));
      
      final data = result.data as Map<String, dynamic>;
      
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
    await _ensureFirebaseReady();
    
    final result = await FirebaseFunctions.instance.httpsCallable('analyzeDreams').call({
      'dreams': dreams,
      'language': language,
    }).timeout(const Duration(seconds: 90));
    
    final data = result.data as Map<String, dynamic>;
    
    // Log Token Usage if present
    if (data.containsKey('usage')) {
      final usage = data['usage'];
      debugPrint("GPT Usage (analyzeDreams): Input: ${usage['prompt_tokens']}, Output: ${usage['completion_tokens']}, Total: ${usage['total_tokens']}");
    }

    return data['result'] ?? '';
  }

  /// Analyze dreams with moon phase correlation
  Future<String> analyzeMoonSync(List<Map<String, dynamic>> dreamData, String language) async {
    await _ensureFirebaseReady();
    
    final result = await FirebaseFunctions.instance.httpsCallable('analyzeMoonSync').call({
      'dreamData': dreamData,
      'language': language,
    }).timeout(const Duration(seconds: 90));
    
    final data = result.data as Map<String, dynamic>;
    
    // Log Token Usage if present
    if (data.containsKey('usage')) {
      final usage = data['usage'];
      debugPrint("GPT Usage (analyzeMoonSync): Input: ${usage['prompt_tokens']}, Output: ${usage['completion_tokens']}, Total: ${usage['total_tokens']}");
    }

    return data['result'] ?? '';
  }
}
