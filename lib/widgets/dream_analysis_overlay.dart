import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:dream_boat_mobile/l10n/app_localizations.dart';

/// Fullscreen Dream Analysis Overlay
/// Shows animated step-by-step messages during AI interpretation
class DreamAnalysisOverlay extends StatefulWidget {
  const DreamAnalysisOverlay({super.key});

  @override
  State<DreamAnalysisOverlay> createState() => _DreamAnalysisOverlayState();
}

class _DreamAnalysisOverlayState extends State<DreamAnalysisOverlay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _starController;
  late AnimationController _rotationController;
  
  int _currentStep = 0;
  static const int _stepCount = 5;
  Timer? _stepTimer;
  
  // Star particles
  final List<_Star> _stars = [];
  
  @override
  void initState() {
    super.initState();
    
    // Pulsating glow animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    // Star animation for flowing effect
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    
    // Rotation for the inner orb core
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    
    // Generate stars
    final random = math.Random();
    for (int i = 0; i < 40; i++) {
      _stars.add(_Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 1.5 + 0.5,
        speed: random.nextDouble() * 0.3 + 0.1,
        opacity: random.nextDouble() * 0.4 + 0.2,
      ));
    }
    
    // Start text cycling
    _startStepCycle();
  }
  
  void _startStepCycle() {
    _stepTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (!mounted) return;
      setState(() {
        if (_currentStep < _stepCount - 1) {
          _currentStep++;
        } else {
          // Loop between the last two steps to show activity continues
           _currentStep = 3; 
        }
      });
    });
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _starController.dispose();
    _rotationController.dispose();
    _stepTimer?.cancel();
    super.dispose();
  }
  
  String _getStepText(AppLocalizations t, int step) {
    switch (step) {
      case 0:
        return t.analysisStep1;
      case 1:
        return t.analysisStep2;
      case 2:
        return t.analysisStep3;
      case 3:
        return t.analysisStep4;
      case 4:
      default:
        return t.analysisStep5;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    
    return PopScope(
      canPop: false, // Prevent back button during analysis
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Blurred dark background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: const Color(0xFF0F0F23).withValues(alpha: 0.95),
              ),
            ),
            
            // Flowing stars
            AnimatedBuilder(
              animation: _starController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _StarPainter(_stars, _starController.value),
                );
              },
            ),
            
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // Pulsating Glow Orb - Organic & Soft (No sharp lines)
                   SizedBox(
                     width: 140,
                     height: 140,
                     child: Stack(
                       alignment: Alignment.center,
                       children: [
                         // Layer 1: The Aura (Wide, faint, soft expansion)
                         AnimatedBuilder(
                           animation: _pulseController,
                           builder: (context, child) {
                             final val = Curves.easeInOutSine.transform(_pulseController.value);
                             final scale = 1.0 + (val * 0.25); // Expands significantly
                             final opacity = 0.1 + (val * 0.15); // Faint to slightly visible
                             
                             return Transform.scale(
                               scale: scale,
                               child: Container(
                                 decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   // Pure radial blur for softness
                                   boxShadow: [
                                     BoxShadow(
                                       color: const Color(0xFF8B5CF6).withOpacity(opacity),
                                       blurRadius: 60,
                                       spreadRadius: 10,
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           },
                         ),
                         
                         // Layer 2: The Energy Body (Soft purple nebula)
                         AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final val = Curves.easeInOutSine.transform(_pulseController.value);
                              final scale = 0.9 + (val * 0.15);
                              final opacity = 0.3 + (val * 0.2);
                              
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // Soft radial gradient, no sharp stops
                                    gradient: RadialGradient(
                                      colors: [
                                        const Color(0xFFA78BFA).withOpacity(opacity),
                                        const Color(0xFFA78BFA).withOpacity(0.0),
                                      ],
                                      stops: const [0.2, 1.0],
                                    ),
                                  ),
                                ),
                              );
                            },
                         ),
                         
                         // Layer 3: The "Living" Core (Intense, breathing light)
                         AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              // Beat slightly faster/different curve
                              final val = Curves.easeInOutQuad.transform(_pulseController.value);
                              final scale = 0.85 + (val * 0.2); 
                              final opacity = 0.7 + (val * 0.3); // Never fully transparent
                              
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // Bright center, fading out quickly
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.95),
                                        const Color(0xFFE9D5FF).withOpacity(0.8), // Pale purple
                                        const Color(0xFFA78BFA).withOpacity(0.0), // Transparent purple
                                      ],
                                      stops: const [0.0, 0.4, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(opacity * 0.5),
                                        blurRadius: 30,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                         ),
                       ],
                     ),
                   ),
                  
                  // Increased spacing
                  const SizedBox(height: 80),
                  
                  // Animated Text with Switcher
                  SizedBox(
                    height: 80, // Fixed height to prevent layout jumps
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                         // Slide from bottom (entrance) and fade
                         final offsetAnimation = Tween<Offset>(
                           begin: const Offset(0.0, 0.5),
                           end: Offset.zero,
                         ).animate(CurvedAnimation(
                           parent: animation, 
                           curve: Curves.easeOutBack
                         ));
                         
                         return FadeTransition(
                           opacity: animation,
                           child: SlideTransition(
                             position: offsetAnimation,
                             child: child,
                           ),
                         );
                      },
                      child: Text(
                        _getStepText(t, _currentStep),
                        key: ValueKey<int>(_currentStep), // Crucial for AnimatedSwitcher
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  
                  // Removed dots indicator
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Star {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
  
  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double animationValue;
  
  _StarPainter(this.stars, this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      // Calculate flowing position (moving up slowly for dreamy effect)
      final y = (star.y - animationValue * star.speed) % 1.0;
      
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: star.opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(star.x * size.width, y.abs() * size.height),
        star.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}
