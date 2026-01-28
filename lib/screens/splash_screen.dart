import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_boat_mobile/screens/home_screen.dart';
import 'package:dream_boat_mobile/widgets/background_sky.dart';
import 'package:dream_boat_mobile/services/firebase_ready_service.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dream_boat_mobile/screens/dream_profile_survey_screen.dart';

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

  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Optimized: 2s instead of 4s
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



    // 4. Text Reveal
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.70, 0.90, curve: Curves.easeIn))
    );

    _controller.forward();

    // Navigate when BOTH animation completes AND Firebase is ready
    _navigateWhenReady();

  }

  /// Navigates to home when both animation and Firebase init are complete
  Future<void> _navigateWhenReady() async {
    // Wait for minimum animation time (1.5s) + Firebase ready (with 3s timeout)
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)), // Minimum splash time
      FirebaseReadyService().waitWithTimeout(timeout: const Duration(seconds: 3)),
    ]);

    if (!mounted) return;

    // Check Onboarding Status
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding_survey') ?? false;

    if (mounted) {
      if (!hasSeenOnboarding) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const DreamProfileSurveyScreen(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    }
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
                            width: 120, height: 120,
                            child: Center(
                              child: Image.asset(
                                'assets/images/db_logo_icon.png',
                                width: 160,
                                height: 160,
                                fit: BoxFit.contain,
                                color: Colors.white,

                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
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
