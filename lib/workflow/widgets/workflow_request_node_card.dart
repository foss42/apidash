import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/widgets/workflow_interactive_node.dart';
import 'package:apidash/workflow/widgets/workflow_port.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkflowRequestNodeCard extends StatelessWidget {
  const WorkflowRequestNodeCard({
    super.key,
    required this.node,
    required this.selected,
    required this.runResult,
    this.highlightInput = false,
    this.highlightSuccess = false,
    this.highlightFailure = false,
    this.onTap,
    this.onDoubleTap,
    this.onDuplicate,
    this.onDelete,
    this.onDragPanUpdate,
    this.onDragPanEnd,
    this.onWirePointerDown,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final WorkflowNodeRunResult? runResult;
  final bool highlightInput;
  final bool highlightSuccess;
  final bool highlightFailure;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final GestureDragUpdateCallback? onDragPanUpdate;
  final GestureDragEndCallback? onDragPanEnd;
  final void Function(PointerDownEvent event, WorkflowEdgeHandle handle)?
      onWirePointerDown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final request = node.request ?? const <String, dynamic>{};
    final apiType = _readApiType(request);
    final isAi = apiType == APIType.ai;
    final http = request['httpRequestModel'];
    final method = http is Map
        ? (http['method'] as String? ?? HTTPVerb.get.name).toUpperCase()
        : 'GET';
    final url = http is Map ? (http['url'] as String? ?? '') : '';
    final aiModel = _readAiField(request, 'model');
    final aiPrompt = _readAiField(request, 'user_prompt');
    final badgeLabel = isAi
        ? (aiModel?.trim().isNotEmpty == true ? aiModel!.trim() : 'AI')
        : method;
    final detailText = isAi
        ? (aiPrompt?.trim().isNotEmpty == true
            ? aiPrompt!.trim()
            : 'No prompt configured')
        : (url.isEmpty ? 'No URL configured' : url);
    final defaultLabel =
        isAi ? kLabelAiRequest : kLabelWorkflowStep;
    final borderColor = switch (runResult?.status) {
      WorkflowNodeRunStatus.running => theme.colorScheme.primary,
      WorkflowNodeRunStatus.success => Colors.green,
      WorkflowNodeRunStatus.failed => theme.colorScheme.error,
      _ => selected ? theme.colorScheme.primary : theme.dividerColor,
    };

    return SizedBox(
      width: kWorkflowRequestNodeWidth,
      height: kWorkflowRequestNodeHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: WorkflowInteractiveNode(
              selected: selected,
              backgroundColor: theme.colorScheme.surfaceContainerLow,
              borderColor: borderColor,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              onTap: onTap,
              onDoubleTap: onDoubleTap,
              onPanUpdate: onDragPanUpdate,
              onPanEnd: onDragPanEnd,
              actions: selected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NodeActionButton(
                          icon: Icons.copy_outlined,
                          tooltip: kTooltipDuplicate,
                          onPressed: onDuplicate,
                        ),
                        _NodeActionButton(
                          icon: Icons.delete_outline,
                          tooltip: kTooltipDelete,
                          onPressed: onDelete,
                        ),
                      ],
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isAi ? Icons.auto_awesome_rounded : Icons.http,
                        size: 20,
                        color: theme.colorScheme.onSurface,
                      ),
                      kHSpacer8,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isAi
                              ? theme.colorScheme.tertiaryContainer
                              : theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (selected) const SizedBox(width: 56),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    node.label.isNotEmpty ? node.label : defaultLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(
                          alpha: 0.55,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Text(
                        detailText,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -6,
            top: kRequestPortSendY - 10,
            child: WorkflowPort(
              label: 'Send',
              side: WorkflowPortSide.left,
              color: theme.colorScheme.primary,
              highlighted: highlightInput,
            ),
          ),
          Positioned(
            right: -6,
            top: kRequestPortSuccessY - 10,
            child: WorkflowPort(
              label: 'Success()',
              side: WorkflowPortSide.right,
              color: Colors.green,
              highlighted: highlightSuccess,
              onPointerDown: (event) => onWirePointerDown?.call(
                event,
                WorkflowEdgeHandle.success,
              ),
            ),
          ),
          Positioned(
            right: -6,
            top: kRequestPortFailY - 10,
            child: WorkflowPort(
              label: 'Fail()',
              side: WorkflowPortSide.right,
              color: theme.colorScheme.error,
              highlighted: highlightFailure,
              onPointerDown: (event) => onWirePointerDown?.call(
                event,
                WorkflowEdgeHandle.failure,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

APIType _readApiType(Map<String, dynamic> request) {
  final raw = request['apiType']?.toString();
  if (raw == null || raw.isEmpty) {
    return APIType.rest;
  }
  return APIType.values.firstWhere(
    (type) => type.name == raw,
    orElse: () => APIType.rest,
  );
}

String? _readAiField(Map<String, dynamic> request, String key) {
  final ai = request['aiRequestModel'];
  if (ai is! Map) {
    return null;
  }
  final value = ai[key];
  return value?.toString();
}

class _NodeActionButton extends StatelessWidget {
  const _NodeActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onPressed!();
            },
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      splashRadius: 16,
      style: IconButton.styleFrom(
        animationDuration: const Duration(milliseconds: 100),
      ),
      constraints: const BoxConstraints.tightFor(width: 28, height: 28),
      icon: Icon(icon, size: 16),
    );
  }
}

class WorkflowStartNodeCard extends StatelessWidget {
  const WorkflowStartNodeCard({
    super.key,
    required this.node,
    required this.selected,
    this.highlightNext = false,
    this.onTap,
    this.onPlay,
    this.onDragPanUpdate,
    this.onDragPanEnd,
    this.onWirePointerDown,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final bool highlightNext;
  final VoidCallback? onTap;
  final VoidCallback? onPlay;
  final GestureDragUpdateCallback? onDragPanUpdate;
  final GestureDragEndCallback? onDragPanEnd;
  final void Function(PointerDownEvent event, WorkflowEdgeHandle handle)?
      onWirePointerDown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = getResponseStatusCodeColor(
      200,
      brightness: theme.brightness,
    );
    return SizedBox(
      width: kWorkflowStartNodeWidth,
      height: kWorkflowStartNodeHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: WorkflowInteractiveNode(
              selected: selected,
              backgroundColor: Color.alphaBlend(
                green.withValues(
                  alpha: theme.brightness == Brightness.dark ? 0.28 : 0.16,
                ),
                theme.colorScheme.surfaceContainerLow,
              ),
              borderColor: selected ? green : theme.dividerColor,
              onTap: onTap,
              onPanUpdate: onDragPanUpdate,
              onPanEnd: onDragPanEnd,
              child: Row(
                children: [
                  const SizedBox(width: 36),
                  kHSpacer4,
                  Expanded(
                    child: Text(
                      node.label.isEmpty ? 'Start' : node.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                tooltip: kLabelRunWorkflow,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                visualDensity: VisualDensity.compact,
                onPressed: onPlay,
                icon: Icon(
                  Icons.play_circle_filled_rounded,
                  size: 26,
                  color: green,
                ),
              ),
            ),
          ),
          Positioned(
            right: -6,
            top: kStartPortNextY - 10,
            child: WorkflowPort(
              label: 'Next',
              side: WorkflowPortSide.right,
              color: green,
              highlighted: highlightNext,
              onPointerDown: (event) => onWirePointerDown?.call(
                event,
                WorkflowEdgeHandle.next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkflowConditionNodeCard extends StatelessWidget {
  const WorkflowConditionNodeCard({
    super.key,
    required this.node,
    required this.selected,
    this.highlightInput = false,
    this.highlightThen = false,
    this.highlightElse = false,
    this.onTap,
    this.onDoubleTap,
    this.onDuplicate,
    this.onDelete,
    this.onDragPanUpdate,
    this.onDragPanEnd,
    this.onWirePointerDown,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final bool highlightInput;
  final bool highlightThen;
  final bool highlightElse;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final GestureDragUpdateCallback? onDragPanUpdate;
  final GestureDragEndCallback? onDragPanEnd;
  final void Function(PointerDownEvent event, WorkflowEdgeHandle handle)?
      onWirePointerDown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: kWorkflowConditionNodeWidth,
      height: kWorkflowConditionNodeHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: WorkflowInteractiveNode(
              selected: selected,
              backgroundColor: Color.alphaBlend(
                const Color(0xFFFFB300).withValues(
                  alpha: theme.brightness == Brightness.dark ? 0.22 : 0.14,
                ),
                theme.colorScheme.surfaceContainerLow,
              ),
              borderColor: selected
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              onTap: onTap,
              onDoubleTap: onDoubleTap,
              onPanUpdate: onDragPanUpdate,
              onPanEnd: onDragPanEnd,
              actions: selected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NodeActionButton(
                          icon: Icons.copy_outlined,
                          tooltip: kTooltipDuplicate,
                          onPressed: onDuplicate,
                        ),
                        _NodeActionButton(
                          icon: Icons.delete_outline,
                          tooltip: kTooltipDelete,
                          onPressed: onDelete,
                        ),
                      ],
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.call_split_rounded,
                        size: 20,
                        color: theme.brightness == Brightness.dark
                            ? const Color(0xFFFFD54F)
                            : const Color(0xFFB26A00),
                      ),
                      kHSpacer8,
                      Expanded(
                        child: Text(
                          node.label.isEmpty ? 'Condition' : node.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      if (selected) const SizedBox(width: 56),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      node.conditionExpression ?? 'true',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -6,
            top: kConditionPortInY - 10,
            child: WorkflowPort(
              label: 'In',
              side: WorkflowPortSide.left,
              color: theme.colorScheme.primary,
              highlighted: highlightInput,
            ),
          ),
          Positioned(
            right: -6,
            top: kConditionPortThenY - 10,
            child: WorkflowPort(
              label: 'True',
              side: WorkflowPortSide.right,
              color: Colors.green,
              highlighted: highlightThen,
              onPointerDown: (event) => onWirePointerDown?.call(
                event,
                WorkflowEdgeHandle.then,
              ),
            ),
          ),
          Positioned(
            right: -6,
            top: kConditionPortElseY - 10,
            child: WorkflowPort(
              label: 'False',
              side: WorkflowPortSide.right,
              color: theme.colorScheme.error,
              highlighted: highlightElse,
              onPointerDown: (event) => onWirePointerDown?.call(
                event,
                WorkflowEdgeHandle.elseBranch,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkflowLoopNodeCard extends StatelessWidget {
  const WorkflowLoopNodeCard({
    super.key,
    required this.node,
    required this.selected,
    this.highlightInput = false,
    this.highlightBody = false,
    this.highlightDone = false,
    this.onTap,
    this.onDoubleTap,
    this.onDuplicate,
    this.onDelete,
    this.onDragPanUpdate,
    this.onDragPanEnd,
    this.onWirePointerDown,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final bool highlightInput;
  final bool highlightBody;
  final bool highlightDone;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final GestureDragUpdateCallback? onDragPanUpdate;
  final GestureDragEndCallback? onDragPanEnd;
  final void Function(PointerDownEvent event, WorkflowEdgeHandle handle)?
      onWirePointerDown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loopExpr = node.loopExpression ?? 'var:items';
    final maxIterations = node.loopMaxIterations;
    final loopDetail = node.loopMode == WorkflowLoopMode.repeat
        ? maxIterations != null && maxIterations > 0
            ? 'Repeat $maxIterations×'
            : 'Repeat'
        : maxIterations != null && maxIterations > 0
            ? '$loopExpr · max $maxIterations'
            : loopExpr;
    return SizedBox(
      width: kWorkflowLoopNodeWidth,
      height: kWorkflowLoopNodeHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: WorkflowInteractiveNode(
              selected: selected,
              backgroundColor: theme.colorScheme.secondaryContainer,
              borderColor: selected
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              onTap: onTap,
              onDoubleTap: onDoubleTap,
              onPanUpdate: onDragPanUpdate,
              onPanEnd: onDragPanEnd,
              actions: selected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NodeActionButton(
                          icon: Icons.copy_outlined,
                          tooltip: kTooltipDuplicate,
                          onPressed: onDuplicate,
                        ),
                        _NodeActionButton(
                          icon: Icons.delete_outline,
                          tooltip: kTooltipDelete,
                          onPressed: onDelete,
                        ),
                      ],
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.loop_rounded, size: 20),
                      kHSpacer8,
                      Expanded(
                        child: Text(
                          node.label.isNotEmpty
                              ? node.label
                              : kLabelWorkflowLoop,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      if (selected) const SizedBox(width: 56),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      loopDetail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -6,
            top: kLoopPortInY - 10,
            child: WorkflowPort(
              label: 'In',
              side: WorkflowPortSide.left,
              color: theme.colorScheme.primary,
              highlighted: highlightInput,
            ),
          ),
          Positioned(
            right: -6,
            top: kLoopPortEachY - 10,
            child: WorkflowPort(
              label: 'Each',
              side: WorkflowPortSide.right,
              color: theme.colorScheme.primary,
              highlighted: highlightBody,
              onPointerDown: (event) => onWirePointerDown?.call(
                event,
                WorkflowEdgeHandle.next,
              ),
            ),
          ),
          Positioned(
            right: -6,
            top: kLoopPortDoneY - 10,
            child: WorkflowPort(
              label: 'Done',
              side: WorkflowPortSide.right,
              color: Colors.green,
              highlighted: highlightDone,
              onPointerDown: (event) => onWirePointerDown?.call(
                event,
                WorkflowEdgeHandle.loopDone,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkflowDelayNodeCard extends StatelessWidget {
  const WorkflowDelayNodeCard({
    super.key,
    required this.node,
    required this.selected,
    this.highlightInput = false,
    this.highlightNext = false,
    this.onTap,
    this.onDoubleTap,
    this.onDuplicate,
    this.onDelete,
    this.onDragPanUpdate,
    this.onDragPanEnd,
    this.onWirePointerDown,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final bool highlightInput;
  final bool highlightNext;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final GestureDragUpdateCallback? onDragPanUpdate;
  final GestureDragEndCallback? onDragPanEnd;
  final void Function(PointerDownEvent event, WorkflowEdgeHandle handle)?
      onWirePointerDown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delayMs = node.delayMs;
    final detail = delayMs != null && delayMs > 0
        ? '${delayMs}ms'
        : 'Set wait time';
    return SizedBox(
      width: kWorkflowDelayNodeWidth,
      height: kWorkflowDelayNodeHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: WorkflowInteractiveNode(
              selected: selected,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              borderColor: selected
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              onTap: onTap,
              onDoubleTap: onDoubleTap,
              onPanUpdate: onDragPanUpdate,
              onPanEnd: onDragPanEnd,
              actions: selected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NodeActionButton(
                          icon: Icons.copy_outlined,
                          tooltip: kTooltipDuplicate,
                          onPressed: onDuplicate,
                        ),
                        _NodeActionButton(
                          icon: Icons.delete_outline,
                          tooltip: kTooltipDelete,
                          onPressed: onDelete,
                        ),
                      ],
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 20),
                      kHSpacer8,
                      Expanded(
                        child: Text(
                          node.label.isNotEmpty
                              ? node.label
                              : kLabelWorkflowDelay,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      if (selected) const SizedBox(width: 56),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -6,
            top: kDelayPortInY - 10,
            child: WorkflowPort(
              label: 'In',
              side: WorkflowPortSide.left,
              color: theme.colorScheme.primary,
              highlighted: highlightInput,
            ),
          ),
          Positioned(
            right: -6,
            top: kDelayPortNextY - 10,
            child: WorkflowPort(
              label: 'Next',
              side: WorkflowPortSide.right,
              color: theme.colorScheme.primary,
              highlighted: highlightNext,
              onPointerDown: (event) => onWirePointerDown?.call(
                event,
                WorkflowEdgeHandle.next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
