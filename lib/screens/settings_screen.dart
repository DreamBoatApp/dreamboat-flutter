import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/services.dart'; // For Clipboard
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'package:dream_boat_mobile/widgets/glass_card.dart';
import 'package:dream_boat_mobile/widgets/custom_button.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/main.dart'; // To access MyApp for Locale change
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purchases_flutter/purchases_flutter.dart'; // For Support ID

import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:dream_boat_mobile/services/notification_service.dart';
import 'package:dream_boat_mobile/widgets/pro_upgrade_dialog.dart';
import 'package:dream_boat_mobile/widgets/pro_badge.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notificaton State
  bool _notifEnabled = false;
  TimeOfDay _notifTime = const TimeOfDay(hour: 9, minute: 0);
  bool _use24HourFormat = true;
  String _debugTimeZone = '';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    String timezone;
    try {
      timezone = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      timezone = 'Error: $e';
    }

    setState(() {
      _notifEnabled = prefs.getBool('notif_enabled') ?? false;
      _use24HourFormat = prefs.getBool('use_24h_format') ?? true;
      
      final hour = prefs.getInt('notif_hour') ?? 9;
      final minute = prefs.getInt('notif_minute') ?? 0;
      _notifTime = TimeOfDay(hour: hour, minute: minute);
      
      _debugTimeZone = timezone;
    });
  }
  
  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final t = AppLocalizations.of(context)!;
    
    await prefs.setBool('notif_enabled', _notifEnabled);
    await prefs.setBool('use_24h_format', _use24HourFormat);
    await prefs.setInt('notif_hour', _notifTime.hour);
    await prefs.setInt('notif_minute', _notifTime.minute);
    
    // Save localized message for app restart restoration
    final localizedMessage = t.notifReminderBody;
    await prefs.setString('notif_message', localizedMessage);

    if (_notifEnabled) {
      // Check if permission already granted
      final isGranted = await NotificationService().isPermissionGranted();
      if (isGranted) {
        // Permission already granted, just schedule
        await NotificationService().scheduleDailyNotification(_notifTime, message: localizedMessage);
      } else {
        // Need to request permission
        final granted = await NotificationService().requestPermissions();
        if (granted == true) {
          await NotificationService().scheduleDailyNotification(_notifTime, message: localizedMessage);
        } else {
          // Permission denied - check if permanently denied
          final isPermanentlyDenied = await NotificationService().isPermissionPermanentlyDenied();
          if (isPermanentlyDenied && mounted) {
            // Show dialog to open settings
            _showOpenSettingsDialog();
          }
          // Disable the toggle since permission not granted
          setState(() => _notifEnabled = false);
          await prefs.setBool('notif_enabled', false);
        }
      }
    } else {
      await NotificationService().cancelAll();
    }
  }

  void _showOpenSettingsDialog() {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(t.notifPermissionDenied, style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          t.notifOpenSettingsHint,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
              tapTargetSize: MaterialTapTargetSize.padded,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(48, 48),
              tapTargetSize: MaterialTapTargetSize.padded,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              NotificationService().openNotificationSettings();
            },
            child: Text(t.notifOpenSettings, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final isPro = context.watch<SubscriptionProvider>().isPro;

    return NightSkyBackground(
      isPro: isPro,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(t.settingsTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          actions: const [],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _SettingItem(
                    icon: LucideIcons.globe,
                    title: t.settingsLanguage,
                    value: {
                      'tr': 'Türkçe',
                      'en': 'English',
                      'es': 'Español',
                      'pt': 'Português',
                      'de': 'Deutsch',
                    }[currentLocale.languageCode] ?? 'English',
                    onTap: () => _showLanguageModal(context),
                  ),
                  _SettingItem(
                    icon: LucideIcons.activity,
                    title: t.settingsAppStatus, 
                    trailing: isPro 
                       ? const ProBadge() 
                       : Container(
                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                           decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                           child: Text(t.standard, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                         ),
                    onTap: () {
                       if (!isPro) {
                         showDialog(context: context, builder: (ctx) => const ProUpgradeDialog());
                       }
                    }, 
                  ),
                  _SettingItem(
                    icon: LucideIcons.bell,
                    title: t.settingsNotifications,
                    value: _notifEnabled 
                      ? (_use24HourFormat 
                          ? "${_notifTime.hour}:${_notifTime.minute.toString().padLeft(2, '0')}"
                          : "${_notifTime.hourOfPeriod == 0 ? 12 : _notifTime.hourOfPeriod}:${_notifTime.minute.toString().padLeft(2, '0')} ${_notifTime.period == DayPeriod.am ? 'AM' : 'PM'}")
                      : "Off",
                    onTap: () => _showNotificationModal(context),
                  ),
                  _SettingItem(
                    icon: LucideIcons.refreshCw,
                    title: t.settingsRestorePurchases,
                    trailing: context.watch<SubscriptionProvider>().isRestoring 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                          ),
                        )
                      : null,
                    onTap: () => _handleRestorePurchases(context),
                  ),
                  _SettingItem(
                    icon: LucideIcons.shield,
                    title: t.settingsPrivacy,
                    onTap: () => _showPrivacyModal(context),
                  ),
                  _SettingItem(
                    icon: LucideIcons.mail,
                    title: t.settingsSupport,
                    onTap: () => _showSupportModal(context),
                  ),
                  // Support ID Item removed and moved to Support Modal

                   // DEBUG Toggle for Emulator Testing
                  if (kDebugMode)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _SettingItem(
                        icon: LucideIcons.bug,
                        title: "DEBUG: Toggle PRO",
                        value: isPro ? "ACTIVE" : "INACTIVE",
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPro ? Colors.green.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isPro ? Colors.green.withOpacity(0.5) : Colors.amber.withOpacity(0.5)
                            ),
                          ),
                          child: Text(
                            isPro ? "PRO" : "STD",
                            style: TextStyle(
                              color: isPro ? Colors.greenAccent : Colors.amberAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        onTap: () {
                           context.read<SubscriptionProvider>().debugSetProStatus(!isPro);
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text("Debug: PRO status set to ${!isPro}"))
                           );
                        },
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(t.settingsVersion, style: TextStyle(color: AppTheme.textMuted)),
            )
          ],
        ),
      ),
    );
  }

  // Note: Debug reset removed for RevenueCat integration (Milestone 0)

  Future<void> _handleRestorePurchases(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final provider = context.read<SubscriptionProvider>();
    
    // Don't allow if already restoring
    if (provider.isRestoring) return;
    
    // Check if payment system is still loading
    if (provider.isConfiguring) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.restoreUnavailable)),
      );
      return;
    }
    
    final result = await provider.restorePurchases();
    
    if (!context.mounted) return;
    
    String message;
    switch (result) {
      case 'success':
        message = t.restoreSuccess;
        break;
      case 'not_found':
        message = t.restoreNotFound;
        break;
      case 'not_configured':
        message = t.restoreUnavailable;
        break;
      case 'unavailable':
        message = t.restoreUnavailable;
        break;
      default:
        message = t.restoreError;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showLanguageModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _LanguageModal()
    );
  }

  void _showNotificationModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
      builder: (context, setModalState) {
        final t = AppLocalizations.of(context)!;
        
        final hour = _notifTime.hour;
        final minute = _notifTime.minute.toString().padLeft(2, '0');
        String timeDisplay = "$hour:$minute";
        
        if (!_use24HourFormat) {
          final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
          final period = hour >= 12 ? 'PM' : 'AM';
          timeDisplay = "$h:$minute $period";
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(t.settingsNotifications, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                     IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Colors.grey))
                  ],
                ),
                const SizedBox(height: 20),
                // Enable Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t.settingsNotifOpen, style: const TextStyle(color: Colors.white)),
                    Switch(
                      value: _notifEnabled, 
                      onChanged: (val) async {
                        setState(() => _notifEnabled = val);
                        setModalState(() {});
                        await _saveNotificationSettings();
                      },
                      activeColor: AppTheme.primary,
                    )
                  ],
                ),
                if (_notifEnabled) ...[
                   const SizedBox(height: 20),
                   // Format Toggle (12h/24h)
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.timeFormat24h, style: const TextStyle(color: Colors.white70)),
                      Switch(
                        value: _use24HourFormat,
                        onChanged: (val) async {
                          setState(() => _use24HourFormat = val);
                          setModalState(() {});
                          await _saveNotificationSettings();
                        },
                        activeColor: AppTheme.secondary,
                      )
                    ],
                   ),
                   const SizedBox(height: 12),
                   
                   Text(t.settingsNotifTime, style: TextStyle(color: AppTheme.textMuted)),
                   const SizedBox(height: 8),
                   GestureDetector(
                     onTap: () {
                        showCupertinoModalPopup(
                          context: context, 
                          builder: (context) => Container(
                            height: 250,
                            padding: const EdgeInsets.only(top: 6.0),
                            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            color: const Color(0xFF1E293B), // Match dialog/surface color
                            child: SafeArea(
                              top: false,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: _use24HourFormat,
                                      initialDateTime: DateTime(2023, 1, 1, _notifTime.hour, _notifTime.minute),
                                      onDateTimeChanged: (DateTime newDateTime) {
                                        setState(() => _notifTime = TimeOfDay.fromDateTime(newDateTime));
                                        setModalState(() {});
                                      },
                                    ),
                                  ),
                                  CupertinoButton(
                                    child: Text(t.save, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await _saveNotificationSettings();
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        );
                     },
                     child: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                       decoration: BoxDecoration(
                         color: Colors.white10, 
                         borderRadius: BorderRadius.circular(8), 
                         border: Border.all(color: Colors.white24)
                       ),
                       child: Text(timeDisplay, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                     ),
                   ),
                   const SizedBox(height: 12),
                   Text(t.settingsNotifDesc, textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                ]
              ],
            )
          )
        );
      }
    ));
  }
  
  void _showPrivacyModal(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(t.privacyTitle, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                     IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Colors.grey))
                  ],
                ),
                const Divider(color: Colors.white24, height: 30),
                
                Text(t.privacyNoticeTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                Text(
                  t.privacyNoticeContent,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 16),
                
                Text(t.privacySection1Title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  t.privacySection1Content,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 16),
                
                Text(t.privacySection2Title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  t.privacySection2Content,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 16),
                
                Text(t.privacySection3Title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  t.privacySection3Content,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 16),

                Text(t.privacySection4Title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  t.privacySection4Content,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
              ]
            ),
          )
        )
    ));
  }
  
  void _showSupportModal(BuildContext context) {
     final t = AppLocalizations.of(context)!;
     showDialog(
       context: context, 
       builder: (ctx) => const _SupportDialog()
     );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData? icon; // Made optional
  final String title;
  final String? value;
  final Widget? trailing; // New support for widgets like badges
  final VoidCallback onTap;

  const _SettingItem({this.icon, required this.title, this.value, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
           Row(
             children: [
               if (trailing != null) 
                 trailing!
               else if (value != null) 
                 Text(value!, style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
                 
               const SizedBox(width: 8),
               const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 16)
             ],
           )
        ],
      ),
    );
  }
}

