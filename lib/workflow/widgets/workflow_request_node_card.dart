import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/utils/workflow_loop_utils.dart';
import 'package:apidash/workflow/utils/workflow_run_path.dart';
import 'package:apidash/workflow/widgets/workflow_interactive_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkflowRequestNodeCard extends StatelessWidget {
  const WorkflowRequestNodeCard({
    super.key,
    required this.node,
    required this.selected,
    required this.runResult,
    this.onDuplicate,
    this.onDelete,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final WorkflowNodeRunResult? runResult;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;

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
    final defaultLabel = isAi ? kLabelAiRequest : kLabelWorkflowStep;
    final borderColor = workflowNodeRunBorderColor(
      result: runResult,
      selected: selected,
      scheme: theme.colorScheme,
      brightness: theme.brightness,
      idleColor: theme.dividerColor,
    );
    final isRunning = runResult?.status == WorkflowNodeRunStatus.running;

    return SizedBox(
      width: kWorkflowRequestNodeWidth,
      height: kWorkflowRequestNodeHeight,
      child: WorkflowInteractiveNode(
        selected: selected,
        runEmphasized: isRunning,
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        borderColor: borderColor,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
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
                if (isRunning) ...[
                  kHSpacer8,
                  Icon(
                    Icons.sync_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Running',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
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
    this.runResult,
    this.onPlay,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final WorkflowNodeRunResult? runResult;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = getResponseStatusCodeColor(200, brightness: theme.brightness);
    final borderColor = workflowNodeRunBorderColor(
      result: runResult,
      selected: selected,
      scheme: theme.colorScheme,
      brightness: theme.brightness,
      selectedColor: green,
      idleColor: theme.dividerColor,
    );
    final isRunning = runResult?.status == WorkflowNodeRunStatus.running;
    return SizedBox(
      width: kWorkflowStartNodeWidth,
      height: kWorkflowStartNodeHeight,
      child: WorkflowInteractiveNode(
        selected: selected || isRunning,
        runEmphasized: isRunning,
        backgroundColor: Color.alphaBlend(
          green.withValues(
            alpha: theme.brightness == Brightness.dark ? 0.30 : 0.14,
          ),
          theme.colorScheme.surfaceContainerLow,
        ),
        borderColor: borderColor,
        borderRadius: 16,
        padding: const EdgeInsets.fromLTRB(12, 12, 40, 12),
        child: Row(
          children: [
            Material(
              color: green,
              shape: const CircleBorder(),
              elevation: selected ? 2 : 0,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onPlay?.call();
                },
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
            kHSpacer10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    node.label.isEmpty ? 'Start' : node.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isRunning ? 'Starting…' : 'Run workflow',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isRunning
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isRunning ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkflowConditionNodeCard extends StatelessWidget {
  const WorkflowConditionNodeCard({
    super.key,
    required this.node,
    required this.selected,
    this.runResult,
    this.onDuplicate,
    this.onDelete,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final WorkflowNodeRunResult? runResult;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = workflowNodeRunBorderColor(
      result: runResult,
      selected: selected,
      scheme: theme.colorScheme,
      brightness: theme.brightness,
      idleColor: theme.dividerColor,
    );
    final isRunning = runResult?.status == WorkflowNodeRunStatus.running;
    return SizedBox(
      width: kWorkflowConditionNodeWidth,
      height: kWorkflowConditionNodeHeight,
      child: WorkflowInteractiveNode(
        selected: selected || isRunning,
        runEmphasized: isRunning,
        backgroundColor: Color.alphaBlend(
          const Color(0xFFFFB300).withValues(
            alpha: theme.brightness == Brightness.dark ? 0.22 : 0.14,
          ),
          theme.colorScheme.surfaceContainerLow,
        ),
        borderColor: borderColor,
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
                if (isRunning)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      'Running',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
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
    );
  }
}

class WorkflowLoopNodeCard extends StatelessWidget {
  const WorkflowLoopNodeCard({
    super.key,
    required this.node,
    required this.selected,
    this.runResult,
    this.onDuplicate,
    this.onDelete,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final WorkflowNodeRunResult? runResult;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loopExprRaw = node.loopExpression ?? 'var:items';
    final listRef = formatLoopListVariableRef(loopExprRaw);
    final maxIterations = node.loopMaxIterations;
    final field = node.loopItemField?.trim();
    final asName = node.loopItemAs?.trim();
    final hasItemVar = asName != null && asName.isNotEmpty;
    final isRepeat = node.loopMode == WorkflowLoopMode.repeat;
    final subtitle = isRepeat
        ? (maxIterations != null && maxIterations > 0
              ? 'Repeat $maxIterations×'
              : 'Repeat')
        : listRef.isEmpty
        ? 'Set list'
        : listRef;
    final itemLine = hasItemVar
        ? (field != null && field.isNotEmpty ? '{{$asName}} ← $field' : '{{$asName}}')
        : null;
    final maxLine = !isRepeat && maxIterations != null && maxIterations > 0
        ? 'Max $maxIterations'
        : null;
    final borderColor = workflowNodeRunBorderColor(
      result: runResult,
      selected: selected,
      scheme: theme.colorScheme,
      brightness: theme.brightness,
      idleColor: theme.dividerColor,
    );
    final isRunning = runResult?.status == WorkflowNodeRunStatus.running;

    return SizedBox(
      width: kWorkflowLoopNodeWidth,
      height: kWorkflowLoopNodeHeight,
      child: WorkflowInteractiveNode(
        selected: selected || isRunning,
        runEmphasized: isRunning,
        padding: const EdgeInsets.fromLTRB(28, 12, 52, 22),
        backgroundColor: theme.colorScheme.secondaryContainer,
        borderColor: borderColor,
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
                    node.label.isNotEmpty ? node.label : kLabelWorkflowLoop,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                if (isRunning)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      'Running',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (selected) const SizedBox(width: 56),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            if (itemLine != null) ...[
              const SizedBox(height: 2),
              Text(
                itemLine,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
            if (maxLine != null) ...[
              const SizedBox(height: 2),
              Text(
                maxLine,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class WorkflowDelayNodeCard extends StatelessWidget {
  const WorkflowDelayNodeCard({
    super.key,
    required this.node,
    required this.selected,
    this.runResult,
    this.onDuplicate,
    this.onDelete,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final WorkflowNodeRunResult? runResult;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delayMs = node.delayMs;
    final detail = delayMs != null && delayMs > 0
        ? '${delayMs}ms'
        : 'Set wait time';
    final borderColor = workflowNodeRunBorderColor(
      result: runResult,
      selected: selected,
      scheme: theme.colorScheme,
      brightness: theme.brightness,
      idleColor: theme.dividerColor,
    );
    final isRunning = runResult?.status == WorkflowNodeRunStatus.running;
    return SizedBox(
      width: kWorkflowDelayNodeWidth,
      height: kWorkflowDelayNodeHeight,
      child: WorkflowInteractiveNode(
        selected: selected || isRunning,
        runEmphasized: isRunning,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        borderColor: borderColor,
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
                    node.label.isNotEmpty ? node.label : kLabelWorkflowDelay,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                if (isRunning)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      'Waiting',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
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
    );
  }
}

class WorkflowSequenceNodeCard extends StatelessWidget {
  const WorkflowSequenceNodeCard({
    super.key,
    required this.node,
    required this.selected,
    this.runResult,
    this.onDuplicate,
    this.onDelete,
  });

  final WorkflowGraphNode node;
  final bool selected;
  final WorkflowNodeRunResult? runResult;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final asName = node.loopItemAs?.trim();
    final asLabel =
        (asName != null && asName.isNotEmpty) ? '{{$asName}}' : 'set as';
    final sourceLabel = switch (node.sequenceSource) {
      WorkflowSequenceSource.list => 'List',
      WorkflowSequenceSource.json => 'JSON',
      WorkflowSequenceSource.jsonl => 'JSONL',
    };
    final borderColor = workflowNodeRunBorderColor(
      result: runResult,
      selected: selected,
      scheme: scheme,
      brightness: theme.brightness,
      idleColor: theme.dividerColor,
    );
    final isRunning = runResult?.status == WorkflowNodeRunStatus.running;
    final bg = Color.alphaBlend(
      scheme.primary.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.20 : 0.10,
      ),
      scheme.surfaceContainerLow,
    );
    return SizedBox(
      width: kWorkflowSequenceNodeWidth,
      height: kWorkflowSequenceNodeHeight,
      child: WorkflowInteractiveNode(
        selected: selected || isRunning,
        runEmphasized: isRunning,
        // Clear top "Next" port label.
        padding: const EdgeInsets.fromLTRB(14, 28, 14, 12),
        backgroundColor: bg,
        borderColor: borderColor,
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
                  Icons.list_alt_rounded,
                  size: 20,
                  color: scheme.primary,
                ),
                kHSpacer8,
                Expanded(
                  child: Text(
                    node.label.isNotEmpty
                        ? node.label
                        : kLabelWorkflowSequence,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                if (selected) const SizedBox(width: 56),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              sourceLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  asLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
