import 'package:flutter/material.dart';

class CanvasControls extends StatelessWidget {
  final TransformationController transformationController;
  final double scale;
  final VoidCallback onReset;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const CanvasControls({
    super.key,
    required this.transformationController,
    required this.scale,
    required this.onReset,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff171433).withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: onReset,
              tooltip: 'Reset View',
            ),
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: onZoomOut,
              tooltip: 'Zoom Out',
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xff171433).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${(scale * 100).toInt()}%',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: onZoomIn,
              tooltip: 'Zoom In',
            ),
          ],
        ),
      ),
    );
  }
}
