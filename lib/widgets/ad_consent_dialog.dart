import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/widgets/gradient_text.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:dream_boat_mobile/widgets/pro_upgrade_dialog.dart';
import 'package:provider/provider.dart';

class AdConsentDialog extends StatefulWidget {
  final VoidCallback onWatchAd;
  final VoidCallback onRetry;
  final bool isAdLoaded;

  const AdConsentDialog({
    super.key,
    required this.onWatchAd,
    required this.onRetry,
    required this.isAdLoaded,
  });

  @override
  State<AdConsentDialog> createState() => _AdConsentDialogState();
}

class _AdConsentDialogState extends State<AdConsentDialog> {
  Future<void> _handleGoPro(BuildContext context) async {
    // Show Pro Dialog (Don't close current dialog yet)
    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => const ProUpgradeDialog(),
    );

    // After dialog closes (either by cancel or success), check status
    if (!mounted) return;
    
    final isPro = context.read<SubscriptionProvider>().isPro;
    if (isPro) {
      Navigator.pop(context); // Close AdConsentDialog
      widget.onWatchAd(); // Trigger "Proceed" flow
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isLoaded = widget.isAdLoaded;

    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                // Deep space gradient background for premium feel
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1A1A2E).withOpacity(0.9), // Dark Navy
                    const Color(0xFF16213E).withOpacity(0.9), // Slightly lighter
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  // Subtle inner glow
                  BoxShadow(
                    color: const Color(0xFF6D28D9).withOpacity(0.2), // Purple glow
                    blurRadius: 20,
                    spreadRadius: -10,
                  )
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Space for X button
                      const SizedBox(height: 10), 

                      // Title
                      GradientText(
                        t.adConsentTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        gradient: const LinearGradient(
                          colors: [Colors.white, Color(0xFFE0E7FF)],
                        ),
                      ),
                      const SizedBox(height: 16),

                  // Body Text
                  Text(
                    isLoaded ? t.adConsentBody : t.adLoadError,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Actions
                  if (isLoaded) ...[
                    // Watch Ad Button
                     _buildPrimaryButton(
                      context,
                      label: t.adConsentWatch,
                      icon: LucideIcons.play,
                      onTap: () {
                         Navigator.pop(context); // Close dialog
                         widget.onWatchAd();
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    // Pro Button
                    _buildSecondaryButton(
                      context,
                      label: t.adConsentPro,
                      icon: LucideIcons.crown,
                      onTap: () => _handleGoPro(context),
                    ),
                  ] else ...[
                     // Retry Button
                     _buildPrimaryButton(
                      context,
                      label: t.adRetry,
                      icon: LucideIcons.refreshCw,
                      onTap: widget.onRetry,
                    ),
                    const SizedBox(height: 12),

                     // Pro Button (Still valid if ad fails)
                     _buildSecondaryButton(
                      context,
                      label: t.adConsentPro,
                      icon: LucideIcons.crown,
                      onTap: () => _handleGoPro(context),
                    ),
                  ],
                  
                  // Footer info
                  // Footer info removed per user request
                ],
              ),
              Positioned(
                right: -12,
                top: -12,
                child: IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white30, size: 24),
                  splashRadius: 20,
                  onPressed: () => Navigator.pop(context, 'back'),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
  
  Widget _buildPrimaryButton(BuildContext context, {
    required String label, 
    required IconData icon, 
    required VoidCallback onTap 
  }) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)], // Signature Blue-Purple
          ),
          boxShadow: [
             BoxShadow(
               color: const Color(0xFF8B5CF6).withOpacity(0.4),
               blurRadius: 12,
               offset: const Offset(0, 4),
             )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(icon, color: Colors.white, size: 20),
                   const SizedBox(width: 8),
                   Flexible(
                     child: Text(
                       label,
                       textAlign: TextAlign.center,
                       style: const TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: 15,
                       ),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildSecondaryButton(BuildContext context, {
    required String label, 
    required IconData icon, 
    required VoidCallback onTap 
  }) {
      return Container(
        width: double.infinity,
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5)), // Gold border for PRO
          color: const Color(0xFFFFD700).withOpacity(0.1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(icon, color: const Color(0xFFFFD700), size: 20),
                   const SizedBox(width: 8),
                   Flexible(
                     child: Text(
                       label,
                       textAlign: TextAlign.center,
                       style: const TextStyle(
                         color: Color(0xFFFFD700), // Gold text
                         fontWeight: FontWeight.w600,
                         fontSize: 15,
                       ),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}

extension DisplayIf on Widget {
   Widget displayIf(bool condition) => condition ? this : const SizedBox.shrink();
}
