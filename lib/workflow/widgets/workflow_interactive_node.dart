import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkflowInteractiveNode extends StatefulWidget {
  const WorkflowInteractiveNode({
    super.key,
    required this.selected,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
    this.actions,
    this.onTap,
    this.onDoubleTap,
    this.onPanUpdate,
    this.onPanEnd,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(14),
    this.runEmphasized = false,
  });

  final bool selected;
  final Color backgroundColor;
  final Color borderColor;
  final Widget child;

  /// Rendered above the drag/tap layer so IconButtons receive presses.
  final Widget? actions;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  /// Soft pulsing glow while this node is the active run step.
  final bool runEmphasized;

  @override
  State<WorkflowInteractiveNode> createState() =>
      _WorkflowInteractiveNodeState();
}

class _WorkflowInteractiveNodeState extends State<WorkflowInteractiveNode>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;
  bool _dragging = false;
  AnimationController? _pulseController;

  AnimationController get _pulse {
    return _pulseController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void initState() {
    super.initState();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant WorkflowInteractiveNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.runEmphasized != widget.runEmphasized) {
      _syncPulse();
    }
  }

  void _syncPulse() {
    if (widget.runEmphasized) {
      if (!_pulse.isAnimating) {
        _pulse.repeat(reverse: true);
      }
    } else {
      _pulseController
        ?..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = widget.selected;
    final showLift = selected || _hovered || _pressed || widget.runEmphasized;
    final scale = _pressed && !_dragging ? 0.985 : 1.0;
    final borderWidth = widget.runEmphasized
        ? 2.0
        : selected
            ? 2.0
            : (_hovered ? 1.5 : 1.0);
    final elevation = selected
        ? 6.0
        : _pressed
            ? 1.0
            : _hovered
                ? 4.0
                : widget.runEmphasized
                    ? 3.0
                    : 0.0;

    final node = Material(
      color: widget.backgroundColor,
      elevation: 0,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onTap?.call();
              },
              onDoubleTap: widget.onDoubleTap,
              onPanStart: (_) => setState(() {
                _dragging = true;
                _pressed = false;
              }),
              onPanUpdate: widget.onPanUpdate,
              onPanEnd: (details) {
                setState(() => _dragging = false);
                widget.onPanEnd?.call(details);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOutCubic,
                padding: widget.padding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: _hovered && !selected && !widget.runEmphasized
                        ? Color.alphaBlend(
                            widget.borderColor.withValues(alpha: 0.45),
                            theme.dividerColor,
                          )
                        : widget.borderColor,
                    width: borderWidth,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
          if (widget.actions != null)
            Positioned(
              top: 6,
              right: 6,
              child: widget.actions!,
            ),
        ],
      ),
    );

    Widget decorated = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: showLift && !widget.runEmphasized
            ? [
                BoxShadow(
                  color: theme.shadowColor.withValues(
                    alpha: selected ? 0.22 : 0.14,
                  ),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation * 0.35),
                ),
                if (selected)
                  BoxShadow(
                    color: widget.borderColor.withValues(alpha: 0.28),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
              ]
            : (!widget.runEmphasized
                ? null
                : [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.14),
                      blurRadius: elevation * 2,
                      offset: Offset(0, elevation * 0.35),
                    ),
                  ]),
      ),
      child: node,
    );

    if (widget.runEmphasized) {
      decorated = AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final pulse = _pulse.value;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.14),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation * 0.35),
                ),
                BoxShadow(
                  color: widget.borderColor.withValues(
                    alpha: 0.16 + pulse * 0.14,
                  ),
                  blurRadius: 8 + pulse * 6,
                  spreadRadius: 0.4 + pulse * 1.0,
                ),
              ],
            ),
            child: child,
          );
        },
        child: node,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOutCubic,
        child: decorated,
      ),
    );
  }
}
