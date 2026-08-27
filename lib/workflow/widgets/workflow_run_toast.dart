import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class WorkflowRunToastData {
  const WorkflowRunToastData({
    required this.success,
    required this.message,
    required this.token,
  });

  final bool success;
  final String message;
  final int token;
}

final workflowRunToastQueueProvider =
    StateProvider<List<WorkflowRunToastData>>((ref) => const []);

int _toastToken = 0;

int workflowRunToastMaxVisible(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  if (context.isMediumWindow || size.height < 720 || size.width < 900) {
    return 3;
  }
  return 4;
}

/// Replaces the canvas toast stack (success = single toast, failures = stacked).
void showWorkflowRunToasts(
  WidgetRef ref,
  List<WorkflowRunToastData> toasts,
) {
  ref.read(workflowRunToastQueueProvider.notifier).state = [
    for (final toast in toasts)
      WorkflowRunToastData(
        success: toast.success,
        message: toast.message,
        token: toast.token == 0 ? ++_toastToken : toast.token,
      ),
  ];
}

void showWorkflowRunToast(
  WidgetRef ref, {
  required bool success,
  String? message,
}) {
  showWorkflowRunToasts(ref, [
    WorkflowRunToastData(
      success: success,
      message:
          message ?? (success ? kMsgWorkflowRunSuccess : kMsgWorkflowRunFailed),
      token: ++_toastToken,
    ),
  ]);
}

/// One toast per failed step (capped later by the canvas stack).
void showWorkflowRunFailureToasts(
  WidgetRef ref,
  WorkflowRunResult result,
) {
  final failed = [
    for (final node in result.nodeResults)
      if (node.status == WorkflowNodeRunStatus.failed) node,
  ];
  if (failed.isEmpty) {
    showWorkflowRunToast(
      ref,
      success: false,
      message: result.error ?? kMsgWorkflowRunFailed,
    );
    return;
  }

  final seen = <String>{};
  final toasts = <WorkflowRunToastData>[];
  for (final node in failed) {
    final key = '${node.nodeId}|${node.loopIndex ?? ''}';
    if (!seen.add(key)) {
      continue;
    }
    final label =
        node.label.trim().isNotEmpty ? node.label.trim() : node.nodeId;
    final raw = (node.message ?? '').trim();
    final message = raw.isNotEmpty
        ? raw
        : 'Step failed [$label]';
    toasts.add(
      WorkflowRunToastData(
        success: false,
        message: message,
        token: ++_toastToken,
      ),
    );
  }
  showWorkflowRunToasts(ref, toasts);
}

/// Fixed toast stack rendered inside [WorkflowCanvas] (top-left).
class WorkflowCanvasRunToast extends ConsumerWidget {
  const WorkflowCanvasRunToast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(workflowRunToastQueueProvider);
    if (queue.isEmpty) {
      return const SizedBox.shrink();
    }
    final maxVisible = workflowRunToastMaxVisible(context);
    final visible = queue.take(maxVisible).toList(growable: false);
    final hiddenCount = queue.length - visible.length;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) kVSpacer8,
            _WorkflowToastCard(
              key: ValueKey(visible[i].token),
              data: visible[i],
              onDismiss: () {
                final current = ref.read(workflowRunToastQueueProvider);
                ref.read(workflowRunToastQueueProvider.notifier).state = [
                  for (final toast in current)
                    if (toast.token != visible[i].token) toast,
                ];
              },
            ),
          ],
          if (hiddenCount > 0) ...[
            kVSpacer8,
            Text(
              '+$hiddenCount more',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WorkflowToastCard extends StatefulWidget {
  const _WorkflowToastCard({
    super.key,
    required this.data,
    required this.onDismiss,
  });

  final WorkflowRunToastData data;
  final VoidCallback onDismiss;

  @override
  State<_WorkflowToastCard> createState() => _WorkflowToastCardState();
}

class _WorkflowToastCardState extends State<_WorkflowToastCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _slide = Tween<Offset>(
      begin: const Offset(-0.08, -0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    Future<void>.delayed(const Duration(milliseconds: 3200), _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) {
      return;
    }
    await _controller.reverse();
    if (mounted) {
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brightness = theme.brightness;
    final successGreen = brightness == Brightness.dark
        ? Colors.green.shade400
        : Colors.green.shade600;
    final accent = widget.data.success ? successGreen : scheme.error;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accent.withValues(alpha: 0.75),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.14),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: 0.12),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Icon(
                      widget.data.success
                          ? Icons.check_rounded
                          : Icons.error_outline_rounded,
                      size: 18,
                      color: accent,
                    ),
                  ),
                  kHSpacer10,
                  Flexible(
                    child: Text(
                      widget.data.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Dismiss',
                    onPressed: _dismiss,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
