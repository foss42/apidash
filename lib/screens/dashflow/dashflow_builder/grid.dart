import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class GridPainter extends CustomPainter {
  final Matrix4 transformation;
  final Size viewportSize;
  final double baseGridSize;

  GridPainter({
    required this.transformation,
    required this.viewportSize,
    this.baseGridSize = 20,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final zoom = transformation.getMaxScaleOnAxis();
    final gridSize = baseGridSize * zoom;

    final dx = transformation.getTranslation().x;
    final dy = transformation.getTranslation().y;

    // Viewport-relative offsets
    final startX = -dx % gridSize;
    final startY = -dy % gridSize;

    final cols = (viewportSize.width / gridSize).ceil() + 2;
    final rows = (viewportSize.height / gridSize).ceil() + 2;

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Restrict drawing to visible area
    canvas
        .clipRect(Rect.fromLTWH(0, 0, viewportSize.width, viewportSize.height));

   // Draw vertical dotted lines
    for (int i = 0; i < cols; i++) {
      final x = startX + i * gridSize;
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x, viewportSize.height);

      canvas.drawPath(dashPath(path, dashArray: CircularIntervalList<double>([1,5])), paint);
    }

       // Draw horizontal dotted lines
    for (int j = 0; j < rows; j++) {
      final y = startY + j * gridSize;
      final path = Path()
        ..moveTo(0, y)
        ..lineTo(viewportSize.width, y);

      canvas.drawPath(dashPath(path, dashArray: CircularIntervalList<double>([1,5])), paint);
    }

  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) =>
      oldDelegate.transformation != transformation ||
      oldDelegate.viewportSize != viewportSize;
}

