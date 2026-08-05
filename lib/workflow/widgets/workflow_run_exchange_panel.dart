import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash/workflow/providers/workflow_ui_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkflowRunInspector extends ConsumerStatefulWidget {
  const WorkflowRunInspector({super.key});

  @override
  ConsumerState<WorkflowRunInspector> createState() =>
      _WorkflowRunInspectorState();
}

class _WorkflowRunInspectorState extends ConsumerState<WorkflowRunInspector> {
  bool _showResponse = true;
  final _stepsScrollController = ScrollController();
  final _chipKeys = <String, GlobalKey>{};

  @override
  void dispose() {
    _stepsScrollController.dispose();
    super.dispose();
  }

  String _resultKey(WorkflowNodeRunResult result) => result.loopIndex != null
      ? '${result.nodeId}#${result.loopIndex}'
      : result.nodeId;

  String _stepTitle(WorkflowNodeRunResult result) {
    final base = result.label.isNotEmpty ? result.label : result.nodeId;
    if (result.loopIndex == null) {
      return base;
    }
    final n = int.tryParse(result.loopIndex!);
    return n == null ? '$base #${result.loopIndex}' : '$base #${n + 1}';
  }

  GlobalKey _chipKeyFor(String key) =>
      _chipKeys.putIfAbsent(key, GlobalKey.new);

