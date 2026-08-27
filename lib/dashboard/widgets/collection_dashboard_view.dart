import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/ui_utils.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/dashboard_models.dart';
import 'dashboard_charts.dart';
import 'dashboard_common.dart';
import 'execution_history_section.dart';
import 'script_coverage_section.dart';

class CollectionDashboardView extends ConsumerWidget {
  const CollectionDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMetrics = ref.watch(collectionDashboardProvider);
    return asyncMetrics.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => DashboardEmptyState(message: 'Could not load metrics', hint: '$e'),
      data: (m) {
        if (m.total == 0) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: const [
              SizedBox(
                height: 180,
                child: DashboardEmptyState(
                  message: 'No request history in this range',
                  hint:
                      'Send requests from the Requests pane, then check back here.',
                ),
              ),
              kVSpacer10,
              ScriptCoverageSection(),
              kVSpacer10,
              ExecutionHistorySection(
                scope: ExecutionHistoryFilter.requests,
              ),
            ],
          );
        }
        return _CollectionBody(metrics: m);
      },
    );
  }
}

class _CollectionBody extends ConsumerWidget {
  const _CollectionBody({required this.metrics});
  final CollectionDashboardMetrics metrics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final filter = ref.watch(dashboardCollectionFilterProvider);
    final options = ref.watch(dashboardCollectionOptionsProvider);
    final filterName = filter == null
        ? 'All collections'
        : options
            .where((o) => o.id == filter)
            .map((o) => o.name)
            .firstOrNull ??
            filter;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _OverviewChip(label: 'Scope', value: filterName),
            _OverviewChip(
              label: 'Last run',
              value: formatRelative(metrics.lastRunAt),
            ),
            _OverviewChip(
              label: 'Avg timing',
              value: formatMs(metrics.avgMs),
            ),
            _OverviewChip(
              label: 'Peak timing',
              value: formatMs(metrics.peakMs),
            ),
            _OverviewChip(
              label: 'Error ratio',
              value: formatPct(metrics.errorRatio),
              valueColor: metrics.errorRatio > 0.2 ? scheme.error : null,
            ),
            _OverviewChip(
              label: 'Endpoints',
              value: '${metrics.uniqueEndpoints}',
            ),
          ],
        ),
        kVSpacer16,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            DashboardKpiCard(
              label: 'Health',
              value: '${metrics.healthScore}/100',
              emphasized: true,
              valueColor: healthColor(context, metrics.healthScore),
            ),
            DashboardKpiCard(label: 'Requests', value: '${metrics.total}'),
            DashboardKpiCard(
              label: 'Success rate',
              value: formatPct(metrics.successRate),
              valueColor: metrics.successRate < 0.8
                  ? Colors.orange.shade800
                  : dashboardSuccessColor(context),
            ),
            DashboardKpiCard(
              label: 'Failures',
              value: '${metrics.failCount}',
              valueColor:
                  metrics.failCount > 0 ? scheme.error : scheme.onSurface,
            ),
            DashboardKpiCard(label: '5xx', value: '${metrics.status5xx}'),
            DashboardKpiCard(
              label: 'P95 timing',
              value: formatMs(metrics.p95Ms),
            ),
          ],
        ),
        kVSpacer16,
        DashboardSection(
          title: 'Trends & health',
          initiallyExpanded: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 900;
              final trend = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Response timing trend',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  kVSpacer8,
                  TimingTrendChart(points: metrics.timingTrend),
                ],
              );
              final health = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status distribution',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  kVSpacer8,
                  StatusDistributionChart(
                    status2xx: metrics.status2xx,
                    status3xx: metrics.status3xx,
                    status4xx: metrics.status4xx,
                    status5xx: metrics.status5xx,
                  ),
                  kVSpacer16,
                  Text(
                    'Recent activity',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  kVSpacer8,
                  RunHealthGrid(buckets: metrics.recentHealth),
                ],
              );
              if (!wide) {
                return Column(children: [trend, kVSpacer20, health]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: trend),
                  kHSpacer20,
                  Expanded(flex: 2, child: health),
                ],
              );
            },
          ),
        ),
        kVSpacer10,
        DashboardSection(
          title: 'Distributions',
          initiallyExpanded: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final methods = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HTTP methods',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      kVSpacer8,
                      MethodDistributionChart(
                        methodCounts: metrics.methodCounts,
                      ),
                    ],
                  );
                  final types = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'API types',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      kVSpacer8,
                      ApiTypeDistributionChart(
                        apiTypeCounts: metrics.apiTypeCounts,
                      ),
                    ],
                  );
                  if (constraints.maxWidth < 800) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [methods, kVSpacer16, types],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: methods),
                      kHSpacer20,
                      Expanded(child: types),
                    ],
                  );
                },
              ),
              kVSpacer16,
              Text(
                'Latency percentiles',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              kVSpacer8,
              _DeepTimingStrip(metrics: metrics),
            ],
          ),
        ),
        kVSpacer10,
        DashboardSection(
          title: 'Endpoints & slowest',
          initiallyExpanded: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final top = _EndpointsTable(rows: metrics.topEndpoints);
              final slow = _SlowestTable(
                rows: metrics.slowest,
                onOpen: (id) => _openHistory(ref, id),
              );
              if (constraints.maxWidth < 900) {
                return Column(children: [top, kVSpacer16, slow]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: top),
                  kHSpacer12,
                  Expanded(child: slow),
                ],
              );
            },
          ),
        ),
        kVSpacer10,
        DashboardSection(
          title: 'Recent errors',
          child: metrics.recentErrors.isEmpty
              ? Text(
                  'No client/server errors in this range.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                )
              : _ErrorsTable(
                  rows: metrics.recentErrors,
                  onOpen: (id) => _openHistory(ref, id),
                ),
        ),
        kVSpacer10,
        const ScriptCoverageSection(),
        kVSpacer10,
        const ExecutionHistorySection(
          scope: ExecutionHistoryFilter.requests,
        ),
      ],
    );
  }

  void _openHistory(WidgetRef ref, String historyId) {
    ref.read(navRailIndexStateProvider.notifier).state = kNavRailHistoryIndex;
    ref.read(historyMetaStateNotifier.notifier).loadHistoryRequest(historyId);
  }
}

