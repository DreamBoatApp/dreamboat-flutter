import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin = fln.FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    debugPrint('NotificationService: Initializing...');
    try {
      tz.initializeTimeZones();
      debugPrint('NotificationService: Timezone database initialized');
      
      // Get Device Timezone with timeout to prevent blocking on emulator
      String timeZoneName = 'UTC'; // Universal fallback for global compatibility
      try {
        timeZoneName = await FlutterTimezone.getLocalTimezone()
            .timeout(const Duration(seconds: 3), onTimeout: () {
          debugPrint('NotificationService: Timezone lookup timed out, using UTC fallback');
          return 'UTC';
        });
        debugPrint('NotificationService: Got timezone: $timeZoneName');
      } catch (e) {
        debugPrint('NotificationService: Timezone error: $e, using UTC fallback');
      }
      
      // Validate timezone exists in database, fallback to UTC if not found
      try {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
      } catch (e) {
        debugPrint('NotificationService: Invalid timezone $timeZoneName, using UTC');
        tz.setLocalLocation(tz.getLocation('UTC'));
      }

      // Android Settings
      const fln.AndroidInitializationSettings androidSettings = fln.AndroidInitializationSettings('@mipmap/launcher_icon');

      // iOS Settings (Darwin)
      const fln.DarwinInitializationSettings iosSettings = fln.DarwinInitializationSettings(
        requestAlertPermission: true, 
        requestBadgePermission: true, 
        requestSoundPermission: true,
      );

      const fln.InitializationSettings initSettings = fln.InitializationSettings(
        android: androidSettings, 
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(initSettings);
      debugPrint('NotificationService: Initialized successfully with TimeZone: $timeZoneName');
    } catch (e) {
      debugPrint('NotificationService: Initialization error: $e');
    }
  }

  /// Check if notification permission is granted
  Future<bool> isPermissionGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Check if permission was permanently denied
  Future<bool> isPermissionPermanentlyDenied() async {
    final status = await Permission.notification.status;
    return status.isPermanentlyDenied;
  }

  /// Open system notification settings
  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }

  Future<bool?> requestPermissions() async {
    try {
      // Use permission_handler for Android 13+ (more reliable on physical devices)
      final status = await Permission.notification.status;
      debugPrint('NotificationService: Current permission status: $status');
      
      if (status.isGranted) {
        debugPrint('NotificationService: Permission already granted');
        return true;
      }
      
      if (status.isPermanentlyDenied) {
        debugPrint('NotificationService: Permission permanently denied');
        return false;
      }
      
      // Request permission - this triggers the Android system dialog
      final result = await Permission.notification.request();
      debugPrint('NotificationService: Permission request result: $result');
      
      return result.isGranted;
    } catch (e) {
      debugPrint('NotificationService: Permission request error: $e');
      return false;
    }
  }

  Future<bool> scheduleDailyNotification(TimeOfDay time, {String? message}) async {
    try {
      // Cancel existing notifications first
      await _notificationsPlugin.cancelAll();
      
      final notificationBody = message ?? 'Rüyanızı kaydetmeyi unutmayın! 📝';
      
      await _notificationsPlugin.zonedSchedule(
        0, // ID
        'DreamBoat', // Title
        notificationBody, // Body (localized)
        _nextInstanceOfTime(time),
        const fln.NotificationDetails(
          android: fln.AndroidNotificationDetails(
            'daily_reminder_channel',
            'Daily Reminders',
            channelDescription: 'Daily reminder to log your dreams',
            importance: fln.Importance.max,
            priority: fln.Priority.high,
          ),
          iOS: fln.DarwinNotificationDetails(),
        ),
        androidScheduleMode: fln.AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: fln.UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: fln.DateTimeComponents.time,
      );
      debugPrint('NotificationService: Scheduled daily notification for $time');
      return true;
    } catch (e) {
      debugPrint('NotificationService: Schedule error: $e');
      return false;
    }
  }

  Future<bool> showInstantNotification() async {
    try {
      debugPrint('NotificationService: Showing instant notification...');
      await _notificationsPlugin.show(
        999,
        'Test Notification', // Changed from Turkish
        'This is a test notification.', // Changed from Turkish
        const fln.NotificationDetails(
          android: fln.AndroidNotificationDetails(
            'daily_reminder_channel',
            'Daily Reminders',
            channelDescription: 'Daily reminder to log your dreams',
            importance: fln.Importance.max,
            priority: fln.Priority.high,
          ),
          iOS: fln.DarwinNotificationDetails(),
        ),
      );
      return true;
    } catch (e) {
      debugPrint('NotificationService: Instant notification error: $e');
      return false;
    }
  }

  Future<void> cancelAll() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('NotificationService: All notifications cancelled');
    } catch (e) {
      debugPrint('NotificationService: Cancel error: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    
    debugPrint('NotificationService: Scheduling calculation. Now: $now, Target: $time');

    if (scheduledDate.isBefore(now)) {
      debugPrint('NotificationService: Target time is in the past. Adding 1 day.');
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    debugPrint('NotificationService: Final scheduled time: $scheduledDate');
    return scheduledDate;
  }
}
