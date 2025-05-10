import 'package:flutter/material.dart';

/// A reusable draggable component that can be used for drag and drop operations
class DraggableComponent extends StatelessWidget {
  final Widget child;
  final Widget? feedback;
  final Widget? childWhenDragging;
  final Object data;
  final DragAnchorStrategy? dragAnchorStrategy;
  final Axis? axis;
  final bool useDefaultFeedback;
  final VoidCallback? onDragStarted;
  final DragEndCallback? onDragEnd;
  final VoidCallback? onDraggableCanceled;

  const DraggableComponent({
    super.key,
    required this.child,
    required this.data,
    this.feedback,
    this.childWhenDragging,
    this.dragAnchorStrategy,
    this.axis,
    this.useDefaultFeedback = false,
    this.onDragStarted,
    this.onDragEnd,
    this.onDraggableCanceled,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<Object>(
      data: data,
      dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
      axis: axis,
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
      onDraggableCanceled: (_, __) => onDraggableCanceled?.call(),
      feedback: feedback ?? _buildDefaultFeedback(context),
      childWhenDragging:
          childWhenDragging ?? Opacity(opacity: 0.5, child: child),
      child: child,
    );
  }

  Widget _buildDefaultFeedback(BuildContext context) {
    if (!useDefaultFeedback && feedback != null) return feedback!;

    return Material(
      color: Colors.transparent,
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: child,
      ),
    );
  }
}
