import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/widgets/particle_overlay.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class FeedbackModal extends StatelessWidget {
  const FeedbackModal({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Stack(
            children: [
               // 1. Nebula Gradient Background
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.bgStart,
                        AppTheme.bgEnd,
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Star Particles
              const Positioned.fill(
                child: ParticleOverlay(
                  particleCount: 20,
                  color: Colors.white,
                ),
              ),

              // 3. Subtle Close Button (X)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      size: 20,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              // 4. Content
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.bgStart.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.secondary.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                          boxShadow: [
                             BoxShadow(
                              color: AppTheme.primary.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ]
                        ),
                        child: const Icon(
                          LucideIcons.messageSquare,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Text(
                        t.reviewFeedbackTitle, // "Görüşlerin bizim için önemli"
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Text(
                        t.reviewFeedbackContent,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Button Row
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                t.reviewCancel,
                                style: TextStyle(color: Colors.white.withOpacity(0.6)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                _sendEmail(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                                shadowColor: const Color(0xFF6366F1).withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ).copyWith(
                                elevation: MaterialStateProperty.all(8),
                                shadowColor: MaterialStateProperty.all(const Color(0xFF6366F1).withOpacity(0.5)),
                              ),
                              child: Text(
                                t.reviewFeedbackButton,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendEmail(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString(); // Fetch before async code
    
    String userId = 'Unknown';
    try {
        userId = await Purchases.appUserID;
    } catch (_) {}

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String os = Platform.isAndroid ? 'Android' : (Platform.isIOS ? 'iOS' : Platform.operatingSystem);

    String body = "\n\n--------------------------------\n"
        "${t.supportTechInfoNote}\n\n"
        "Destek Kimliği (User ID): $userId\n"
        "Uygulama Sürümü: $version ($buildNumber)\n"
        "Platform: $os\n"
        "Dil: $locale";

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@novabloomstudio.com',
      query: 'subject=${Uri.encodeComponent(t.supportEmailSubject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      }
    } catch (e) {
      debugPrint('Could not launch email client: $e');
    }
  }
}
