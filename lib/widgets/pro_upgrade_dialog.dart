import 'package:flutter/material.dart';
import 'package:dream_boat_mobile/widgets/glass_card.dart';
import 'package:dream_boat_mobile/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:dream_boat_mobile/providers/subscription_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/services/connectivity_service.dart';

class ProUpgradeDialog extends StatefulWidget {
  const ProUpgradeDialog({super.key});

  @override
  State<ProUpgradeDialog> createState() => _ProUpgradeDialogState();
}

class _ProUpgradeDialogState extends State<ProUpgradeDialog> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _handlePurchase() async {
    final isConnected = await ConnectivityService.isConnected;
    if (!isConnected) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.offlinePurchase),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      await context.read<SubscriptionProvider>().purchasePro();
      if (mounted) {
         Navigator.pop(context);
         // Show celebratory success dialog
         showDialog(
           context: context,
           barrierDismissible: false,
           builder: (ctx) => _ProSuccessDialog(),
         );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1a1a2e),
                  const Color(0xFF0f0f1a),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFFBBF24).withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFBBF24).withOpacity(0.1),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                  // Mystical Header with shimmer
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: const [
                              Color(0xFFFBBF24),
                              Color(0xFFFFE082),
                              Color(0xFFFBBF24),
                            ],
                            stops: [
                              (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                              _shimmerController.value,
                              (_shimmerController.value + 0.3).clamp(0.0, 1.0),
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: const Text(
                          "DreamBoat PRO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.proUpgradeSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7), 
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Benefits with mystical design
                  _buildMysticalBenefit(
                    icon: LucideIcons.ban,
                    title: t.proFeatureAdsTitle,
                    subtitle: t.proFeatureAdsSubtitle,
                  ),
                  _buildMysticalBenefit(
                    icon: LucideIcons.brainCircuit,
                    title: t.proFeatureAnalysisTitle,
                    subtitle: t.proFeatureAnalysisSubtitle,
                  ),
                  _buildMysticalBenefit(
                    icon: LucideIcons.bookOpen,
                    title: t.proFeatureGuideTitle,
                    subtitle: t.proFeatureGuideSubtitle,
                  ),

                  const SizedBox(height: 28),

                  // Premium unlock button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFBBF24).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CustomButton(
                      text: t.upgradeBtn,
                      isLoading: _isLoading,
                      loadingText: t.proProcessing,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFBBF24), Color(0xFFD97706), Color(0xFFB45309)]
                      ),
                      onPressed: _handlePurchase,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      tapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      t.upgradeCancel, 
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4), 
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
               ],
            ),
          ),
        ),
            ),
          // X Close Button at top right (inside bounds)
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.white.withOpacity(0.15),
                highlightColor: Colors.white.withOpacity(0.08),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMysticalBenefit({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFBBF24).withOpacity(0.08),
            const Color(0xFFFBBF24).withOpacity(0.02),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFBBF24).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Container(
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               gradient: RadialGradient(
                 colors: [
                   const Color(0xFFFBBF24).withOpacity(0.2),
                   const Color(0xFFFBBF24).withOpacity(0.05),
                 ],
               ),
             ),
             child: Icon(icon, color: const Color(0xFFFBBF24), size: 22),
           ),
           const SizedBox(width: 14),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Flexible(
                       child: Text(
                         title, 
                         style: const TextStyle(
                           color: Colors.white, 
                           fontWeight: FontWeight.w600, 
                           fontSize: 16,
                           letterSpacing: 0.3,
                         ),
                       ),
                     ),
                     if (badge != null) ...[
                       const SizedBox(width: 8),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                         decoration: BoxDecoration(
                           gradient: const LinearGradient(
                             colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                           ),
                           borderRadius: BorderRadius.circular(6),
                         ),
                         child: Text(
                           badge,
                           style: const TextStyle(
                             color: Colors.white,
                             fontSize: 10,
                             fontWeight: FontWeight.bold,
                             letterSpacing: 0.5,
                           ),
                         ),
                       ),
                     ],
                   ],
                 ),
                 const SizedBox(height: 6),
                 Text(
                   subtitle, 
                   style: TextStyle(
                     color: Colors.white.withOpacity(0.6), 
                     fontSize: 13,
                     height: 1.4,
                   ),
                 ),
               ],
             ),
           )
        ],
      ),
    );
  }
}

// Celebratory Success Dialog after PRO purchase
class _ProSuccessDialog extends StatefulWidget {
  @override
  State<_ProSuccessDialog> createState() => _ProSuccessDialogState();
}

class _ProSuccessDialogState extends State<_ProSuccessDialog> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacityAnimation.value,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFFFBBF24).withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFBBF24).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  // Welcome Message
                  Text(
                    t.upgradeSuccess,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Golden Start Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBBF24),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(48, 48),
                        tapTargetSize: MaterialTapTargetSize.padded,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFFFBBF24).withOpacity(0.5),
                      ),
                      child: Text(
                        t.upgradeStart,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
