import 'package:flutter/material.dart';

class AnimatedChart extends StatefulWidget {
  final List<double> data;
  final Color color;

  const AnimatedChart({
    super.key,
    required this.data,
    required this.color,
  });

  @override
  State<AnimatedChart> createState() => _AnimatedChartState();
}

class _AnimatedChartState extends State<AnimatedChart> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _ChartPainter(
            data: widget.data,
            color: widget.color,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double animationValue;

  const _ChartPainter({
    required this.data,
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    final xStep = size.width / (data.length - 1);
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final scaleY = size.height / maxValue;

    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      final y = size.height - (data[i] * scaleY * animationValue);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}