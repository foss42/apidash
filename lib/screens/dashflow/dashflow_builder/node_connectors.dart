import 'package:flutter/material.dart';
import 'nodes.dart';

class ArrowPainter extends CustomPainter {
  final List<NodeData> nodes;
  final double gridSize;
  final double canvasSize;
  final int? hoveredNodeId; // Properly declared as optional

  ArrowPainter({
    required this.nodes,
    required this.gridSize,
    required this.canvasSize,
    this.hoveredNodeId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) return;

    // Find Node 1 and Node 2
    final sourceNode = nodes.firstWhere((n) => n.id == 1);
    final targetNode = nodes.firstWhere((n) => n.id == 2);
    final isHighlighted = hoveredNodeId == 1 || hoveredNodeId == 2;

    // Define paint style
    final paint = Paint()
      ..color = isHighlighted ? Colors.blue : Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHighlighted ? 3 : 2;

    // Get rendered sizes using GlobalKey
    final sourceRenderBox =
        sourceNode.sizeKey.currentContext?.findRenderObject() as RenderBox?;
    final targetRenderBox =
        targetNode.sizeKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceRenderBox == null || targetRenderBox == null) return;

    final sourceSize = sourceRenderBox.size;
    final targetSize = targetRenderBox.size;

    // Define flexible connection points (edges of cards)
    final sourceEdgeX =
        sourceNode.offset.dx + canvasSize / 2 + sourceSize.width / 2;
    final sourceEdgeY =
        sourceNode.offset.dy + canvasSize / 2 + sourceSize.height / 2;
    final targetEdgeX =
        targetNode.offset.dx + canvasSize / 2 + targetSize.width / 2;
    final targetEdgeY =
        targetNode.offset.dy + canvasSize / 2 + targetSize.height / 2;

    // Z-shaped path with two L-turns, snapped to grid
    final midX = ((sourceEdgeX + targetEdgeX) / 2);
    final pathPoints = [
      Offset(sourceEdgeX, sourceEdgeY), // Right edge of source node
      Offset(midX, sourceEdgeY), // Horizontal to midpoint
      Offset(midX, targetEdgeY), // Vertical to target height
      Offset(targetEdgeX, targetEdgeY), // Left edge of target node
    ];

    // Draw the path
    final path = Path()
      ..moveTo(pathPoints[0].dx, pathPoints[0].dy)
      ..lineTo(pathPoints[1].dx, pathPoints[1].dy)
      ..lineTo(pathPoints[2].dx, pathPoints[2].dy)
      ..lineTo(pathPoints[3].dx, pathPoints[3].dy);
    canvas.drawPath(path, paint);

    // Debug prints (optional, remove after testing)
    // print('Snapped Source: $snappedSource');
    // print('Middle Point: ${pathPoints[1]}');
    // print('Snapped Target: $snappedTarget');
    // print('Angle: $angle');
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) =>
      nodes != oldDelegate.nodes || hoveredNodeId != oldDelegate.hoveredNodeId;
}
