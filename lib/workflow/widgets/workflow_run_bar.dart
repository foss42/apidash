import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash/workflow/widgets/workflow_add_node_sheet.dart';
import 'package:apidash/workflow/widgets/workflow_run_toast.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> triggerWorkflowRun(BuildContext context, WidgetRef ref) async {
  if (ref.read(workflowRunInProgressProvider)) {
    return;
  }
  HapticFeedback.mediumImpact();
  final result = await runActiveWorkflow(ref);
  if (!context.mounted || result == null) {
    return;
  }
  if (result.success) {
    showWorkflowRunToast(ref, success: true);
    return;
  }
  showWorkflowRunFailureToasts(ref, result);
}

class WorkflowRunBar extends ConsumerWidget {
  const WorkflowRunBar({
    super.key,
    this.bottomPadding = kWorkflowRunBarFabClearance,
  });

  final double bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final workflow = ref.watch(activeWorkflowProvider);
    final running = ref.watch(workflowRunInProgressProvider);

    if (workflow == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: running
                ? theme.colorScheme.primary.withValues(alpha: 0.45)
                : theme.colorScheme.outline.withValues(alpha: 0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  animationDuration: const Duration(milliseconds: 120),
                ),
                onPressed: running
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        showWorkflowAddNodeSheet(context, ref);
                      },
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text(kLabelAddWorkflowNode),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: kTooltipAutoArrange,
                child: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    animationDuration: const Duration(milliseconds: 120),
                  ),
                  onPressed: running
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          ref
                              .read(activeWorkflowProvider.notifier)
                              .autoArrangeGraph();
                        },
                  icon: const Icon(Icons.account_tree_outlined, size: 20),
                  label: Text(
                    context.isMediumWindow ? 'Arrange' : kLabelAutoArrange,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: FilledButton.icon(
                  key: ValueKey(running),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    animationDuration: const Duration(milliseconds: 120),
                  ),
                  onPressed: running
                      ? () {
                          ref
                                  .read(workflowRunInProgressProvider.notifier)
                                  .state =
                              false;
                          settleInterruptedWorkflowRunResults(ref);
                        }
                      : () => triggerWorkflowRun(context, ref),
                  icon: running
                      ? SizedBox()
                      : const Icon(Icons.play_arrow_rounded, size: 20),
                  label: Text(running ? kLabelStopWorkflow : kLabelRunWorkflow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
