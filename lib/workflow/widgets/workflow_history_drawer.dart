import 'package:apidash/utils/utils.dart';
import 'package:apidash/workflow/consts.dart';
import 'package:apidash/workflow/models/workflow_history_models.dart';
import 'package:apidash/workflow/providers/workflow_history_providers.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<void> showFlowHistoryDrawer(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: kLabelFlowHistory,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const Align(
        alignment: Alignment.centerRight,
        child: FlowHistoryDrawer(),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return SlideTransition(position: offset, child: child);
    },
  );
}

class FlowHistoryDrawer extends ConsumerWidget {
  const FlowHistoryDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final drawerWidth = width < 520 ? width * 0.92 : 360.0;
    final runs = ref.watch(flowHistoryForActiveWorkflowProvider);
    final workflow = ref.watch(activeWorkflowProvider);
    final running = ref.watch(workflowRunInProgressProvider);
    final dateFmt = DateFormat('MMM d, yyyy · h:mm a');

    return Material(
      elevation: 8,
      color: theme.colorScheme.surface,
      child: SizedBox(
        width: drawerWidth,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: kPh12.add(kPv8),
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    kHSpacer8,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kLabelFlowHistory,
                            style: theme.textTheme.titleMedium,
                          ),
                          if (workflow != null)
                            Text(
                              workflow.name.isNotEmpty
                                  ? workflow.name
                                  : workflow.id,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (running)
                Padding(
                  padding: kP12,
                  child: Text(
                    'A run is in progress. Open history after it finishes.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              Expanded(
                child: runs.isEmpty
                    ? Center(
                        child: Padding(
                          padding: kP20,
                          child: Text(
                            kMsgFlowHistoryEmpty,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: kP8,
                        itemCount: runs.length,
                        separatorBuilder: (_, _) => kVSpacer6,
                        itemBuilder: (context, index) {
                          final meta = runs[index];
                          return _FlowHistoryTile(
                            meta: meta,
                            dateLabel: dateFmt.format(meta.startedAt.toLocal()),
                            enabled: !running,
                            onOpen: () async {
                              HapticFeedback.selectionClick();
                              await openFlowHistoryInInspector(
                                ref: ref,
                                runId: meta.runId,
                              );
                              if (context.mounted) {
                                Navigator.of(context).maybePop();
                              }
                            },
                            onDelete: () async {
                              HapticFeedback.selectionClick();
                              await ref
                                  .read(flowHistoryMetasProvider.notifier)
                                  .deleteRun(meta.runId);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowHistoryTile extends StatelessWidget {
  const _FlowHistoryTile({
    required this.meta,
    required this.dateLabel,
    required this.enabled,
    required this.onOpen,
    required this.onDelete,
  });

  final FlowHistoryMeta meta;
  final String dateLabel;
  final bool enabled;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final successColor = getResponseStatusCodeColor(
      200,
      brightness: theme.brightness,
    );
    final statusColor =
        meta.success ? successColor : theme.colorScheme.error;

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: kBorderRadius12,
      child: InkWell(
        borderRadius: kBorderRadius12,
        onTap: enabled ? onOpen : null,
        child: Padding(
          padding: kP12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                meta.success
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                color: statusColor,
              ),
              kHSpacer10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meta.success ? 'Succeeded' : 'Failed',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    kVSpacer3,
                    Text(
                      dateLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    kVSpacer3,
                    Text(
                      '${meta.stepCount} steps · ${meta.durationMs} ms',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontFamily: kCodeStyle.fontFamily,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    kVSpacer8,
                    Text(
                      kMsgFlowHistoryOpen,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                visualDensity: VisualDensity.compact,
                onPressed: enabled ? onDelete : null,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
