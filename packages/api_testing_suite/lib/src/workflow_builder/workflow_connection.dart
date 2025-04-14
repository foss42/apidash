import 'package:flutter/material.dart';
import 'models/workflow_connection_model.dart';

class WorkflowConnectionWidget extends StatelessWidget {
  final WorkflowConnectionModel connection;
  final Offset sourcePosition;
  final Offset targetPosition;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const WorkflowConnectionWidget({
    super.key,
    required this.connection,
    required this.sourcePosition,
    required this.targetPosition,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          painter: ConnectionPainter(
            source: sourcePosition,
            target: targetPosition,
            isConditional: connection.isConditional,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  final Offset source;
  final Offset target;
  final bool isConditional;

  ConnectionPainter({
    required this.source,
    required this.target,
    required this.isConditional,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(source, target, paint);

    final arrowSize = 10.0;
    final arrowPath = Path()
      ..moveTo(target.dx, target.dy)
      ..lineTo(
        target.dx - arrowSize * 1.5 * (target.dx > source.dx ? 1 : -1),
        target.dy - arrowSize,
      )
      ..lineTo(
        target.dx - arrowSize * 1.5 * (target.dx > source.dx ? 1 : -1),
        target.dy + arrowSize,
      )
      ..close();

    canvas.drawPath(arrowPath, paint..style = PaintingStyle.fill);

    if (isConditional) {
      final conditionPath = Path()
        ..moveTo(
          (source.dx + target.dx) / 2,
          (source.dy + target.dy) / 2 - 10,
        )
        ..lineTo(
          (source.dx + target.dx) / 2 + 10,
          (source.dy + target.dy) / 2 + 10,
        )
        ..lineTo(
          (source.dx + target.dx) / 2 - 10,
          (source.dy + target.dy) / 2 + 10,
        )
        ..close();

      canvas.drawPath(
        conditionPath,
        Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ConnectionPainter &&
        (oldDelegate.source != source ||
            oldDelegate.target != target ||
            oldDelegate.isConditional != isConditional);
  }
}
