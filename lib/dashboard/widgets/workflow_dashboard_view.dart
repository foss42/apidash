import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/dashboard_models.dart';
import 'dashboard_charts.dart';
import 'dashboard_common.dart';
import 'execution_history_section.dart';

class WorkflowDashboardView extends ConsumerWidget {
  const WorkflowDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMetrics = ref.watch(workflowDashboardProvider);
    return asyncMetrics.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          DashboardEmptyState(message: 'Could not load workflow metrics', hint: '$e'),
      data: (m) {
        if (m.totalRuns == 0) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: const [
              SizedBox(
                height: 180,
                child: DashboardEmptyState(
                  message: 'No workflow runs in this range',
                  hint:
                      'Run a workflow from the Workflows pane to populate the dashboard.',
                ),
              ),
              kVSpacer10,
              ExecutionHistorySection(
                scope: ExecutionHistoryFilter.workflows,
              ),
            ],
          );
        }
        return _WorkflowBody(metrics: m);
      },
    );
  }
}

class _WorkflowBody extends ConsumerWidget {
  const _WorkflowBody({required this.metrics});
  final WorkflowDashboardMetrics metrics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _Chip(
              label: 'Last run',
              value: formatRelative(metrics.lastRunAt),
            ),
            _Chip(
              label: 'Peak duration',
              value: formatMs(metrics.peakDurationMs),
            ),
            _Chip(
              label: 'Avg nodes/run',
              value: metrics.avgStepCount.toStringAsFixed(1),
            ),
          ],
        ),
        kVSpacer16,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            DashboardKpiCard(label: 'Runs', value: '${metrics.totalRuns}'),
            DashboardKpiCard(
              label: 'Success rate',
              value: formatPct(metrics.successRate),
              valueColor: metrics.successRate < 0.7
                  ? scheme.error
                  : dashboardSuccessColor(context),
            ),
            DashboardKpiCard(
              label: 'Avg duration',
              value: formatMs(metrics.avgDurationMs),
              valueColor: scheme.tertiary,
            ),
            DashboardKpiCard(
              label: 'Failures',
              value: '${metrics.failCount}',
              valueColor:
                  metrics.failCount > 0 ? scheme.error : scheme.onSurface,
            ),
          ],
        ),
        kVSpacer16,
        DashboardSection(
          title: 'Trends & status',
          initiallyExpanded: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trend = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Run duration trend',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  kVSpacer8,
                  WorkflowDurationTrendChart(points: metrics.durationTrend),
                ],
              );
              final pie = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Run status split',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  kVSpacer8,
                  RunStatusPieChart(
                    successCount: metrics.successCount,
                    failCount: metrics.failCount,
                  ),
                ],
              );
              if (constraints.maxWidth < 860) {
                return Column(children: [trend, kVSpacer20, pie]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: trend),
                  kHSpacer20,
                  Expanded(flex: 2, child: pie),
                ],
              );
            },
          ),
        ),
        kVSpacer10,
        DashboardSection(
          title: 'Failing nodes',
          child: metrics.nodeFailures.isEmpty
              ? Text(
                  'No failed nodes in sampled runs.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                )
              : Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        for (final h in ['Node', 'Fails', 'Avg time'])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              h,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    for (final n in metrics.nodeFailures)
                      TableRow(
                        children: [
                          _td(context, n.label),
                          _td(context, '${n.failCount}', color: scheme.error),
                          _td(context, formatMs(n.avgMs)),
                        ],
                      ),
                  ],
                ),
        ),
        kVSpacer10,
        DashboardSection(
          title: 'Recent runs',
          child: _RecentRunsTable(
            rows: metrics.recentRuns,
            onOpen: (runId) async {
              ref.read(navRailIndexStateProvider.notifier).state =
                  kNavRailWorkflowsIndex;
              await openFlowHistoryInInspector(ref: ref, runId: runId);
            },
          ),
        ),
        kVSpacer10,
        const ExecutionHistorySection(
          scope: ExecutionHistoryFilter.workflows,
        ),
      ],
    );
  }
}

class _RecentRunsTable extends StatelessWidget {
  const _RecentRunsTable({required this.rows, required this.onOpen});
  final List<FlowRunRow> rows;
  final Future<void> Function(String runId) onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = DateFormat('MMM d · HH:mm:ss');
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            for (final h in ['When', 'Workflow', 'Status', 'Duration', 'Steps'])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  h,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
          ],
        ),
        for (final r in rows)
          TableRow(
            children: [
              for (final child in [
                _td(context, fmt.format(r.startedAt.toLocal())),
                _td(context, r.workflowName, maxLines: 1),
                _td(
                  context,
                  r.success ? 'Success' : 'Failed',
                  color: r.success
                      ? dashboardSuccessColor(context)
                      : scheme.error,
                ),
                _td(context, formatMs(r.durationMs)),
                _td(context, '${r.stepCount}'),
              ])
                InkWell(
                  onTap: () => onOpen(r.runId),
                  child: child,
                ),
            ],
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.55),
        borderRadius: kBorderRadius8,
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _td(
  BuildContext context,
  String text, {
  Color? color,
  int maxLines = 2,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
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
