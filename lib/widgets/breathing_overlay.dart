import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:dream_boat_mobile/l10n/app_localizations.dart';

/// Fullscreen Breathing Overlay for WILD technique
/// 4-4-6 breathing cycle: Inhale (4s), Hold (4s), Exhale (6s) = 14s total
class BreathingOverlay extends StatefulWidget {
  const BreathingOverlay({super.key});

  @override
  State<BreathingOverlay> createState() => _BreathingOverlayState();
}

class _BreathingOverlayState extends State<BreathingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _starController;
  
  // Breathing phases (in seconds)
  static const int inhaleSeconds = 4;
  static const int holdSeconds = 4;
  static const int exhaleSeconds = 6;
  static const int totalSeconds = inhaleSeconds + holdSeconds + exhaleSeconds; // 14s
  
  // Star particles
  final List<_Star> _stars = [];
  
  @override
  void initState() {
    super.initState();
    
    // Breathing animation: 14 second cycle, repeating
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: totalSeconds),
    )..repeat();
    
    // Star animation for flowing effect
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    // Generate stars
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _stars.add(_Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 1,
        speed: random.nextDouble() * 0.5 + 0.2,
        opacity: random.nextDouble() * 0.5 + 0.3,
      ));
    }
  }
  
  @override
  void dispose() {
    _breathController.dispose();
    _starController.dispose();
    super.dispose();
  }
  
  // Get current phase based on animation value
  _BreathPhase _getCurrentPhase(double progress) {
    final currentSecond = progress * totalSeconds;
    if (currentSecond < inhaleSeconds) {
      return _BreathPhase.inhale;
    } else if (currentSecond < inhaleSeconds + holdSeconds) {
      return _BreathPhase.hold;
    } else {
      return _BreathPhase.exhale;
    }
  }
  
  // Get circle scale based on phase
  double _getScale(double progress) {
    final currentSecond = progress * totalSeconds;
    
    if (currentSecond < inhaleSeconds) {
      // Inhale: scale from 1.0 to 1.5
      final phaseProgress = currentSecond / inhaleSeconds;
      return 1.0 + (0.5 * phaseProgress);
    } else if (currentSecond < inhaleSeconds + holdSeconds) {
      // Hold: stay at 1.5
      return 1.5;
    } else {
      // Exhale: scale from 1.5 to 1.0
      final phaseProgress = (currentSecond - inhaleSeconds - holdSeconds) / exhaleSeconds;
      return 1.5 - (0.5 * phaseProgress);
    }
  }
  
  String _getPhaseText(AppLocalizations t, _BreathPhase phase) {
    switch (phase) {
      case _BreathPhase.inhale:
        return t.wildBreathInhale;
      case _BreathPhase.hold:
        return t.wildBreathHold;
      case _BreathPhase.exhale:
        return t.wildBreathExhale;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Dark background with flowing stars
            AnimatedBuilder(
              animation: _starController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _StarPainter(_stars, _starController.value),
                );
              },
            ),
            
            // Dark overlay
            Container(
              color: Colors.black.withOpacity(0.85),
            ),
            
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Breathing circle
                  AnimatedBuilder(
                    animation: _breathController,
                    builder: (context, child) {
                      final progress = _breathController.value;
                      final phase = _getCurrentPhase(progress);
                      final scale = _getScale(progress);
                      
                      Color circleColor;
                      switch (phase) {
                        case _BreathPhase.inhale:
                          circleColor = const Color(0xFF60A5FA); // Blue
                          break;
                        case _BreathPhase.hold:
                          circleColor = const Color(0xFFFBBF24); // Amber
                          break;
                        case _BreathPhase.exhale:
                          circleColor = const Color(0xFF4ADE80); // Green
                          break;
                      }
                      
                      return Column(
                        children: [
                          // Phase text
                          Text(
                            _getPhaseText(t, phase),
                            style: TextStyle(
                              color: circleColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Breathing circle
                          Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    circleColor.withOpacity(0.6),
                                    circleColor.withOpacity(0.2),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.3, 0.7, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: circleColor.withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: circleColor.withOpacity(0.8),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Focus message
                  Text(
                    t.wildBreathFocus,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Tap to exit hint
                  Text(
                    t.wildBreathTapToExit,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _BreathPhase { inhale, hold, exhale }

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
      // Calculate flowing position (moving down slowly)
      final y = (star.y + animationValue * star.speed) % 1.0;
      
      final paint = Paint()
        ..color = Colors.white.withOpacity(star.opacity * 0.5)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(star.x * size.width, y * size.height),
        star.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}
