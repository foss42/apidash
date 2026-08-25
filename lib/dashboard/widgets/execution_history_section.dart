import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/ui_utils.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/dashboard_models.dart';
import '../utils/dashboard_metrics.dart';
import 'dashboard_common.dart';

/// Tab-scoped execution history — requests on Collections, workflows on Workflows.
class ExecutionHistorySection extends ConsumerWidget {
  const ExecutionHistorySection({
    super.key,
    required this.scope,
  });

  /// Must be [ExecutionHistoryFilter.requests] or [ExecutionHistoryFilter.workflows].
  final ExecutionHistoryFilter scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    assert(
      scope == ExecutionHistoryFilter.requests ||
          scope == ExecutionHistoryFilter.workflows,
      'ExecutionHistorySection scope must be requests or workflows',
    );

    final requestMetas = ref.watch(filteredHistoryMetasProvider);
    final flowMetas = ref.watch(filteredFlowHistoryProvider);
    final timings = ref.watch(historyTimingsProvider).value ?? const {};
    final entries = buildUnifiedExecutionHistory(
      requestMetas: requestMetas,
      timingsMsByHistoryId: timings,
      flowMetas: flowMetas,
      filter: scope,
    );

    final scheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('MMM d · HH:mm:ss');
    final isRequests = scope == ExecutionHistoryFilter.requests;

    return DashboardSection(
      title: isRequests ? 'Request execution history' : 'Workflow execution history',
      initiallyExpanded: false,
      child: entries.isEmpty
          ? Text(
              isRequests
                  ? 'No request executions in this range.'
                  : 'No workflow runs in this range.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            )
          : Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(2.6),
                2: FlexColumnWidth(1.0),
                3: FlexColumnWidth(1.0),
                4: FlexColumnWidth(1.4),
              },
              children: [
                TableRow(
                  children: [
                    for (final h in [
                      'When',
                      'Name',
                      'Status',
                      'Duration',
                      'Detail',
                    ])
                      Padding(
                        padding: kPb10,
                        child: Text(
                          h,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                  ],
                ),
                for (final e in entries)
                  TableRow(
                    children: [
                      InkWell(
                        onTap: () => _open(ref, e),
                        child: _cell(context, fmt.format(e.at.toLocal())),
                      ),
                      _cell(context, e.title, maxLines: 1),
                      _cell(
                        context,
                        e.success ? 'Success' : 'Failed',
                        color: e.success
                            ? dashboardSuccessColor(context)
                            : scheme.error,
                      ),
                      _cell(context, formatMs(e.durationMs)),
                      e.kind == ExecutionKind.request && e.statusCode != null
                          ? _cell(
                              context,
                              e.detail ?? '',
                              color: getResponseStatusCodeColor(
                                e.statusCode,
                                brightness: Theme.of(context).brightness,
                              ),
                            )
                          : _cell(context, e.detail ?? '—', maxLines: 1),
                    ],
                  ),
              ],
            ),
    );
  }

  void _open(WidgetRef ref, ExecutionHistoryEntry e) {
    if (e.kind == ExecutionKind.request) {
      ref.read(navRailIndexStateProvider.notifier).state = kNavRailHistoryIndex;
      ref.read(historyMetaStateNotifier.notifier).loadHistoryRequest(e.id);
      return;
    }
    ref.read(navRailIndexStateProvider.notifier).state = kNavRailWorkflowsIndex;
    ref.read(viewingFlowHistoryRunIdProvider.notifier).state = e.id;
  }
}

Widget _cell(
  BuildContext context,
  String text, {
  Color? color,
  int maxLines = 2,
}) {
  return Padding(
    padding: kPv6,
    child: Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: color != null ? FontWeight.w600 : null,
          ),
    ),
  );
}