class _LanguageModal extends StatelessWidget {
  // Dark purple color palette (matching app theme)
  static const _primaryPurple = Color(0xFFA78BFA);
  static const _accentPurple = Color(0xFF8B5CF6);
  static const _deepPurple = Color(0xFF1E1B35);
  static const _darkPurple = Color(0xFF0F0D1A);

  @override
  Widget build(BuildContext context) {
     final t = AppLocalizations.of(context)!;
     
     final languages = [
       {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
       {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
       {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
       {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
       {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
     ];

     return Dialog(
       backgroundColor: Colors.transparent,
       child: Container(
         padding: const EdgeInsets.all(24),
         decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _deepPurple.withOpacity(0.98),
                _darkPurple.withOpacity(0.99),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _primaryPurple.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _accentPurple.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: -5,
                offset: const Offset(0, 10),
              ),
            ],
         ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [_primaryPurple, const Color(0xFFD8B4FE)],
                      ).createShader(bounds),
                      child: Text(
                        t.settingsLanguage, 
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                   ),
                   IconButton(
                     onPressed: () => Navigator.pop(context), 
                     icon: const Icon(LucideIcons.x, color: Colors.white54),
                     padding: EdgeInsets.zero,
                     constraints: const BoxConstraints(),
                   )
                ],
              ),
              const SizedBox(height: 20),
              ...languages.map((lang) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _LangOption(
                    label: lang['name']!, 
                    flag: lang['flag']!, 
                    code: lang['code']!, 
                    context: context
                  ),
                )
              ),
           ],
         )
       ),
     );
  }

  Widget _LangOption({required String label, required String flag, required String code, required BuildContext context}) {
    final isSelected = Localizations.localeOf(context).languageCode == code;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
           MyApp.setLocale(context, Locale(code));
           Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: _LanguageModal._primaryPurple.withOpacity(0.15),
        highlightColor: _LanguageModal._primaryPurple.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _LanguageModal._accentPurple.withOpacity(0.25),
                      _LanguageModal._primaryPurple.withOpacity(0.15),
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? _LanguageModal._primaryPurple.withOpacity(0.5)
                  : Colors.white.withOpacity(0.08),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: _LanguageModal._primaryPurple.withOpacity(0.15),
                      blurRadius: 12,
                      spreadRadius: -2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
               Container(
                 width: 36,
                 height: 36,
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.08),
                   borderRadius: BorderRadius.circular(10),
                   border: Border.all(color: Colors.white.withOpacity(0.1)),
                 ),
                 child: Center(child: Text(flag, style: const TextStyle(fontSize: 20))),
               ),
               const SizedBox(width: 14),
               Expanded(
                 child: Text(
                   label, 
                   style: TextStyle(
                     color: isSelected ? Colors.white : Colors.white70, 
                     fontSize: 16, 
                     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400
                   )
                 )
               ),
               if (isSelected) 
                 Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_LanguageModal._accentPurple, _LanguageModal._primaryPurple],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                         BoxShadow(
                           color: _LanguageModal._primaryPurple.withOpacity(0.4),
                           blurRadius: 6,
                         ),
                      ],
                    ),
                    child: const Icon(LucideIcons.check, color: Colors.white, size: 14),
                 )
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportDialog extends StatefulWidget {
  const _SupportDialog();

  @override
  State<_SupportDialog> createState() => _SupportDialogState();
}

