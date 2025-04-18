import 'package:flutter/material.dart';
import '../../models/workflow_model.dart';

class ConnectionPainter extends CustomPainter {
  final WorkflowModel workflow;
  final Map<String, Offset> nodePositions;
  final List<String> runningNodeIds;
  final List<String> completedNodeIds;

  ConnectionPainter({
    required this.workflow,
    required this.nodePositions,
    required this.runningNodeIds,
    required this.completedNodeIds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final connection in workflow.connections) {
      final sourcePosition = nodePositions[connection.sourceId];
      final targetPosition = nodePositions[connection.targetId];

      if (sourcePosition != null && targetPosition != null) {
        // Adjust start and end points to be at the edges of nodes (assuming nodes are 150x60)
        final start = Offset(sourcePosition.dx + 75, sourcePosition.dy + 30);
        final end = Offset(targetPosition.dx + 75, targetPosition.dy + 30);

        // Draw arrow line
        final path = Path();
        path.moveTo(start.dx, start.dy);
        
        // Create curved path
        path.cubicTo(
          start.dx + (end.dx - start.dx) * 0.5, start.dy,
          start.dx + (end.dx - start.dx) * 0.5, end.dy,
          end.dx, end.dy
        );

        // Draw connection
        canvas.drawPath(path, paint);

        // Draw arrow tip
        _drawArrowTip(canvas, end, start, paint);
      }
    }
  }

  void _drawArrowTip(Canvas canvas, Offset end, Offset start, Paint paint) {
    // Calculate direction vector
    final direction = (end - start).normalized();
    // Calculate perpendicular vector
    final perpendicular = Offset(-direction.dy, direction.dx);

    // Define arrow head
    final arrowSize = 10.0;
    final arrowTip = end;
    final arrowBase1 = end - direction * arrowSize + perpendicular * arrowSize * 0.5;
    final arrowBase2 = end - direction * arrowSize - perpendicular * arrowSize * 0.5;

    // Draw arrow head
    final path = Path()
      ..moveTo(arrowTip.dx, arrowTip.dy)
      ..lineTo(arrowBase1.dx, arrowBase1.dy)
      ..lineTo(arrowBase2.dx, arrowBase2.dy)
      ..close();

    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(ConnectionPainter oldDelegate) {
    return oldDelegate.workflow != workflow ||
           oldDelegate.nodePositions != nodePositions ||
           oldDelegate.runningNodeIds != runningNodeIds ||
           oldDelegate.completedNodeIds != completedNodeIds;
  }
}

class TemporaryConnectionPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  TemporaryConnectionPainter({
    required this.start,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw dashed line
    final path = Path();
    path.moveTo(start.dx, start.dy);
    
    // Create curved path
    path.cubicTo(
      start.dx + (end.dx - start.dx) * 0.5, start.dy,
      start.dx + (end.dx - start.dx) * 0.5, end.dy,
      end.dx, end.dy
    );

    // Draw connection
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TemporaryConnectionPainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}

// Extension to add normalized method to Offset
extension OffsetExt on Offset {
  Offset normalized() {
    final magnitude = distance;
    if (magnitude == 0) return Offset.zero;
    return Offset(dx / magnitude, dy / magnitude);
  }
}

class CanvasConnectionLayer extends StatelessWidget {
  final WorkflowModel workflow;
  final Map<String, Offset> nodePositions;
  final String? sourceNodeId;
  final Offset? connectionStart;
  final Offset? connectionEnd;
  final List<String> runningNodeIds;
  final List<String> completedNodeIds;

  const CanvasConnectionLayer({
    super.key,
    required this.workflow,
    required this.nodePositions,
    this.sourceNodeId,
    this.connectionStart,
    this.connectionEnd,
    required this.runningNodeIds,
    required this.completedNodeIds,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Permanent connections between nodes
          CustomPaint(
            size: Size.infinite,
            painter: ConnectionPainter(
              workflow: workflow,
              nodePositions: nodePositions,
              runningNodeIds: runningNodeIds,
              completedNodeIds: completedNodeIds,
            ),
          ),
          // Temporary connection being drawn
          if (sourceNodeId != null && connectionStart != null && connectionEnd != null)
            CustomPaint(
              size: Size.infinite,
              painter: TemporaryConnectionPainter(
                start: connectionStart!,
                end: connectionEnd!,
              ),
            ),
        ],
      ),
    );
  }
}
