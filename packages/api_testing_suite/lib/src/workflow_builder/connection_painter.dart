import 'package:api_testing_suite/api_testing_suite.dart';
import 'package:flutter/material.dart';

/// Painter for workflow connections
class ConnectionPainter extends CustomPainter {
  final List<WorkflowConnectionModel> connections;
  final List<WorkflowNodeModel> nodes;
  final Map<String, Offset> nodePositions;
  final List<String> runningNodeIds;
  final List<String> completedNodeIds;
  final Offset? tempConnectionStart;
  final Offset? tempConnectionEnd;
  final double strokeWidth;
  
  final Offset? start;
  final Offset? end;
  final Color? color;
  final bool animated;
  final String? label;

  ConnectionPainter({
    this.connections = const [],
    this.nodes = const [],
    this.nodePositions = const {},
    this.runningNodeIds = const [],
    this.completedNodeIds = const [],
    this.tempConnectionStart,
    this.tempConnectionEnd,
    this.strokeWidth = 2.0,
    this.start,
    this.end,
    this.color,
    this.animated = false,
    this.label,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (start != null && end != null) {
      _paintSingleConnection(canvas, start!, end!, color ?? Colors.blue, animated, label);
      return;
    }
    
    for (final connection in connections) {
      final sourcePos = _getNodeCenterPosition(connection.sourceId);
      final targetPos = _getNodeCenterPosition(connection.targetId);
      
      if (sourcePos != null && targetPos != null) {
        final isActive = _isConnectionActive(connection.sourceId, connection.targetId);
        final isCompleted = _isConnectionCompleted(connection.sourceId, connection.targetId);
        
        Color connectionColor;
        if (isActive) {
          connectionColor = Colors.blue.shade500;
        } else if (isCompleted) {
          connectionColor = Colors.green.shade500;
        } else if (connection.condition != null) {
          connectionColor = Colors.amber.shade500;
        } else {
          connectionColor = Colors.blue.shade300;
        }
        
        _paintSingleConnection(
          canvas, 
          sourcePos, 
          targetPos, 
          connectionColor,
          isActive, 
          connection.condition
        );
      }
    }
    
    if (tempConnectionStart != null && tempConnectionEnd != null) {
      _paintSingleConnection(
        canvas,
        tempConnectionStart!,
        tempConnectionEnd!,
        Colors.blue.withOpacity(0.7),
        true,
        null
      );
    }
  }
  
  Offset? _getNodeCenterPosition(String nodeId) {
    final position = nodePositions[nodeId];
    if (position != null) {
      return position + const Offset(80, 40); 
    }
    return null;
  }
  
  bool _isConnectionActive(String sourceId, String targetId) {
    return runningNodeIds.contains(sourceId) || runningNodeIds.contains(targetId);
  }
  
  bool _isConnectionCompleted(String sourceId, String targetId) {
    return completedNodeIds.contains(sourceId) && completedNodeIds.contains(targetId);
  }

  void _paintSingleConnection(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    bool animated,
    String? label,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (animated) {
      paint.shader = LinearGradient(
        colors: [
          color.withOpacity(0.3),
          color,
          color.withOpacity(0.3),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromPoints(start, end));
    }

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);

    canvas.drawPath(path, paint);

    if (label != null && label.isNotEmpty) {
      final midpoint = Offset(
        (start.dx + end.dx) / 2,
        (start.dy + end.dy) / 2,
      );
      _drawLabel(canvas, midpoint, label);
    }
  }

  // Offset _calculateTangent(Offset controlPoint, Offset endPoint) {
  //   return (endPoint - controlPoint).normalize();
  // }

  // void _drawArrow(Canvas canvas, Offset position, Offset direction, Paint paint) {
  //   final arrowSize = 8.0;
  //   final angle = atan2(direction.dy, direction.dx);

  //   final path = Path()
  //     ..moveTo(position.dx, position.dy)
  //     ..lineTo(
  //       position.dx - arrowSize * cos(angle - pi / 6),
  //       position.dy - arrowSize * sin(angle - pi / 6),
  //     )
  //     ..lineTo(
  //       position.dx - arrowSize * cos(angle + pi / 6),
  //       position.dy - arrowSize * sin(angle + pi / 6),
  //     )
  //     ..close();

  //   canvas.drawPath(path, paint..style = PaintingStyle.fill);
  // }

  void _drawLabel(Canvas canvas, Offset position, String label) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.drawRect(
      Rect.fromCenter(
        center: position,
        width: textPainter.width + 16,
        height: textPainter.height + 8,
      ),
      Paint()..color = Colors.black.withOpacity(0.7),
    );

    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(ConnectionPainter oldDelegate) {
    return oldDelegate.connections != connections ||
        oldDelegate.runningNodeIds != runningNodeIds ||
        oldDelegate.completedNodeIds != completedNodeIds ||
        oldDelegate.tempConnectionStart != tempConnectionStart ||
        oldDelegate.tempConnectionEnd != tempConnectionEnd ||
        oldDelegate.start != start ||
        oldDelegate.end != end;
  }
}

extension OffsetExtension on Offset {
  Offset normalize() {
    final magnitude = distance;
    if (magnitude == 0) return Offset.zero;
    return Offset(dx / magnitude, dy / magnitude);
  }
}
