import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'models/workflow_connection_model.dart';
import 'models/workflow_node_model.dart';

/// Painter for workflow connections
class ConnectionPainter extends CustomPainter {
  final List<WorkflowConnectionModel> connections;
  final List<WorkflowNodeModel> nodes;
  final Map<String, Offset> nodePositions;
  final Offset? tempConnectionStart;
  final Offset? tempConnectionEnd;
  final List<String> runningNodeIds;
  final List<String> completedNodeIds;
  final Size nodeSize;

  ConnectionPainter({
    required this.connections,
    required this.nodes,
    required this.nodePositions,
    this.tempConnectionStart,
    this.tempConnectionEnd,
    this.runningNodeIds = const [],
    this.completedNodeIds = const [],
    this.nodeSize = const Size(160, 80),
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final connection in connections) {
      try {
        final sourceId = connection.sourceId;
        final targetId = connection.targetId;

        if (nodePositions.containsKey(sourceId) &&
            nodePositions.containsKey(targetId)) {
          final isActive = runningNodeIds.contains(sourceId) ||
              runningNodeIds.contains(targetId);
          final isCompleted = completedNodeIds.contains(sourceId) &&
              completedNodeIds.contains(targetId);

          _drawConnection(
            canvas,
            sourceId,
            targetId,
            isActive: isActive,
            isCompleted: isCompleted,
          );
        }
      } catch (e) {
        debugPrint('Error drawing connection: $e');
      }
    }

    if (tempConnectionStart != null && tempConnectionEnd != null) {
      _drawTempConnection(canvas, tempConnectionStart!, tempConnectionEnd!);
    }
  }

  void _drawConnection(
    Canvas canvas,
    String sourceId,
    String targetId, {
    bool isActive = false,
    bool isCompleted = false,
  }) {
    try {
      final start = nodePositions[sourceId]!;
      final end = nodePositions[targetId]!;

      final Color color = isActive
          ? Colors.blue
          : isCompleted
              ? Colors.green
              : Colors.grey;

      final double width = isActive || isCompleted ? 2.0 : 1.0;

      _drawBezierLine(canvas, start, end, color, width);
    } catch (e) {
      debugPrint('Error drawing connection: $e');
    }
  }

  void _drawTempConnection(Canvas canvas, Offset start, Offset end) {
    _drawBezierLine(canvas, start, end, Colors.blue.withOpacity(0.7), 2.0,
        isDashed: true);
  }

  void _drawBezierLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    double width, {
    bool isDashed = false,
  }) {
    try {
      final sourceCenter =
          Offset(start.dx + nodeSize.width / 2, start.dy + nodeSize.height / 2);

      final targetCenter =
          Offset(end.dx + nodeSize.width / 2, end.dy + nodeSize.height / 2);

      final controlPoint1 = Offset(
        sourceCenter.dx + (targetCenter.dx - sourceCenter.dx) * 0.5,
        sourceCenter.dy,
      );

      final controlPoint2 = Offset(
        sourceCenter.dx + (targetCenter.dx - sourceCenter.dx) * 0.5,
        targetCenter.dy,
      );

      final path = Path()
        ..moveTo(sourceCenter.dx, sourceCenter.dy)
        ..cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          targetCenter.dx,
          targetCenter.dy,
        );

      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width + 2.0;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;

      if (isDashed) {
        final dashPath = _dashPath(
          path,
          dashArray: CircularIntervalList<double>([5, 5]),
        );
        canvas.drawPath(dashPath, paint);
      } else {
        canvas.drawPath(path, shadowPaint);
        canvas.drawPath(path, paint);

        _drawArrow(canvas, targetCenter.dx, targetCenter.dy, color, width);
      }
    } catch (e) {
      debugPrint('Error drawing bezier line: $e');
    }
  }

  void _drawArrow(
      Canvas canvas, double x, double y, Color color, double width) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(x, y);
    path.lineTo(x - 6, y - 3);
    path.lineTo(x - 6, y + 3);
    path.close();

    canvas.drawPath(path, paint);
  }

  Path _dashPath(
    Path source, {
    required CircularIntervalList<double> dashArray,
  }) {
    final Path dest = Path();
    final List<ui.PathMetric> metrics = source.computeMetrics().toList();

    for (final ui.PathMetric pathMetric in metrics) {
      double distance = 0;
      bool draw = true;
      while (distance < pathMetric.length) {
        final double len = dashArray.next;
        if (draw) {
          try {
            dest.addPath(
              pathMetric.extractPath(distance, distance + len),
              Offset.zero,
            );
          } catch (e) {
            debugPrint('Error adding path segment: $e');
          }
        }
        distance += len;
        draw = !draw;
      }
    }

    return dest;
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) {
    return oldDelegate.connections != connections ||
        oldDelegate.nodePositions != nodePositions ||
        oldDelegate.tempConnectionStart != tempConnectionStart ||
        oldDelegate.tempConnectionEnd != tempConnectionEnd ||
        oldDelegate.runningNodeIds != runningNodeIds ||
        oldDelegate.completedNodeIds != completedNodeIds;
  }
}

class CircularIntervalList<T> {
  final List<T> _items;
  int _index = 0;

  CircularIntervalList(this._items);

  T get next {
    if (_items.isEmpty) {
      throw Exception('CircularIntervalList is empty');
    }
    final item = _items[_index];
    _index = (_index + 1) % _items.length;
    return item;
  }
}
