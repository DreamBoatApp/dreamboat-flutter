import 'dart:math';
import 'package:flutter/material.dart';

class ParticleOverlay extends StatefulWidget {
  final int particleCount;
  final Color color;

  const ParticleOverlay({
    super.key,
    this.particleCount = 30,
    this.color = Colors.white,
  });

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _particles = List.generate(widget.particleCount, (index) => _createParticle());
  }

  Particle _createParticle() {
    return Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      speed: 0.1 + _random.nextDouble() * 0.2,
      opacity: 0.1 + _random.nextDouble() * 0.4,
      size: 1.0 + _random.nextDouble() * 2.0,
    );
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
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double speed;
  double opacity;
  double size;

  Particle({required this.x, required this.y, required this.speed, required this.opacity, required this.size});
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Color color;

  ParticlePainter({required this.particles, required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Move particle upwards slowly
      double currentY = (particle.y - (progress * particle.speed)) % 1.0;
      if (currentY < 0) currentY += 1.0;

      // Slight horizontal wobble
      double currentX = (particle.x + sin(progress * 2 * pi + particle.y * 10) * 0.05) % 1.0;

      paint.color = color.withOpacity(particle.opacity);
      canvas.drawCircle(
        Offset(currentX * size.width, currentY * size.height), 
        particle.size, 
        paint
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
