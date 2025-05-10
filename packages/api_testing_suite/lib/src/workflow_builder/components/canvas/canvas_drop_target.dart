import 'package:flutter/material.dart';

class CanvasDropTarget extends StatelessWidget {
  final Widget child;
  final Function(dynamic, Offset) onAccept;
  final TransformationController transformationController;

  const CanvasDropTarget({
    super.key,
    required this.child,
    required this.onAccept,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<Object>(
      builder: (context, candidateData, rejectedData) {
        return child;
      },
      onWillAccept: (_) => true,
      onAcceptWithDetails: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.offset);
        final position = transformationController.toScene(localPosition);
        onAccept(details.data, position);
      },
    );
  }
}
