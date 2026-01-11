import 'package:flutter/material.dart';

class ProBadge extends StatefulWidget {
  const ProBadge({super.key});

  @override
  State<ProBadge> createState() => _ProBadgeState();
}

class _ProBadgeState extends State<ProBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.8 + (_controller.value * 0.2), // Higher base opacity
          child: Text(
             "PRO", 
             style: TextStyle(
               color: const Color(0xFFFBBF24), // Golden
               fontSize: 13, // Slightly bigger again
               fontWeight: FontWeight.bold, 
               letterSpacing: 1.2,
               shadows: [
                 // Multiple shadows for intense neon glow
                 Shadow(color: const Color(0xFFFBBF24).withOpacity(0.8), blurRadius: 4), // Core
                 Shadow(color: const Color(0xFFFBBF24).withOpacity(0.6 * _controller.value), blurRadius: 12), // Glow
                 Shadow(color: Colors.orange.withOpacity(0.4 * _controller.value), blurRadius: 20), // Ambient
               ]
             )
          ),
        );
      },
    );
  }
}