  void _scrollChipIntoView(String key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _chipKeys[key]?.currentContext;
      if (ctx == null || !mounted) {
        return;
      }
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: 0.35,
      );
    });
  }

  void _selectResult(WorkflowNodeRunResult result) {
    HapticFeedback.selectionClick();
    final key = _resultKey(result);
    ref.read(selectedWorkflowRunResultKeyProvider.notifier).state = key;
    ref.read(selectedWorkflowNodeIdProvider.notifier).state = result.nodeId;
    ref.read(workflowRunInspectorExpandedProvider.notifier).state = true;
    setState(() {
      if (result.hasHttpExchange) {
        _showResponse = true;
      }
    });
    _scrollChipIntoView(key);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workflow = ref.watch(activeWorkflowProvider);
    final resultsById = ref.watch(workflowNodeRunResultsProvider);
    final stepOrder = ref.watch(workflowRunStepOrderProvider);
    final running = ref.watch(workflowRunInProgressProvider);
    final selectedKey = ref.watch(selectedWorkflowRunResultKeyProvider);
    final expanded = ref.watch(workflowRunInspectorExpandedProvider);

    if (workflow == null || (resultsById.isEmpty && !running)) {
      return const SizedBox.shrink();
    }

    if (!expanded) {
      return const _CollapsedInspectorBar();
    }

    final orderedResults = [
      for (final id in stepOrder)
        if (resultsById[id] case final result?) result,
    ];

    final selected = selectedKey == null ? null : resultsById[selectedKey];
    final latestHttp = orderedResults.reversed
        .cast<WorkflowNodeRunResult?>()
        .firstWhere(
          (r) => r?.hasHttpExchange == true,
          orElse: () => null,
        );
    final effective = selected ??
        latestHttp ??
        (orderedResults.isNotEmpty ? orderedResults.last : null);

    if (selectedKey == null && latestHttp != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        if (ref.read(selectedWorkflowRunResultKeyProvider) != null) {
          return;
        }
        final key = _resultKey(latestHttp);
        ref.read(selectedWorkflowRunResultKeyProvider.notifier).state = key;
        _scrollChipIntoView(key);
      });
    }

    final failed = orderedResults
        .where((r) => r.status == WorkflowNodeRunStatus.failed)
        .length;
    final totalMs = orderedResults.fold<int>(
      0,
      (sum, result) => sum + (result.durationMs ?? 0),
    );
    final compact = context.isMediumWindow;
    final showHttp = effective?.hasHttpExchange == true;
    // Keep a fixed detail pane height so Start / condition / request chips
    // do not resize the inspector when switching selection.
    final detailHeight = compact
        ? kWorkflowRunExchangeHeightCompact
        : kWorkflowRunExchangeHeight;

    return Material(
      color: theme.colorScheme.surface,
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          _Header(
            running: running,
            stepCount: orderedResults.length,
            failed: failed,
            totalMs: totalMs,
            onToggle: () {
              HapticFeedback.selectionClick();
              ref.read(workflowRunInspectorExpandedProvider.notifier).state =
                  false;
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 64,
                child: orderedResults.isEmpty && running
                    ? Center(
                        child: Text(
                          'Waiting for first step…',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: _stepsScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: kPh12.add(kPv8),
                        itemCount: orderedResults.length,
                        separatorBuilder: (_, index) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            kHSpacer4,
                            _StepConnector(
                              completed: orderedResults[index].status ==
                                      WorkflowNodeRunStatus.success ||
                                  orderedResults[index].status ==
                                      WorkflowNodeRunStatus.failed,
                              active: orderedResults[index].status ==
                                  WorkflowNodeRunStatus.running,
                            ),
                            kHSpacer4,
                          ],
                        ),
                        itemBuilder: (context, index) {
                          final result = orderedResults[index];
                          final key = _resultKey(result);
                          final activeKey = selectedKey ??
                              (effective != null
                                  ? _resultKey(effective)
                                  : null);
                          final selectedChip = activeKey == key;
                          return _StepChip(
                            key: _chipKeyFor(key),
                            index: index + 1,
                            title: _stepTitle(result),
                            result: result,
                            selected: selectedChip,
                            onTap: () => _selectResult(result),
                          );
                        },
                      ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: effective == null
                    ? (orderedResults.isNotEmpty
                        ? Padding(
                            key: const ValueKey('hint'),
                            padding: kP12,
                            child: Text(
                              kMsgWorkflowSelectStep,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey('empty')))
                    : Column(
                        key: ValueKey(
                          selectedKey ?? _resultKey(effective),
                        ),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(height: 1),
                          SizedBox(
                            height: detailHeight,
                            child: showHttp
                                ? (compact
                                    ? _CompactExchange(
                                        result: effective,
                                        showResponse: _showResponse,
                                        onToggle: (showResponse) {
                                          setState(
                                            () =>
                                                _showResponse = showResponse,
                                          );
                                        },
                                      )
                                    : _SplitExchange(
                                        result: effective,
                                      ))
                                : _StepEventLog(result: effective),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.running,
    required this.stepCount,
    required this.failed,
    required this.totalMs,
    required this.onToggle,
  });

  final bool running;
  final int stepCount;
  final int failed;
  final int totalMs;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allSucceeded = !running && stepCount > 0 && failed == 0;
    final hasFailures = !running && failed > 0;
    final summary = running
        ? 'Running…'
        : hasFailures
            ? '$stepCount steps · $failed failed'
            : allSucceeded
                ? '$stepCount steps completed'
                : '$stepCount steps';
    final successColor = getResponseStatusCodeColor(
      200,
      brightness: theme.brightness,
    );
    final statusColor = running
        ? theme.colorScheme.primary
        : hasFailures
            ? theme.colorScheme.error
            : allSucceeded
                ? successColor
                : theme.colorScheme.onSurface;
    final statusIcon = running
        ? Icons.sync_rounded
        : hasFailures
            ? Icons.error_outline_rounded
            : allSucceeded
                ? Icons.check_circle_rounded
                : Icons.terminal_rounded;

    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: kPh12.add(kPv8),
        child: Row(
          children: [
            Tooltip(
              message: kTooltipWorkflowCollapseRunInspector,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            kHSpacer4,
            Icon(
              Icons.terminal_rounded,
              size: kButtonIconSizeMedium,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    statusIcon,
                    size: kButtonIconSizeLarge,
                    color: statusColor,
                  ),
                  kHSpacer8,
                  Flexible(
                    child: Text(
                      summary,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: statusColor,
                        fontWeight: allSucceeded || hasFailures
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (!running && stepCount > 0) ...[
                    kHSpacer8,
                    Text(
                      '${totalMs}ms',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: allSucceeded
                            ? successColor
                            : theme.colorScheme.onSurfaceVariant,
                        fontFamily: kCodeStyle.fontFamily,
                      ),
                    ),
                  ],
                  if (running) ...[
                    kHSpacer8,
                    const SizedBox(
                      width: kButtonIconSizeSmall,
                      height: kButtonIconSizeSmall,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
            ),
            // Balance the left collapse controls so the center stays centered.
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}

class _CollapsedInspectorBar extends ConsumerWidget {
  const _CollapsedInspectorBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final results = ref.watch(workflowNodeRunResultsProvider);
    final running = ref.watch(workflowRunInProgressProvider);
    final failed = results.values
        .where((r) => r.status == WorkflowNodeRunStatus.failed)
        .length;
    final successColor = getResponseStatusCodeColor(
      200,
      brightness: theme.brightness,
    );
    final statusColor = running
        ? theme.colorScheme.primary
        : failed > 0
            ? theme.colorScheme.error
            : successColor;
    final label = running
        ? 'Running…'
        : failed > 0
            ? '$failed failed'
            : 'Run inspector';

    return Material(
      color: theme.colorScheme.surface,
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.12),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          ref.read(workflowRunInspectorExpandedProvider.notifier).state = true;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1),
            Padding(
              padding: kPh12.add(kPv8),
              child: Row(
                children: [
                  Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  kHSpacer4,
                  Icon(
                    Icons.terminal_rounded,
                    size: kButtonIconSizeMedium,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  kHSpacer8,
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({
    required this.completed,
    required this.active,
  });

  final bool completed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = active
        ? theme.colorScheme.primary
        : completed
            ? getResponseStatusCodeColor(
                200,
                brightness: theme.brightness,
              ).withValues(alpha: 0.7)
            : theme.colorScheme.outlineVariant;

    return SizedBox(
      width: 16,
      child: active
          ? _PulsingDot(color: color)
          : AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2,
              decoration: BoxDecoration(
                color: color,
                borderRadius: kBorderRadius4,
              ),
            ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});

  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _StepChip extends StatefulWidget {
  const _StepChip({
    super.key,
    required this.index,
    required this.title,
    required this.result,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final String title;
  final WorkflowNodeRunResult result;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_StepChip> createState() => _StepChipState();
}

class _StepChipState extends State<_StepChip> with TickerProviderStateMixin {
  late final AnimationController _pressController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 160),
    lowerBound: 0,
    upperBound: 1,
  );
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void initState() {
    super.initState();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant _StepChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result.status != widget.result.status) {
      _syncPulse();
    }
  }

  void _syncPulse() {
    if (widget.result.status == WorkflowNodeRunStatus.running) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = widget.result;
    final selected = widget.selected;
    final statusColor = switch (result.status) {
      WorkflowNodeRunStatus.success => getResponseStatusCodeColor(
          200,
          brightness: theme.brightness,
        ),
      WorkflowNodeRunStatus.failed => theme.colorScheme.error,
      WorkflowNodeRunStatus.running => theme.colorScheme.primary,
      _ => theme.colorScheme.outline,
    };
    final statusIcon = switch (result.status) {
      WorkflowNodeRunStatus.success => Icons.check_rounded,
      WorkflowNodeRunStatus.failed => Icons.close_rounded,
      WorkflowNodeRunStatus.running => Icons.sync_rounded,
      _ => null,
    };

    final scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
    final pulse = Tween<double>(begin: 0.55, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    final isRunning = result.status == WorkflowNodeRunStatus.running;

    return AnimatedBuilder(
      animation: Listenable.merge([_pressController, _pulseController]),
      builder: (context, _) {
        final pulseValue = isRunning ? pulse.value : 0.0;
        return Transform.scale(
          scale: scale.value,
          child: GestureDetector(
            onTapDown: (_) => _pressController.forward(),
            onTapCancel: () => _pressController.reverse(),
            onTapUp: (_) {
              _pressController.reverse();
              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              constraints: const BoxConstraints(maxWidth: 240, minHeight: 44),
              padding: kPh12.add(kPv8),
              decoration: BoxDecoration(
                color: selected
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.72),
                borderRadius: kBorderRadius20,
                border: Border.all(
                  width: selected ? 1.6 : 1,
                  color: selected
                      ? theme.colorScheme.primary
                      : isRunning
                          ? theme.colorScheme.primary.withValues(alpha: 0.55)
                          : theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.55),
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  if (isRunning)
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(
                        alpha: 0.12 + (0.16 * pulseValue),
                      ),
                      blurRadius: 8 + (6 * pulseValue),
                      spreadRadius: 0.5,
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: statusIcon == null
                          ? Text(
                              key: ValueKey('i-${widget.index}'),
                              '${widget.index}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: statusColor,
                              ),
                            )
                          : Icon(
                              statusIcon,
                              key: ValueKey(statusIcon),
                              size: kButtonIconSizeSmall,
                              color: statusColor,
                            ),
                    ),
                  ),
                  kHSpacer8,
                  Flexible(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style:
                          (theme.textTheme.labelLarge ?? const TextStyle())
                              .copyWith(
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                      ),
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (result.statusCode != null) ...[
                    kHSpacer8,
                    StatusCode(statusCode: result.statusCode!),
                  ] else if (_conditionOutcomeLabel(result) case final outcome?) ...[
                    kHSpacer8,
                    Text(
                      outcome,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: outcome == 'True'
                            ? statusColor
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StepEventLog extends StatelessWidget {
  const _StepEventLog({required this.result});

  final WorkflowNodeRunResult result;

  String get _typeLabel => switch (result.nodeType) {
        WorkflowNodeType.manualStart => 'Start',
        WorkflowNodeType.delay => 'Delay',
        WorkflowNodeType.condition => 'Condition',
        WorkflowNodeType.loop => 'Loop',
        WorkflowNodeType.sequence => 'Sequence',
        WorkflowNodeType.request => 'Request',
        null => 'Step',
      };

  IconData get _typeIcon => switch (result.nodeType) {
        WorkflowNodeType.manualStart => Icons.play_arrow_rounded,
        WorkflowNodeType.delay => Icons.timer_outlined,
        WorkflowNodeType.condition => Icons.call_split_rounded,
        WorkflowNodeType.loop => Icons.repeat_rounded,
        WorkflowNodeType.sequence => Icons.list_alt_rounded,
        WorkflowNodeType.request => Icons.http_rounded,
        null => Icons.info_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final successColor = getResponseStatusCodeColor(
      200,
      brightness: theme.brightness,
    );
    final conditionOutcome = _conditionOutcomeLabel(result);
    final outcomeColor = switch (result.status) {
      WorkflowNodeRunStatus.success => successColor,
      WorkflowNodeRunStatus.failed => theme.colorScheme.error,
      WorkflowNodeRunStatus.running => theme.colorScheme.primary,
      _ => theme.colorScheme.onSurfaceVariant,
    };

    final title = result.label.isNotEmpty ? result.label : _typeLabel;
    final body = switch (result.nodeType) {
      WorkflowNodeType.condition => result.detail,
      WorkflowNodeType.delay => result.message,
      WorkflowNodeType.loop => result.message,
      WorkflowNodeType.manualStart => result.message,
      _ => result.message,
    };

    return ListView(
      padding: kP12,
      children: [
        Row(
          children: [
            Icon(
              _typeIcon,
              size: kButtonIconSizeMedium,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            kHSpacer8,
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (conditionOutcome != null)
              Text(
                conditionOutcome,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: conditionOutcome == 'True'
                      ? successColor
                      : theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              Text(
                result.status.name,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: outcomeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        if (body != null && body.isNotEmpty) ...[
          kVSpacer8,
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: result.nodeType == WorkflowNodeType.condition ||
                      result.nodeType == WorkflowNodeType.loop
                  ? kCodeStyle.fontFamily
                  : null,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
        if (result.durationMs != null) ...[
          kVSpacer6,
          Text(
            'Time Taken: ${result.durationMs} ms',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (result.loopIndex != null) ...[
          kVSpacer6,
          Text(
            'Iteration ${(int.tryParse(result.loopIndex!) ?? -1) + 1}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

String? _conditionOutcomeLabel(WorkflowNodeRunResult result) {
  if (result.nodeType != WorkflowNodeType.condition) {
    return null;
  }
  final raw = (result.branch ?? result.message ?? '').toLowerCase();
  if (raw == 'true' || raw == 'then') {
    return 'True';
  }
  if (raw == 'false' || raw == 'else') {
    return 'False';
  }
  return null;
}

class _CompactExchange extends StatelessWidget {
  const _CompactExchange({
    required this.result,
    required this.showResponse,
    required this.onToggle,
  });

  final WorkflowNodeRunResult result;
  final bool showResponse;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: kPh12.add(kPt8),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text(kLabelWorkflowRunRequest),
                icon: Icon(
                  Icons.upload_rounded,
                  size: kButtonIconSizeMedium,
                ),
              ),
              ButtonSegment(
                value: true,
                label: Text(kLabelWorkflowRunResponse),
                icon: Icon(
                  Icons.download_rounded,
                  size: kButtonIconSizeMedium,
                ),
              ),
            ],
            selected: {showResponse},
            onSelectionChanged: (value) => onToggle(value.first),
          ),
        ),
        Expanded(
          child: showResponse
              ? _ResponsePane(result: result)
              : _RequestPane(result: result),
        ),
      ],
    );
  }
}

class _SplitExchange extends StatelessWidget {
  const _SplitExchange({required this.result});

  final WorkflowNodeRunResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PaneTitle(
                icon: Icons.upload_rounded,
                title: kLabelWorkflowRunRequest,
                trailing: result.method == null
                    ? null
                    : Text(
                        result.method!.name.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontFamily: kCodeStyle.fontFamily,
                          fontWeight: FontWeight.w700,
                          color: getHTTPMethodColor(result.method),
                        ),
                      ),
              ),
              const Divider(height: 1),
              Expanded(child: _RequestPane(result: result)),
            ],
          ),
        ),
        VerticalDivider(
          width: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PaneTitle(
                icon: Icons.download_rounded,
                title: kLabelWorkflowRunResponse,
                trailing: result.statusCode == null
                    ? null
                    : StatusCode(statusCode: result.statusCode!),
              ),
              const Divider(height: 1),
              Expanded(child: _ResponsePane(result: result)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaneTitle extends StatelessWidget {
  const _PaneTitle({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      padding: kPh12,
      color: theme.colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          Icon(
            icon,
            size: kButtonIconSizeMedium,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          kHSpacer8,
          Text(title, style: theme.textTheme.labelLarge),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _RequestPane extends StatelessWidget {
  const _RequestPane({required this.result});

  final WorkflowNodeRunResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final method = (result.method ?? HTTPVerb.get).name.toUpperCase();
    final url = result.url?.trim().isNotEmpty == true ? result.url! : '—';
    final headers = result.requestHeaders ?? const <String, String>{};
    final body = result.requestBody?.trim() ?? '';
    final extracted = result.extractedVariables;

    return ListView(
      padding: kP12,
      children: [
        Container(
          width: double.infinity,
          padding: kP12,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.45,
            ),
            borderRadius: kBorderRadius10,
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                method,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontFamily: kCodeStyle.fontFamily,
                  fontWeight: FontWeight.w800,
                  color: getHTTPMethodColor(result.method),
                ),
              ),
              kHSpacer10,
              Expanded(
                child: SelectableText(
                  url,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: kCodeStyle.fontFamily,
                    height: 1.35,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Copy URL',
                visualDensity: VisualDensity.compact,
                onPressed: url == '—'
                    ? null
                    : () async {
                        await Clipboard.setData(ClipboardData(text: url));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('URL copied'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                icon: const Icon(
                  Icons.copy_rounded,
                  size: kButtonIconSizeMedium,
                ),
              ),
            ],
          ),
        ),
        if (result.durationMs != null || result.statusCode != null) ...[
          kVSpacer10,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (result.statusCode != null)
                _MetaChip(
                  label: 'Status',
                  value: '${result.statusCode}',
                  valueColor: getResponseStatusCodeColor(
                    result.statusCode,
                    brightness: theme.brightness,
                  ),
                ),
              if (result.durationMs != null)
                _MetaChip(label: 'Time', value: '${result.durationMs} ms'),
              if (result.message != null && result.message!.isNotEmpty)
                _MetaChip(label: 'Message', value: result.message!),
            ],
          ),
        ],
        if (headers.isNotEmpty) ...[
          kVSpacer16,
          Text('Headers', style: theme.textTheme.titleSmall),
          kVSpacer8,
          _KeyValueBlock(entries: headers),
        ],
        if (body.isNotEmpty) ...[
          kVSpacer16,
          Text('Body', style: theme.textTheme.titleSmall),
          kVSpacer8,
          _CodeBlock(text: body),
        ],
        if (extracted.isNotEmpty) ...[
          kVSpacer16,
          Text('Extractions variables', style: theme.textTheme.titleSmall),
          kVSpacer8,
          _KeyValueBlock(
            entries: {
              for (final e in extracted.entries) '{{${e.key}}}': e.value,
            },
          ),
        ],
        if (headers.isEmpty && body.isEmpty && extracted.isEmpty) ...[
          kVSpacer16,
          Text(
            'No headers or body on this request.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _ResponsePane extends StatelessWidget {
  const _ResponsePane({required this.result});

  final WorkflowNodeRunResult result;

  @override
  Widget build(BuildContext context) {
    final model = result.asRequestModel();
    if (model == null) {
      return const Center(child: Text(kMsgWorkflowNoExchange));
    }
    if (result.statusCode == null && result.httpResponseModel == null) {
      return Center(
        child: Padding(
          padding: kP12,
          child: Text(
            result.message?.isNotEmpty == true
                ? result.message!
                : kMsgWorkflowNoResponseBody,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (result.statusCode == -1 ||
        (result.httpResponseModel == null && result.statusCode != null)) {
      return ErrorMessage(
        message: result.message ?? kMsgWorkflowNoResponseBody,
        showIssueButton: false,
      );
    }

    return Column(
      children: [
        ResponsePaneHeader(
          responseStatus: result.statusCode,
          message: result.message,
          time: result.httpResponseModel?.time ??
              (result.durationMs != null
                  ? Duration(milliseconds: result.durationMs!)
                  : null),
        ),
        Expanded(
          child: ResponseBody(
            selectedRequestModel: model,
            isPartOfHistory: true,
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: kPh8.add(kPv6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: kBorderRadius8,
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            TextSpan(
              text: value,
              style: theme.textTheme.labelMedium?.copyWith(
                fontFamily: kCodeStyle.fontFamily,
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyValueBlock extends StatelessWidget {
  const _KeyValueBlock({required this.entries});

  final Map<String, String> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: kP10,
      decoration: BoxDecoration(
        borderRadius: kBorderRadius10,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in entries.entries)
            Padding(
              padding: kPb6,
              child: SelectableText.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${entry.key}: ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: kCodeStyle.fontFamily,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: entry.value,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: kCodeStyle.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: kP12,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: kBorderRadius10,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: SelectableText(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: kCodeStyle.fontFamily,
          height: 1.4,
        ),
      ),
    );
  }
}

/// Kept for older imports; prefer [WorkflowRunInspector].
@Deprecated('Use WorkflowRunInspector')
class WorkflowRunExchangePanel extends StatelessWidget {
  const WorkflowRunExchangePanel({super.key});

  @override
  Widget build(BuildContext context) => const WorkflowRunInspector();
}
