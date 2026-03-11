import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';


import 'package:dream_boat_mobile/screens/splash_screen.dart';

import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:dream_boat_mobile/services/notification_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:dream_boat_mobile/services/firebase_ready_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dream_boat_mobile/models/dream_entry.dart';
import 'package:dream_boat_mobile/services/biometric_service.dart';

import 'package:intl/date_symbol_data_local.dart'; // [NEW] For date formatting

void main() {
  debugPrint('=== MAIN START ===');
  
  // Guard the entire app execution to catch startup errors
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Hive (Lightweight, keep in main flow)
    await Hive.initFlutter();
    Hive.registerAdapter(DreamEntryAdapter());
    await Hive.openBox<DreamEntry>('dreams');

    // One-time migration: clear stale imageUrls caused by backend template literal bug
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('image_url_migration_v1') ?? false)) {
      final box = Hive.box<DreamEntry>('dreams');
      for (final key in box.keys) {
        final dream = box.get(key);
        if (dream != null && dream.imageUrl != null) {
          // copyWith(imageUrl: null) won't work due to ?? pattern, 
          // so reconstruct without imageUrl
          final cleared = DreamEntry(
            id: dream.id,
            text: dream.text,
            date: dream.date,
            mood: dream.mood,
            secondaryMoods: dream.secondaryMoods,
            moodIntensity: dream.moodIntensity,
            vividness: dream.vividness,
            interpretation: dream.interpretation,
            title: dream.title,
            isFavorite: dream.isFavorite,
            astronomicalEvents: dream.astronomicalEvents,
            guideStage: dream.guideStage,
            cosmicAnalysis: dream.cosmicAnalysis,
            // imageUrl intentionally omitted → null
          );
          await box.put(key, cleared);
        }
      }
      await prefs.setBool('image_url_migration_v1', true);
      debugPrint('=== Migration: Cleared all stale imageUrls ===');
    }

    // Initialize Date Formatting for all locales
    await initializeDateFormatting(); // [NEW] Fix for localized dates
    
    // Edge-to-Edge Config
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, 
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    
    // Lock Orientation to Portrait
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Load saved locale, or detect from OS language on first launch
    final savedLocale = prefs.getString('app_locale');
    final Locale initialLocale;
    if (savedLocale != null) {
      initialLocale = Locale(savedLocale);
    } else {
      // First launch: detect OS language
      final osLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      const supportedCodes = ['tr', 'en', 'es', 'de', 'pt'];
      initialLocale = supportedCodes.contains(osLang)
          ? Locale(osLang)
          : const Locale('en'); // Unsupported OS language → English
      // Save so next launch uses the same
      await prefs.setString('app_locale', initialLocale.languageCode);
    }

    debugPrint('=== Starting runApp (locale: ${initialLocale.languageCode}) ===');
    runApp(
      ChangeNotifierProvider(
        create: (_) => SubscriptionProvider(),
        lazy: false, // [NEW] Force background initialization immediately
        child: MyApp(initialLocale: initialLocale),
      ),
    );
    debugPrint('=== runApp completed ===');
    
    // STRICT BACKGROUND INITIALIZATION
    // We explicitly wait for the first frame to render before touching any heavy SDKs.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('=== First Frame Rendered ===');
      
      // Delay to ensure smooth splash animation start
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('=== Starting Background Tasks ===');
      
      // Initialize in parallel
      Future.wait([
        _initFirebase(),
        _initNotifications()
      ]);
    });
    
  }, (error, stack) {
    debugPrint('=== UNCAUGHT ERROR: $error ===');
    debugPrint(stack.toString());
  });
}

// Separated Init Functions

Future<void> _initFirebase() async {
   await _initFirebaseInBackground(); // Reuse existing function
}

Future<void> _initNotifications() async {
   await _initNotificationsInBackground(); // Reuse existing function
}
// Background Firebase initialization - does not block app startup
Future<void> _initFirebaseInBackground() async {
  try {
    debugPrint('=== Background: Starting Firebase init ===');
    await Firebase.initializeApp();
    debugPrint('=== Background: Firebase initialized ===');
    
    // Authenticate Anonymously for Cloud Functions & Storage Security
    // Retry up to 3 times to handle transient network failures
    UserCredential? userCredential;
    for (int i = 1; i <= 3; i++) {
      try {
        userCredential = await FirebaseAuth.instance.signInAnonymously();
        debugPrint('=== Background: Signed in anonymously UID: ${userCredential.user?.uid} ===');
        break;
      } catch (authErr) {
        debugPrint('=== Background: Auth attempt $i/3 failed: $authErr ===');
        if (i < 3) await Future.delayed(const Duration(seconds: 1));
      }
    }
    if (userCredential == null) {
      debugPrint('=== Background: WARNING — All auth attempts failed! OpenAIService will handle re-auth. ===');
    }

    // Initialize App Check (Security)
    await FirebaseAppCheck.instance.activate(
      androidProvider: kDebugMode 
          ? AndroidProvider.debug 
          : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode 
          ? AppleProvider.debug 
          : AppleProvider.appAttest,
    );
    debugPrint('=== Background: App Check activated (${kDebugMode ? "DEBUG" : "PLAY_INTEGRITY"}) ===');
    
    // Signal that Firebase is ready for splash screen
    FirebaseReadyService().markReady();
  } catch (e) {
    debugPrint('=== Background: Firebase/AppCheck init failed: $e ===');
    // Still mark as ready so splash doesn't wait forever
    FirebaseReadyService().markReady();
  }
}

