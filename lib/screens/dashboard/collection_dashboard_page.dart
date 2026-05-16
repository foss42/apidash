import 'dart:async';
import 'dart:convert';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CollectionDashboardPage extends ConsumerStatefulWidget {
  const CollectionDashboardPage({super.key});

  @override
  ConsumerState<CollectionDashboardPage> createState() =>
      _CollectionDashboardPageState();
}

class _CollectionDashboardPageState extends ConsumerState<CollectionDashboardPage> {
  String? _collectionA;
  final TextEditingController _webhookUrlController = TextEditingController();
  final TextEditingController _reportNameController =
      TextEditingController(text: 'Collection Health Report');
  Timer? _reportTimer;
  int _autoReportMinutes = 15;
  String? _reportStatus;
  DateTime? _lastReportSentAt;

  @override
  void dispose() {
    _reportTimer?.cancel();
    _webhookUrlController.dispose();
    _reportNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final collections = ref.watch(collectionsStateProvider);
    final history = ref.watch(historyMetaStateNotifier) ?? const {};

    final ids = collections.keys.toList(growable: false);
    if (ids.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No collections available')),
      );
    }
    _collectionA ??= ids.first;

    final dataA = _buildCollectionData(
      collectionId: _collectionA!,
      collections: collections,
      history: history,
    );
    final overallHealth = ((dataA.successRate * 100) * 0.75) +
        ((100 - (dataA.errorRatio * 100)) * 0.25);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    kLabelDashboard,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () => _openWebhookDialog(context, dataA),
                    icon: const Icon(Icons.hub_outlined),
                    label: const Text('Webhook Reports'),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 260,
                    child: DropdownButtonFormField<String>(
                      value: _collectionA,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Collection',
                        isDense: true,
                      ),
                      items: ids
                          .map(
                            (id) => DropdownMenuItem(
                              value: id,
                              child: Text(collections[id]!.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _collectionA = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _overviewStrip(context, dataA),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _kpiCard(
                      context,
                      'Health Score',
                      '${overallHealth.clamp(0, 100).round()}/100',
                      color: overallHealth >= 80
                          ? const Color(0xFF5DE5C3)
                          : overallHealth >= 60
                              ? const Color(0xFFFFB156)
                              : const Color(0xFFFF587A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _kpiCard(context, 'Requests', '${dataA.totalRequests}')),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _kpiCard(
                      context,
                      'Success Rate',
                      dataA.successLabel,
                      color: dataA.successRate >= 0.8
                          ? const Color(0xFF5DE5C3)
                          : const Color(0xFFFFB156),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _kpiCard(
                      context,
                      'Failures',
                      '${dataA.failures}',
                      color: const Color(0xFFFF587A),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _kpiCard(
                      context,
                      '5xx Errors',
                      '${dataA.statusBuckets['5xx'] ?? 0}',
                      color: const Color(0xFFFF587A),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _kpiCard(context, 'Timing*', '${dataA.p95Ms}ms')),
                ],
              ),
              // const SizedBox(height: 6),
              // Text(
              //   '*Timing is mock-derived for now; request/history coverage in memory lacks response duration.',
              //   style: theme.textTheme.bodySmall?.copyWith(
              //     color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              //   ),
              // ),
              const SizedBox(height: 12),
              _expandableCard(
                context,
                title: 'Trends & Health',
                initiallyExpanded: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _card(
                        context,
                        title: 'Response Timing Trend (${dataA.name})',
                        child: SizedBox(
                          height: 230,
                          child: _timingLineChart(context, dataA.mockTimingsMs),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _card(
                        context,
                        title: 'Run Health (${dataA.name})',
                        child: SizedBox(
                          height: 230,
                          child: _healthPanel(context, dataA),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _expandableCard(
                context,
                title: 'Distributions',
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _card(
                        context,
                        title: 'Method Distribution (${dataA.name})',
                        child: SizedBox(
                          height: 220,
                          child: _methodBarChart(context, dataA),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: _card(
                        context,
                        title: 'Status Distribution (${dataA.name})',
                        child: SizedBox(
                          height: 220,
                          child: _statusBarChart(context, dataA),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _expandableCard(
                context,
                title: 'Request Tables',
                initiallyExpanded: false,
                child: Column(
                  children: [
                    _card(
                      context,
                      title: 'Top Endpoints (${dataA.name})',
                      child: _topEndpoints(context, dataA),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      context,
                      title: 'Slowest Requests (${dataA.name})',
                      child: _slowestTable(context, dataA.slowestRows),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      context,
                      title:
                          'Recent Requests (${dataA.name}) · ${dataA.statusBuckets['5xx'] ?? 0} server (5xx)',
                      child: _requestTable(context, _recentRowsWith5xxFirst(dataA.recentRows)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overviewStrip(BuildContext context, _CollectionData data) {
    final theme = Theme.of(context);
    Widget chip(String label, String value, {Color? valueColor}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: ',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip('Collection', data.name),
        chip('Last Run', data.lastRunLabel),
        chip('Avg Timing*', '${data.avgMs}ms'),
        chip('Peak Timing*', '${data.maxMs}ms'),
        chip('Error Ratio', data.errorRatioLabel, valueColor: const Color(0xFFFFB156)),
        chip('Total Unique Endpoints', '${data.topEndpoints.length}'),
      ],
    );
  }

  Widget _kpiCard(
    BuildContext context,
    String title,
    String value, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _expandableCard(
    BuildContext context, {
    required String title,
    required Widget child,
    bool initiallyExpanded = false,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: [child],
      ),
    );
  }

  Widget _timingLineChart(BuildContext context, List<int> timings) {
    final theme = Theme.of(context);
    final spots = <FlSpot>[
      for (var i = 0; i < timings.length; i++) FlSpot(i.toDouble(), timings[i].toDouble()),
    ];
    return LineChart(
      LineChartData(
        minY: 0,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2.6,
            color: theme.colorScheme.primary,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
          getDrawingHorizontalLine: (_) => FlLine(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                '#${value.toInt() + 1}',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _statusBarChart(BuildContext context, _CollectionData data) {
    final theme = Theme.of(context);
    final entries = data.statusBuckets.entries.toList(growable: false);
    final bars = [
      for (var i = 0; i < entries.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: entries[i].value.toDouble(),
              color: switch (entries[i].key) {
                '2xx' => theme.colorScheme.primary,
                '3xx' => theme.colorScheme.primary.withValues(alpha: 0.75),
                '4xx' => const Color(0xFFFFB156),
                _ => const Color(0xFFFF587A),
              },
              width: 26,
            ),
          ],
        ),
    ];

    return BarChart(
      BarChartData(
        barGroups: bars,
        groupsSpace: 24,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (v, m) => Text(
                v.toInt().toString(),
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, m) {
                final labels = entries.map((e) => e.key).toList(growable: false);
                final idx = v.toInt();
                if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                return Text(
                  labels[idx],
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _methodBarChart(BuildContext context, _CollectionData data) {
    final theme = Theme.of(context);
    final entries = data.methodBuckets.entries.toList(growable: false);
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No request methods yet',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }
    return BarChart(
      BarChartData(
        barGroups: [
          for (var i = 0; i < entries.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: entries[i].value.toDouble(),
                  color: theme.colorScheme.primary,
                  width: 24,
                ),
              ],
            ),
        ],
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (v, m) => Text(
                v.toInt().toString(),
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, m) {
                final idx = v.toInt();
                if (idx < 0 || idx >= entries.length) return const SizedBox.shrink();
                return Text(
                  entries[idx].key,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _topEndpoints(BuildContext context, _CollectionData data) {
    final theme = Theme.of(context);
    if (data.topEndpoints.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'No endpoints in history yet.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }
    return Column(
      children: data.topEndpoints
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      e.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${e.$2} calls',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _healthPanel(BuildContext context, _CollectionData data) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _healthMetric(
          context,
          'Healthy (2xx/3xx)',
          '${data.healthyCount}',
          theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        _healthMetric(
          context,
          'Client Errors (4xx)',
          '${data.statusBuckets['4xx'] ?? 0}',
          const Color(0xFFFFB156),
        ),
        const SizedBox(height: 8),
        _healthMetric(
          context,
          'Server Errors (5xx)',
          '${data.statusBuckets['5xx'] ?? 0}',
          const Color(0xFFFF587A),
        ),
        const SizedBox(height: 12),
        Text(
          'Recent Activity',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: data.recentRows.take(20).map((row) {
            final color = row.status >= 500
                ? const Color(0xFFFF587A)
                : row.status >= 400
                    ? const Color(0xFFFFB156)
                    : theme.colorScheme.primary;
            return Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }).toList(growable: false),
        ),
      ],
    );
  }

  Widget _healthMetric(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Surfaces 5xx rows at the top of the recent table without a separate card.
  List<_RecentRow> _recentRowsWith5xxFirst(List<_RecentRow> rows) {
    final fivexx = <_RecentRow>[];
    final other = <_RecentRow>[];
    for (final r in rows) {
      if (r.status >= 500) {
        fivexx.add(r);
      } else {
        other.add(r);
      }
    }
    return [...fivexx, ...other];
  }

  Widget _requestTable(BuildContext context, List<_RecentRow> rows) {
    final theme = Theme.of(context);
    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'No request history for selected collection.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(1.4),
        3: FlexColumnWidth(1.2),
      },
      children: [
        _trHeader(context, 'Method', 'Endpoint', 'Status', 'Timing*'),
        ...rows.take(8).map((r) => _trData(context, r)),
      ],
    );
  }

  TableRow _trHeader(
    BuildContext context,
    String c1,
    String c2,
    String c3,
    String c4,
  ) {
    final theme = Theme.of(context);
    Text style(String v) => Text(
          v.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        );
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(6), child: style(c1)),
        Padding(padding: const EdgeInsets.all(6), child: style(c2)),
        Padding(padding: const EdgeInsets.all(6), child: style(c3)),
        Padding(padding: const EdgeInsets.all(6), child: style(c4)),
      ],
    );
  }

  TableRow _trData(BuildContext context, _RecentRow row) {
    final theme = Theme.of(context);
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            row.method.toUpperCase(),
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            row.endpoint,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            row.status >= 500 ? '${row.status} (5xx)' : '${row.status}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: row.status >= 200 && row.status < 300
                  ? theme.colorScheme.primary
                  : row.status >= 500
                      ? const Color(0xFFFF587A)
                      : const Color(0xFFFFB156),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            '${row.mockLatencyMs}ms',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _slowestTable(BuildContext context, List<_RecentRow> rows) {
    final theme = Theme.of(context);
    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'No slow request data yet.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.4),
      },
      children: [
        _trHeader(context, 'Method', 'Endpoint', 'Status', 'Latency*'),
        ...rows.take(6).map((r) => _trData(context, r)),
      ],
    );
  }

  Widget _reportWebhookPanel(
    BuildContext context,
    _CollectionData requestData,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _webhookUrlController,
                decoration: const InputDecoration(
                  labelText: 'Webhook URL',
                  hintText: 'https://example.com/incoming',
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _reportNameController,
                decoration: const InputDecoration(
                  labelText: 'Report Name',
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<int>(
                value: _autoReportMinutes,
                isDense: true,
                decoration: const InputDecoration(
                  labelText: 'Auto-send interval',
                ),
                items: const [5, 15, 30, 60]
                    .map(
                      (m) => DropdownMenuItem<int>(
                        value: m,
                        child: Text('Every $m min'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _autoReportMinutes = value);
                  if (_reportTimer != null) {
                    _startAutoReports(requestData);
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              onPressed: () => _sendWebhookReport(requestData),
              icon: const Icon(Icons.send_rounded),
              label: const Text('Send now'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _reportTimer == null
                  ? () => _startAutoReports(requestData)
                  : _stopAutoReports,
              icon: Icon(_reportTimer == null ? Icons.play_arrow_rounded : Icons.stop_rounded),
              label: Text(_reportTimer == null ? 'Start auto-send' : 'Stop auto-send'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_lastReportSentAt != null)
          Text(
            'Last report sent: ${_relativeTimeLabel(_lastReportSentAt!)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        if (_reportStatus != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _reportStatus!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _reportStatus!.toLowerCase().contains('failed')
                    ? const Color(0xFFFF587A)
                    : theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _sendWebhookReport(
    _CollectionData requestData,
  ) async {
    final url = _webhookUrlController.text.trim();
    if (url.isEmpty) {
      setState(() => _reportStatus = 'Failed: webhook URL is required.');
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      setState(() => _reportStatus = 'Failed: webhook URL must be valid http/https.');
      return;
    }
    final payload = {
      'reportName': _reportNameController.text.trim().isEmpty
          ? 'Collection Health Report'
          : _reportNameController.text.trim(),
      'generatedAt': DateTime.now().toIso8601String(),
      'collection': {
        'name': requestData.name,
        'totalRequests': requestData.totalRequests,
        'successRate': requestData.successRate,
        'failures': requestData.failures,
        'p95Ms': requestData.p95Ms,
      },
      'health': {
        'errorRatio': requestData.errorRatio,
        'healthScore': (((requestData.successRate * 100) * 0.75) +
                ((100 - (requestData.errorRatio * 100)) * 0.25))
            .clamp(0, 100),
      },
    };
    try {
      final resp = await http.post(
        uri,
        headers: const {'content-type': 'application/json'},
        body: jsonEncode(payload),
      );
      setState(() {
        _lastReportSentAt = DateTime.now();
        _reportStatus = resp.statusCode >= 200 && resp.statusCode < 300
            ? 'Report sent successfully (${resp.statusCode}).'
            : 'Failed: webhook responded ${resp.statusCode}.';
      });
    } catch (e) {
      setState(() => _reportStatus = 'Failed: $e');
    }
  }

  void _startAutoReports(
    _CollectionData requestData,
  ) {
    _reportTimer?.cancel();
    _reportTimer = Timer.periodic(
      Duration(minutes: _autoReportMinutes),
      (_) => _sendWebhookReport(requestData),
    );
    setState(() {
      _reportStatus = 'Auto-send started (every $_autoReportMinutes minutes).';
    });
  }

  void _stopAutoReports() {
    _reportTimer?.cancel();
    _reportTimer = null;
    setState(() => _reportStatus = 'Auto-send stopped.');
  }

  Future<void> _openWebhookDialog(
    BuildContext context,
    _CollectionData requestData,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Collection Webhook Reports'),
          content: SizedBox(
            width: 720,
            child: _reportWebhookPanel(context, requestData),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _CollectionData {
  const _CollectionData({
    required this.name,
    required this.totalRequests,
    required this.successCount,
    required this.failures,
    required this.successRate,
    required this.p95Ms,
    required this.mockTimingsMs,
    required this.recentRows,
    required this.statusBuckets,
    required this.methodBuckets,
    required this.topEndpoints,
    required this.avgMs,
    required this.maxMs,
    required this.healthyCount,
    required this.lastRunLabel,
    required this.slowestRows,
    required this.isDemoData,
  });

  final String name;
  final int totalRequests;
  final int successCount;
  final int failures;
  final double successRate;
  final int p95Ms;
  final List<int> mockTimingsMs;
  final List<_RecentRow> recentRows;
  final Map<String, int> statusBuckets;
  final Map<String, int> methodBuckets;
  final List<(String, int)> topEndpoints;
  final int avgMs;
  final int maxMs;
  final int healthyCount;
  final String lastRunLabel;
  final List<_RecentRow> slowestRows;
  final bool isDemoData;

  String get successLabel => totalRequests == 0
      ? '—'
      : '${(successRate * 100).toStringAsFixed(1)}%';
  double get errorRatio => totalRequests == 0 ? 0 : failures / totalRequests;
  String get errorRatioLabel => totalRequests == 0
      ? '—'
      : '${((failures / totalRequests) * 100).toStringAsFixed(1)}%';
}

class _RecentRow {
  const _RecentRow({
    required this.method,
    required this.endpoint,
    required this.status,
    required this.mockLatencyMs,
  });

  final String method;
  final String endpoint;
  final int status;
  final int mockLatencyMs;
}

_CollectionData _buildCollectionData({
  required String collectionId,
  required Map<String, CollectionModel> collections,
  required Map<String, HistoryMetaModel> history,
}) {
  final collection = collections[collectionId];
  if (collection == null) {
    return const _CollectionData(
      name: 'Unknown',
      totalRequests: 0,
      successCount: 0,
      failures: 0,
      successRate: 0,
      p95Ms: 0,
      mockTimingsMs: <int>[],
      recentRows: <_RecentRow>[],
      statusBuckets: const {'2xx': 0, '3xx': 0, '4xx': 0, '5xx': 0},
      methodBuckets: const {},
      topEndpoints: const [],
      avgMs: 0,
      maxMs: 0,
      healthyCount: 0,
      lastRunLabel: 'Never',
      slowestRows: const [],
      isDemoData: false,
    );
  }

  final requestSet = collection.requestIds.toSet();
  final filtered = history.values
      .where((h) => requestSet.contains(h.requestId))
      .toList()
    ..sort((a, b) => b.timeStamp.compareTo(a.timeStamp));

  final total = filtered.length;
  final success = filtered.where((h) => h.responseStatus >= 200 && h.responseStatus < 300).length;
  final failures = filtered.where((h) => h.responseStatus >= 400).length;
  final rate = total == 0 ? 0.0 : success / total;

  final timings = <int>[
    for (var i = 0; i < filtered.length; i++) _mockLatencyMs(filtered[i], i),
  ];
  final p95 = timings.isEmpty
      ? 0
      : (timings..sort()).elementAt(((timings.length - 1) * 0.95).floor());

  final rows = filtered
      .take(12)
      .toList(growable: false)
      .asMap()
      .entries
      .map(
        (e) => _RecentRow(
          method: e.value.method.name,
          endpoint: e.value.name.isNotEmpty ? e.value.name : e.value.url,
          status: e.value.responseStatus,
          mockLatencyMs: _mockLatencyMs(e.value, e.key),
        ),
      )
      .toList(growable: false);
  final slowestRows = rows.toList()..sort((a, b) => b.mockLatencyMs.compareTo(a.mockLatencyMs));

  final statusBuckets = <String, int>{'2xx': 0, '3xx': 0, '4xx': 0, '5xx': 0};
  final methodBuckets = <String, int>{};
  final endpointBuckets = <String, int>{};
  for (final item in filtered) {
    if (item.responseStatus >= 200 && item.responseStatus < 300) {
      statusBuckets['2xx'] = (statusBuckets['2xx'] ?? 0) + 1;
    } else if (item.responseStatus >= 300 && item.responseStatus < 400) {
      statusBuckets['3xx'] = (statusBuckets['3xx'] ?? 0) + 1;
    } else if (item.responseStatus >= 400 && item.responseStatus < 500) {
      statusBuckets['4xx'] = (statusBuckets['4xx'] ?? 0) + 1;
    } else if (item.responseStatus >= 500) {
      statusBuckets['5xx'] = (statusBuckets['5xx'] ?? 0) + 1;
    }
    final method = item.method.name.toUpperCase();
    methodBuckets[method] = (methodBuckets[method] ?? 0) + 1;
    final endpoint = item.name.isNotEmpty ? item.name : item.url;
    endpointBuckets[endpoint] = (endpointBuckets[endpoint] ?? 0) + 1;
  }
  final topEndpoints = endpointBuckets.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final avg = timings.isEmpty ? 0 : (timings.reduce((a, b) => a + b) / timings.length).round();
  final max = timings.isEmpty ? 0 : timings.reduce((a, b) => a > b ? a : b);
  final healthy = (statusBuckets['2xx'] ?? 0) + (statusBuckets['3xx'] ?? 0);
  final lastRun = filtered.isEmpty
      ? 'Never'
      : _relativeTimeLabel(filtered.first.timeStamp.toLocal());

  final built = _CollectionData(
    name: collection.name,
    totalRequests: total,
    successCount: success,
    failures: failures,
    successRate: rate,
    p95Ms: p95,
    mockTimingsMs: timings.take(24).toList(growable: false),
    recentRows: rows,
    statusBuckets: statusBuckets,
    methodBuckets: methodBuckets,
    topEndpoints: topEndpoints.take(8).map((e) => (e.key, e.value)).toList(),
    avgMs: avg,
    maxMs: max,
    healthyCount: healthy,
    lastRunLabel: lastRun,
    slowestRows: slowestRows.take(8).toList(growable: false),
    isDemoData: false,
  );
  return built;
}

int _mockLatencyMs(HistoryMetaModel h, int index) {
  final methodWeight = switch (h.method.name.toUpperCase()) {
    'GET' => 0,
    'POST' => 30,
    'PUT' => 45,
    'PATCH' => 50,
    'DELETE' => 25,
    _ => 20,
  };
  final base = 55 + (h.requestId.hashCode.abs() % 190) + methodWeight;
  final penalty = h.responseStatus >= 500
      ? 420
      : h.responseStatus >= 400
          ? 180
          : 0;
  final waveform = ((index * 17) % 7) * 9;
  final burst = index % 9 == 0 ? 95 : 0;
  return base + penalty + waveform + burst;
}

String _relativeTimeLabel(DateTime ts) {
  final now = DateTime.now();
  final diff = now.difference(ts);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${(diff.inDays / 7).floor()}w ago';
}