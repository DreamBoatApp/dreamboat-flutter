import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dream_boat_mobile/screens/splash_screen.dart';

import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:dream_boat_mobile/services/notification_service.dart';
import 'package:dream_boat_mobile/services/ad_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:dream_boat_mobile/services/firebase_ready_service.dart';

void main() async {
  debugPrint('=== MAIN START ===');
  WidgetsFlutterBinding.ensureInitialized();
  
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

  debugPrint('=== WidgetsFlutterBinding initialized ===');
  
  debugPrint('=== Starting runApp ===');
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        debugPrint('=== Creating SubscriptionProvider ===');
        return SubscriptionProvider();
      },
      child: const MyApp(),
    ),
  );
  debugPrint('=== runApp completed ===');
  
  // Defer heavy initialization until after the first frame is drawn
  // This prevents the native splash screen from hanging due to main thread contention
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    debugPrint('=== First Frame Rendered: Starting Background Init (Delayed) ===');
    
    // YIELD execution to let the engine actually present the frame to the user
    // This allows the native splash to disappear and our Flutter Splash to show
    await Future.delayed(const Duration(milliseconds: 1500));
    
    debugPrint('=== Background Init: Waking up ===');

    // Initialize MobileAds (non-blocking)
    MobileAds.instance.initialize();
    AdManager.instance.initialize();
    
    // Do Firebase/AppCheck and notification setup
    _initFirebaseInBackground();
    _initNotificationsInBackground();
  });
}

// Background Firebase initialization - does not block app startup
Future<void> _initFirebaseInBackground() async {
  try {
    debugPrint('=== Background: Starting Firebase init ===');
    await Firebase.initializeApp();
    debugPrint('=== Background: Firebase initialized ===');
    
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
      final hour = prefs.getInt('notif_hour') ?? 9;
      final minute = prefs.getInt('notif_minute') ?? 0;
      final message = prefs.getString('notif_message');
      await NotificationService().scheduleDailyNotification(TimeOfDay(hour: hour, minute: minute), message: message);
      debugPrint('=== Background: Restored scheduled notification for $hour:$minute ===');
    }
  } catch (e) {
    debugPrint('=== Background: Notification init failed: $e ===');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('tr');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const SplashScreen(),
    );
  }
}