// Background initialization - does not block app startup
Future<void> _initNotificationsInBackground() async {
  try {
    debugPrint('=== Background: Starting NotificationService init ===');
    await NotificationService().init();
    debugPrint('=== Background: NotificationService initialized ===');
    
    // Restore scheduled notifications if previously enabled
    final prefs = await SharedPreferences.getInstance();
    final notifEnabled = prefs.getBool('notif_enabled') ?? true;
    if (notifEnabled) {
      final hour = prefs.getInt('notif_hour') ?? 7;
      final minute = prefs.getInt('notif_minute') ?? 0;
      final savedLocale = prefs.getString('app_locale') ?? 'tr';
      final cachedLocale = prefs.getString('notif_messages_locale');
      // Use saved localized messages, or regenerate if absent or locale changed
      var messages = prefs.getStringList('notif_messages');
      if (messages == null || messages.isEmpty || cachedLocale != savedLocale) {
        messages = NotificationService.getLocalizedMessages(Locale(savedLocale));
        // Persist so next cold-start doesn't regenerate (unless locale changes again)
        await prefs.setStringList('notif_messages', messages);
        await prefs.setString('notif_messages_locale', savedLocale);
        debugPrint('=== Background: Generated localized messages for locale: $savedLocale (was: $cachedLocale) ===');
      }
      final channelInfo = NotificationService.getLocalizedChannelInfo(Locale(savedLocale));
      await NotificationService().scheduleRotatingNotifications(
        TimeOfDay(hour: hour, minute: minute),
        messages: messages,
        channelName: channelInfo.name,
        channelDesc: channelInfo.desc,
      );
      debugPrint('=== Background: Scheduled rotating notifications for $hour:$minute ===');
    }
  } catch (e) {
    debugPrint('=== Background: Notification init failed: $e ===');
  }
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

// Global RouteObserver to track which screen is currently visible
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late Locale _locale;

  // Biometric overlay state
  bool _showSecureOverlay = false;
  bool _isAuthenticating = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  
  // Track the current visible route name
  String? _currentRouteName;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Get the current route from the navigator explicitly if routeObserver failed to capture it
      var currentRoute = _currentRouteName;
      _navigatorKey.currentState?.popUntil((route) {
        currentRoute = route.settings.name;
        return true; 
      });

      // ONLY show overlay if the user is explicitly on the Journal or Stats screen
      // or NewDreamScreen (which has sensitive dream input)
      final isSensitiveScreen = currentRoute == '/journal' || currentRoute == '/stats' || currentRoute == '/new_dream' || currentRoute == '/dream_detail';
      
      _checkAndShowOverlay(isSensitiveScreen: isSensitiveScreen);
    } else if (state == AppLifecycleState.resumed) {
      if (_showSecureOverlay) {
        _authenticateOnResume();
      }
    }
  }

  Future<void> _checkAndShowOverlay({required bool isSensitiveScreen}) async {
    final lockEnabled = await BiometricService.isJournalLockEnabled();
    if (lockEnabled && mounted && isSensitiveScreen) {
      setState(() {
        _showSecureOverlay = true;
      });
    }
  }

  Future<void> _authenticateOnResume() async {
    if (_isAuthenticating || BiometricService.recentlyAuthenticated) {
      if (BiometricService.recentlyAuthenticated && mounted) {
        setState(() {
          _showSecureOverlay = false;
        });
      }
      return;
    }

    _isAuthenticating = true;
    final authenticated = await BiometricService.authenticate('Verify to access Dream Journal');
    _isAuthenticating = false;

    if (mounted) {
      if (authenticated) {
        setState(() {
          _showSecureOverlay = false;
        });
      }
      // If auth fails, overlay stays — user can re-background and retry
    }
  }

  void setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'DreamBoat',
      theme: AppTheme.theme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      navigatorObservers: [routeObserver],
      home: const SplashScreen(),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            // Full-screen secure overlay — renders on top of EVERYTHING
            if (_showSecureOverlay)
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF0A0A1A),
                  child: Center(
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white.withOpacity(0.15),
                      size: 48,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
