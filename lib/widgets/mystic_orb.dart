import 'package:flutter/material.dart';
import 'dart:math' as math;

class MysticOrb extends StatefulWidget {
  const MysticOrb({super.key});

  @override
  State<MysticOrb> createState() => _MysticOrbState();
}

class _MysticOrbState extends State<MysticOrb> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
