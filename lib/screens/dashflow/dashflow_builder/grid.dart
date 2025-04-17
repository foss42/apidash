import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class GridPainter extends CustomPainter {
  final Matrix4 transformation;
  final Size viewportSize;
  final double baseGridSize;

  GridPainter({
    required this.transformation,
    required this.viewportSize,
    this.baseGridSize = 50,
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

    // Calculate visible top-left and bottom-right corners in world space
    final topLeft = _transformPoint(Offset.zero, inverted);
    final bottomRight = _transformPoint(
      Offset(viewportSize.width, viewportSize.width),
      inverted,
    );

    // Viewport-relative offsets
    final startX = (topLeft.dx ~/ baseGridSize - 1) * baseGridSize.toDouble();
    final endX = (bottomRight.dx ~/ baseGridSize + 1) * baseGridSize.toDouble();

    final startY = (topLeft.dy ~/ baseGridSize - 1) * baseGridSize.toDouble();
    final endY = (bottomRight.dy ~/ baseGridSize + 1) * baseGridSize.toDouble();

    final paint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw vertical dotted lines
    // Vertical grid lines
    for (double x = startX; x <= endX; x += baseGridSize) {
      final path = Path()
        ..moveTo(x, startY)
        ..lineTo(x, endY);

      canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList<double>([1, 5])),
        paint,
      );
    }

// Horizontal grid lines
    for (double y = startY; y <= endY; y += baseGridSize) {
      final path = Path()
        ..moveTo(startX, y)
        ..lineTo(endX, y);

      canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList<double>([1, 5])),
        paint,
      );
    }
}
  @override
  bool shouldRepaint( GridPainter oldDelegate) {
    return !listEquals(
            oldDelegate.transformation.storage, transformation.storage) ||
        oldDelegate.viewportSize != viewportSize;
  }
}