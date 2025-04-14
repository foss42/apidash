import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final Color gridColor;
  final double gridWidth;
  final double gridSpacing;

  GridPainter({
    required this.gridColor,
    required this.gridWidth,
    required this.gridSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = gridWidth;

    final horizontalLines = (size.height / gridSpacing).ceil();
    final verticalLines = (size.width / gridSpacing).ceil();

    for (var i = 0; i <= horizontalLines; i++) {
      final y = i * gridSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (var i = 0; i <= verticalLines; i++) {
      final x = i * gridSpacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is GridPainter &&
        (oldDelegate.gridColor != gridColor ||
            oldDelegate.gridWidth != gridWidth ||
            oldDelegate.gridSpacing != gridSpacing);
  }
}