class _DeepTimingStrip extends StatelessWidget {
  const _DeepTimingStrip({required this.metrics});
  final CollectionDashboardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        DashboardKpiCard(label: 'P50', value: formatMs(metrics.p50Ms)),
        DashboardKpiCard(label: 'P95', value: formatMs(metrics.p95Ms)),
        DashboardKpiCard(label: 'P99', value: formatMs(metrics.p99Ms)),
        DashboardKpiCard(label: 'Samples', value: '${metrics.timingsMs.length}'),
      ],
    );
  }
}

class _OverviewChip extends StatelessWidget {
  const _OverviewChip({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.55),
        borderRadius: kBorderRadius8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: valueColor ?? scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _EndpointsTable extends StatelessWidget {
  const _EndpointsTable({required this.rows});
  final List<EndpointStat> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top endpoints', style: Theme.of(context).textTheme.titleSmall),
        kVSpacer8,
        if (rows.isEmpty)
          const Text('No endpoints')
        else
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              _header(context, const ['URL', 'Calls', 'Avg', 'Fails']),
              for (final r in rows)
                TableRow(
                  children: [
                    _cell(context, r.url, maxLines: 1),
                    _cell(context, '${r.count}'),
                    _cell(context, formatMs(r.avgMs)),
                    _cell(context, '${r.failCount}'),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}

class _SlowestTable extends StatelessWidget {
  const _SlowestTable({required this.rows, required this.onOpen});
  final List<TimedRequestStat> rows;
  final void Function(String historyId) onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Slowest requests', style: Theme.of(context).textTheme.titleSmall),
        kVSpacer8,
        if (rows.isEmpty)
          const Text('No timing samples')
        else
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: [
              _header(context, const ['Request', 'Status', 'Time']),
              for (final r in rows)
                TableRow(
                  children: [
                    InkWell(
                      onTap: () => onOpen(r.historyId),
                      child: _cell(
                        context,
                        r.name.isNotEmpty ? r.name : r.url,
                        maxLines: 1,
                      ),
                    ),
                    _cell(
                      context,
                      '${r.status}',
                      color: getResponseStatusCodeColor(
                        r.status,
                        brightness: Theme.of(context).brightness,
                      ),
                    ),
                    _cell(context, formatMs(r.durationMs)),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}

class _ErrorsTable extends StatelessWidget {
  const _ErrorsTable({required this.rows, required this.onOpen});
  final List<TimedRequestStat> rows;
  final void Function(String historyId) onOpen;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat.Hm();
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(2.5),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        _header(context, const ['Time', 'Method', 'URL', 'Status', 'Latency']),
        for (final r in rows)
          TableRow(
            children: [
              InkWell(
                onTap: () => onOpen(r.historyId),
                child: _cell(context, fmt.format(r.timeStamp.toLocal())),
              ),
              _cell(
                context,
                r.method.name.toUpperCase(),
                color: getHTTPMethodColor(r.method),
              ),
              _cell(context, r.url, maxLines: 1),
              _cell(
                context,
                '${r.status}',
                color: getResponseStatusCodeColor(
                  r.status,
                  brightness: Theme.of(context).brightness,
                ),
              ),
              _cell(context, formatMs(r.durationMs)),
            ],
          ),
      ],
    );
  }
}

TableRow _header(BuildContext context, List<String> cols) {
  return TableRow(
    children: [
      for (final c in cols)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            c,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
    ],
  );
}

Widget _cell(
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
