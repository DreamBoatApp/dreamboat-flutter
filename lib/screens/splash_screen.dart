import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/screens/home_screen.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Animation Intervals (Total 3.0s)
  // 0.0 - 0.2: Delay
  // 0.2 - 0.6: Phase 1: Cosmic Seed (Fade In)
  // 0.6 - 1.2: Phase 2: Big Bang (Seed scales down, Logo scales up/Fades in)
  // 1.2 - 2.2: Phase 3: Constellation Lines (Draw)
  // 2.2 - 2.8: Phase 4: Text Fade In
  // 2.8 - 3.5: Phase 5: Hold & Exit

  late Animation<double> _seedOpacity;
  late Animation<double> _seedScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _linesProgress;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Slightly longer for smooth hold
    );

    // 1. Cosmic Seed
    _seedOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.05, 0.15, curve: Curves.easeIn))
    );
    // Scales up then shrinks rapidly into nothing
    _seedScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.15, 0.35, curve: Curves.easeInOut))
    );

    // 2. Logo Reveal (Explosion from Seed)
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.30, 0.40, curve: Curves.easeIn))
    );
    _logoScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.30, 0.50, curve: Curves.elasticOut))
    );

    // 3. Constellation Lines
    _linesProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.50, 0.80, curve: Curves.easeInOut))
    );

    // 4. Text Reveal
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.70, 0.90, curve: Curves.easeIn))
    );

    _controller.forward();

    // Navigate
    Future.delayed(const Duration(milliseconds: 3800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 1000),
          ),
        );
      }
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NightSkyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Phase 1: Cosmic Seed (The Star)
                  Transform.scale(
                    scale: _seedScale.value,
                    child: Opacity(
                      opacity: _seedOpacity.value > 1.0 ? 1.0 : _seedOpacity.value, // Clamp
                      child: Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.blue.withOpacity(0.8), blurRadius: 20, spreadRadius: 5),
                            BoxShadow(color: Colors.purple.withOpacity(0.5), blurRadius: 40, spreadRadius: 10),
                          ]
                        ),
                      ),
                    ),
                  ),

                  // Phase 2: The Logo (DreamBoat Icon)
                  Transform.scale(
                    scale: _logoScale.value,
                    child: Opacity(
                      opacity: _logoOpacity.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 140, height: 140,
                            child: CustomPaint(
                              painter: _ConstellationLogoPainter(progress: _linesProgress.value),
                              child: const Center(
                                child: Icon(LucideIcons.sailboat, size: 64, color: Color(0xFFFBBF24)), // Golden Boat
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Phase 4: Text
                          Opacity(
                            opacity: _textOpacity.value,
                            child: Column(
                              children: [
                                  Text(
                                  "DreamBoat",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Custom Painter to draw lines connecting nicely around the center icon
class _ConstellationLogoPainter extends CustomPainter {
  final double progress;

  _ConstellationLogoPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45; // Just outside the icon
    
    final paintLine = Paint()
      ..color = const Color(0xFFFBBF24).withOpacity(0.4) // Faint Gold
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final paintDot = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Define 5 points of a pentagon-ish shape roughly framing the boat
    // Angles: -90 (top), -18 (top right), 54 (bottom right), 126 (bottom left), 198 (top left) 
    final angles = [-pi/2, -pi/6, pi/6, pi/2 + pi/6, pi - pi/6, pi + pi/6]; 
    final List<Offset> points = [];

    for (var angle in angles) {
      points.add(Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle)
      ));
    }

    // Draw lines progressively
    int totalSegments = points.length; 
    // We want to connect them sequentially: 0->1, 1->2 ... last->0
    
    // Calculate how many segments we can fully or partially draw based on progress
    double totalPathLength = totalSegments.toDouble();
    double currentDraw = progress * totalPathLength;

    for (int i = 0; i < totalSegments; i++) {
        int nextI = (i + 1) % totalSegments;
        Offset p1 = points[i];
        Offset p2 = points[nextI];

        // Draw Dot at P1
        if (progress > (i / totalSegments)) {
           canvas.drawCircle(p1, 2.0, paintDot);
        }

        if (currentDraw > i) {
          double segmentProgress = (currentDraw - i).clamp(0.0, 1.0);
          Offset target = Offset.lerp(p1, p2, segmentProgress)!;
          canvas.drawLine(p1, target, paintLine);
        }
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationLogoPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
