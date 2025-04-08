import 'dart:math';
import 'package:api_testing_suite/src/models/models.dart';
import 'package:flutter/material.dart';

/// A widget that displays a connection between two workflow nodes
class WorkflowConnection extends StatefulWidget {
  final WorkflowConnectionModel connection;
  final Offset sourcePosition;
  final Offset targetPosition;
  final bool isConditional;
  final double scale;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const WorkflowConnection({
    Key? key,
    required this.connection,
    required this.sourcePosition,
    required this.targetPosition,
    this.isConditional = false,
    this.scale = 1.0,
    required this.onTap,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<WorkflowConnection> createState() => _WorkflowConnectionState();
}

class _WorkflowConnectionState extends State<WorkflowConnection> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final dx = widget.targetPosition.dx - widget.sourcePosition.dx;
    final dy = widget.targetPosition.dy - widget.sourcePosition.dy;
    final distance = sqrt(dx * dx + dy * dy);
    
    final angle = atan2(dy, dx);
    
    final centerX = widget.sourcePosition.dx + dx / 2;
    final centerY = widget.sourcePosition.dy + dy / 2;
    
    return Stack(
      children: [
        Positioned(
          left: widget.sourcePosition.dx,
          top: widget.sourcePosition.dy,
          child: Transform(
            transform: Matrix4.identity()
              ..translate(0.0, 0.0)
              ..rotateZ(angle),
            alignment: Alignment.centerLeft,
            child: Container(
              width: distance,
              height: 2 * widget.scale,
              decoration: BoxDecoration(
                color: widget.isConditional ? Colors.orange : Colors.blue,
                borderRadius: BorderRadius.circular(1 * widget.scale),
              ),
            ),
          ),
        ),
        
        Positioned(
          left: widget.targetPosition.dx - 10 * widget.scale,
          top: widget.targetPosition.dy - 5 * widget.scale,
          child: Transform(
            transform: Matrix4.identity()..rotateZ(angle),
            alignment: Alignment.center,
            child: Container(
              width: 10 * widget.scale,
              height: 10 * widget.scale,
              decoration: BoxDecoration(
                color: widget.isConditional ? Colors.orange : Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        
        if (widget.isConditional)
          Positioned(
            left: centerX - 8 * widget.scale,
            top: centerY - 8 * widget.scale,
            child: Transform(
              transform: Matrix4.identity()..rotateZ(pi/4),
              alignment: Alignment.center,
              child: Container(
                width: 16 * widget.scale,
                height: 16 * widget.scale,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  border: Border.all(
                    color: Colors.white,
                    width: 1 * widget.scale,
                  ),
                ),
              ),
            ),
          ),
        
        Positioned(
          left: widget.sourcePosition.dx,
          top: widget.sourcePosition.dy - 15 * widget.scale,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Transform(
                transform: Matrix4.identity()..rotateZ(angle),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: distance,
                  height: 30 * widget.scale,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        
        if (_isHovering)
          Positioned(
            left: centerX - 32,
            top: centerY - 20,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings, size: 18),
                    tooltip: 'Edit connection',
                    onPressed: widget.onTap,
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    tooltip: 'Remove connection',
                    onPressed: widget.onRemove,
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