class _SupportDialogState extends State<_SupportDialog> {
  String? _userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      final userId = await Purchases.appUserID;
      if (mounted) {
        setState(() {
          _userId = userId;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error getting user ID: $e');
      if (mounted) {
        setState(() {
          _userId = null;
          _isLoading = false;
        });
      }
    }
  }

  void _copyToClipboard() {
    if (_userId != null) {
      Clipboard.setData(ClipboardData(text: _userId!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.settingsSupportIdCopied)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(t.supportTitle, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                   IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Colors.grey))
                ],
              ),
              const SizedBox(height: 16),
              Text(
                t.supportContent, 
                style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)
              ),
              const SizedBox(height: 24),
              
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFA78BFA), Color(0xFFEC4899)]), // Purple to Pink
                  borderRadius: BorderRadius.circular(12)
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16)
                  ),
                  icon: const Icon(LucideIcons.mail, color: Colors.white),
                  label: Text(t.supportSendEmail, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  onPressed: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    String version = packageInfo.version;
                    String buildNumber = packageInfo.buildNumber;
                    String os = Platform.isAndroid ? 'Android' : (Platform.isIOS ? 'iOS' : Platform.operatingSystem);
                    String locale = Localizations.localeOf(context).toString();
                    
                    String body = "\n\n--------------------------------\n"
                        "${t.supportTechInfoNote}\n\n"
                        "${t.emailLabelSupportId}: ${_userId ?? 'Unknown'}\n"
                        "${t.emailLabelAppVersion}: $version ($buildNumber)\n"
                        "${t.emailLabelPlatform}: $os\n"
                        "${t.emailLabelLanguage}: $locale";

                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'info@novabloomstudio.com',
                      query: 'subject=${Uri.encodeComponent(t.supportEmailSubject)}&body=${Uri.encodeComponent(body)}',
                    );

                    try {
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                         if (context.mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.supportEmailNotFound)));
                         }
                      }
                    } catch (e) {
                      debugPrint("Error launching email: $e");
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Email
              const Center(
                child: Text("info@novabloomstudio.com", style: TextStyle(color: Colors.white38, fontSize: 12)),
              ),

              const SizedBox(height: 16),

              // Separator
              const Divider(color: Colors.white10),

              const SizedBox(height: 12),

              // Support ID
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(t.settingsSupportId, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                   const SizedBox(width: 8),
                   if (_isLoading)
                     const SizedBox(
                        width: 14, height: 14, 
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white38))
                     )
                   else
                     Text(
                       _userId != null && _userId!.length > 16
                           ? '${_userId!.substring(0, 8)}...${_userId!.substring(_userId!.length - 4)}'
                           : _userId ?? '...',
                       style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'),
                     ),
                   const SizedBox(width: 8),
                   InkWell(
                     onTap: _copyToClipboard,
                     borderRadius: BorderRadius.circular(8),
                     child: const Padding(
                       padding: EdgeInsets.all(4.0),
                       child: Icon(LucideIcons.copy, color: Colors.white38, size: 14),
                     ),
                   )
                ],
              )
            ]
          )
        )
     );
  }
}
