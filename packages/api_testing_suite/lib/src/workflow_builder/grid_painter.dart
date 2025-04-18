import 'package:flutter/material.dart';

/// A custom painter for drawing a grid background
class GridBackgroundPainter extends CustomPainter {
  final Color gridColor;
  final double step;

  GridBackgroundPainter({
    required this.gridColor,
    required this.step,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
