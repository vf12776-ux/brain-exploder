import 'package:flutter/material.dart';
import 'dart:math';

class ParticleBackground extends StatefulWidget {
  final Widget child;
  
  const ParticleBackground({super.key, required this.child});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    particles = List.generate(50, (index) => Particle());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _updateParticles();
        return CustomPaint(
          painter: ParticlePainter(particles),
          child: widget.child,
        );
      },
    );
  }

  void _updateParticles() {
    for (final particle in particles) {
      particle.update();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Particle {
  double x = Random().nextDouble() * 400;
  double y = Random().nextDouble() * 800;
  double velocityX = (Random().nextDouble() - 0.5) * 2;
  double velocityY = (Random().nextDouble() - 0.5) * 2;
  double size = Random().nextDouble() * 3 + 1;
  Color color = Colors.blue.withOpacity(Random().nextDouble() * 0.3 + 0.1);

  void update() {
    x += velocityX;
    y += velocityY;
    
    if (x <= 0 || x >= 400) velocityX *= -1;
    if (y <= 0 || y >= 800) velocityY *= -1;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
