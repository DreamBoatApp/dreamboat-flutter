import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:dream_boat_mobile/l10n/app_localizations.dart';

class PremiumVisualizeButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const PremiumVisualizeButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  State<PremiumVisualizeButton> createState() => _PremiumVisualizeButtonState();
}

class _PremiumVisualizeButtonState extends State<PremiumVisualizeButton> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textOpacityAnimation;
  
  late AnimationController _pulseController;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    // Press Animation Controller
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Slower, more fluid
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    _textOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeInOut));

    // Continuous Pulse/Rotation Controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    // Subtle icon rotation/wave
    _iconRotationAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine)
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      _pressController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      _pressController.reverse();
      widget.onTap();
    }
  }

  void _onTapCancel() {
    if (!widget.isLoading) {
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pressController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          height: 72, // Taller size
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), // Soft Squircle
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF59E0B), // Standard Gold
                Color(0xFFD97706), // Amber
                Color(0xFF4C1D95), // Deep Purple (Mystic Door effect)
              ],
              stops: [0.0, 0.4, 1.0], 
            ),
            boxShadow: [
              // Soft Glass Shadow (Bottom)
              BoxShadow(
                color: const Color(0xFFF59E0B).withOpacity(0.25), // Gold glow
                blurRadius: 24,
                spreadRadius: -4,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 0. Inner Lighting / Bevel Simulation
              // Top-Left Highlight
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4],
                    ),
                  ),
                ),
              ),
              // Bottom-Right Shadow
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4],
                    ),
                  ),
                ),
              ),




              // 2. Content Layer
              Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Opacity(
                          opacity: _textOpacityAnimation.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Main Title
                              Text(
                                AppLocalizations.of(context)!.visualizeDream,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Subtitle
                              Text(
                                AppLocalizations.of(context)!.visualizeDreamSubtitle,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              
              
              // 4. Shine Overlay (Animating or Static)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3],
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
}
