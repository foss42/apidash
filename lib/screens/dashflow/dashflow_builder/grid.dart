import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class GridPainter extends CustomPainter {
  final Matrix4 transformation;
  final Size viewportSize;
  final double baseGridSize;
  final double canvasSize;

  GridPainter({
    required this.transformation,
    required this.viewportSize,
    this.baseGridSize = 50,
    required this.canvasSize,
  });
  Offset _transformPoint(Offset point, Matrix4 matrix) {
    final vector = matrix.transform3(vm.Vector3(point.dx, point.dy, 0));
    return Offset(vector.x, vector.y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final zoom = transformation.getMaxScaleOnAxis();
    final gridSize = baseGridSize * zoom;
    final inverted = Matrix4.copy(transformation)..invert();

    final dx = transformation.getTranslation().x;
    final dy = transformation.getTranslation().y;

    // Increase grid spacing at low zoom to reduce lines
    final effectiveGridSize = zoom < 1 ? gridSize * 2 : gridSize;

    // Center the origin
    final centerOffset = Offset(canvasSize / 2, canvasSize / 2);
    final topLeft = _transformPoint(Offset.zero, inverted) - centerOffset;
    final bottomRight =
        _transformPoint(Offset(size.width, size.height), inverted) -
            centerOffset;

    // Viewport-relative offsets
    final startX = (topLeft.dx ~/ effectiveGridSize - 1) * effectiveGridSize.toDouble();
    final endX = (bottomRight.dx ~/ effectiveGridSize + 1) * effectiveGridSize.toDouble();

    final startY = (topLeft.dy ~/ effectiveGridSize - 1) * effectiveGridSize.toDouble();
    final endY = (bottomRight.dy ~/ effectiveGridSize + 1) * effectiveGridSize.toDouble();

    final paint = Paint()
      ..color = Colors.blueGrey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw vertical dotted lines
    for (double x = startX; x <= endX; x += baseGridSize) {
      final path = Path()
        ..moveTo(x + centerOffset.dx, startY + centerOffset.dy)
        ..lineTo(x + centerOffset.dx, endY + centerOffset.dy);

      canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList<double>([1, 5])),
        paint,
      );
    }

// Horizontal grid lines
    for (double y = startY; y <= endY; y += baseGridSize) {
      final path = Path()
        ..moveTo(startX + centerOffset.dx, y + centerOffset.dy)
        ..lineTo(endX + centerOffset.dx, y + centerOffset.dy);
      canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList<double>([1, 5])),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return transformation != oldDelegate.transformation ||
        viewportSize != oldDelegate.viewportSize ||
        canvasSize != oldDelegate.canvasSize;
  }
}
