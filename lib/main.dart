import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dream_boat_mobile/screens/splash_screen.dart';

import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:dream_boat_mobile/services/notification_service.dart';
import 'package:dream_boat_mobile/services/ad_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';

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
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  debugPrint('=== WidgetsFlutterBinding initialized ===');
  
  debugPrint('=== Starting MobileAds init ===');
  MobileAds.instance.initialize();
  debugPrint('=== MobileAds init started (async) ===');
  
  debugPrint('=== Starting AdManager init ===');
  AdManager.instance.initialize();
  debugPrint('=== AdManager initialized ===');
  
  // Initialize notification service with error handling
  try {
    debugPrint('=== Starting NotificationService init ===');
    await NotificationService().init();
    debugPrint('=== NotificationService initialized successfully ===');
  } catch (e) {
    debugPrint('=== NotificationService initialization failed: $e ===');
  }
  
  // Restore scheduled notifications if previously enabled
  try {
    debugPrint('=== Starting SharedPreferences ===');
    final prefs = await SharedPreferences.getInstance();
    debugPrint('=== SharedPreferences loaded ===');
    final notifEnabled = prefs.getBool('notif_enabled') ?? false;
    if (notifEnabled) {
      final hour = prefs.getInt('notif_hour') ?? 9;
      final minute = prefs.getInt('notif_minute') ?? 0;
      final message = prefs.getString('notif_message'); // Use saved localized message
      await NotificationService().scheduleDailyNotification(TimeOfDay(hour: hour, minute: minute), message: message);
      debugPrint('=== Restored scheduled notification for $hour:$minute ===');
    }
  } catch (e) {
    debugPrint('=== Failed to restore notifications: $e ===');
  }
  
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
      title: 'DreamBoat', // Updated Title
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
