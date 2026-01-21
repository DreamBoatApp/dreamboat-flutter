import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';
import 'package:dream_boat_mobile/widgets/particle_overlay.dart';
import 'package:dream_boat_mobile/theme/app_theme.dart';

class SatisfactionModal extends StatelessWidget {
  final VoidCallback onSatisfied;
  final VoidCallback onNeutralOrNegative;

  const SatisfactionModal({
    super.key,
    required this.onSatisfied,
    required this.onNeutralOrNegative,
  });

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



              // 4. Glass Effect & Content
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Subtle blur over particles
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.bgStart.withOpacity(0.4), // Subtle tint
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
                      // Header Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                          boxShadow: [
                             BoxShadow(
                               color: AppTheme.secondary.withOpacity(0.3),
                               blurRadius: 15,
                               spreadRadius: 2,
                            ),
                          ]
                        ),
                        child: Image.asset(
                          'assets/images/db_logo_icon.png',
                          width: 58, // Increased size
                          height: 58, // Increased size
                          color: const Color(0xFF6366F1), // Indigo accent
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Title
                      Text(
                        t.reviewSatisfactionTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtitle
                      Text(
                        t.reviewSatisfactionContent,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Options Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start, // Align to top to handle varying text heights
                        children: [
                          Expanded(
                            child: _buildOption(
                              context,
                              icon: LucideIcons.cloudRain,
                              color: const Color(0xFF60A5FA), // Blue
                              label: t.reviewOptionNo,
                              onTap: onNeutralOrNegative,
                            ),
                          ),
                          Expanded(
                            child: _buildOption(
                              context,
                              icon: LucideIcons.meh,
                              color: const Color(0xFF9CA3AF), // Gray
                              label: t.reviewOptionNeutral,
                              onTap: onNeutralOrNegative,
                            ),
                          ),
                          Expanded(
                            child: _buildOption(
                              context,
                              icon: LucideIcons.heart,
                              color: const Color(0xFFEC4899), // Pink
                              label: t.reviewOptionYes,
                              onTap: onSatisfied,
                              isPrimary: true,
                            ),
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // 3. Close Button (Correctly placed on top)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // Subtle background
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      size: 24,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Wrapper to ensure consistent height for alignment
          Container(
            height: 70, // Increased to accommodate the largest button (primary)
            width: 70,
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // Increased difference between primary and neutral
                color: color.withOpacity(isPrimary ? 0.3 : 0.08), 
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(isPrimary ? 1.0 : 0.3),
                  width: isPrimary ? 2 : 1.5,
                ),
                boxShadow: isPrimary ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ] : null,
              ),
              child: Icon(
                icon,
                size: isPrimary ? 36 : 28, // Made primary slightly bigger
                color: color.withOpacity(isPrimary ? 1.0 : 0.8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.white.withOpacity(isPrimary ? 1.0 : 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
