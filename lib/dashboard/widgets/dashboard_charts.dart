import 'package:apidash/utils/ui_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'dashboard_common.dart';

class TimingTrendChart extends StatelessWidget {
  const TimingTrendChart({super.key, required this.points});

  final List<({DateTime at, int ms})> points;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (points.isEmpty) {
      return const _ChartEmpty(label: 'No timing samples yet');
    }
    final maxY = points.map((e) => e.ms).reduce((a, b) => a > b ? a : b);
    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].ms.toDouble()),
    ];
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: (maxY * 1.15).clamp(10, double.infinity),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (v) => FlLine(
              color: scheme.outlineVariant.withValues(alpha: 0.35),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: (points.length / 4).clamp(1, 20).toDouble(),
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  if (i < 0 || i >= points.length) return const SizedBox.shrink();
                  return Text(
                    '#${i + 1}',
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  formatMs(value.round()),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: _durationTouchTooltip(scheme),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 2.5,
              color: scheme.primary,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: scheme.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusDistributionChart extends StatelessWidget {
  const StatusDistributionChart({
    super.key,
    required this.status2xx,
    required this.status3xx,
    required this.status4xx,
    required this.status5xx,
  });

  final int status2xx;
  final int status3xx;
  final int status4xx;
  final int status5xx;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final groups = <(String, int, int)>[
      ('2xx', 2, status2xx),
      ('3xx', 3, status3xx),
      ('4xx', 4, status4xx),
      ('5xx', 5, status5xx),
    ];
    final maxRaw = groups.map((e) => e.$3).fold(0, (a, b) => a > b ? a : b);
    final maxY = maxRaw == 0 ? 1.0 : maxRaw * 1.2;
    final emptyFloor = maxY * 0.05;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= groups.length) {
                    return const SizedBox.shrink();
                  }
                  final empty = groups[i].$3 == 0;
                  return Padding(
                    padding: kPt8,
                    child: Text(
                      groups[i].$1,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: empty
                                ? scheme.onSurfaceVariant.withValues(alpha: 0.55)
                                : null,
                          ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < groups.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  _distributionRod(
                    count: groups[i].$3,
                    emptyFloor: emptyFloor,
                    fill: getResponseStatusCodeColor(
                      groups[i].$2 * 100,
                      brightness: brightness,
                    ),
                    emptyFill: scheme.surfaceContainerHighest,
                    emptyBorder: scheme.outlineVariant,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class MethodDistributionChart extends StatelessWidget {
  const MethodDistributionChart({super.key, required this.methodCounts});

  final Map<HTTPVerb, int> methodCounts;

  static const _tracked = <HTTPVerb>[
    HTTPVerb.get,
    HTTPVerb.post,
    HTTPVerb.put,
    HTTPVerb.patch,
    HTTPVerb.delete,
    HTTPVerb.head,
    HTTPVerb.options,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final groups = [
      for (final v in _tracked) (v, methodCounts[v] ?? 0),
    ];
    final maxRaw = groups.map((e) => e.$2).fold(0, (a, b) => a > b ? a : b);
    final maxY = maxRaw == 0 ? 1.0 : maxRaw * 1.2;
    final emptyFloor = maxY * 0.05;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= groups.length) {
                    return const SizedBox.shrink();
                  }
                  final empty = groups[i].$2 == 0;
                  return Padding(
                    padding: kPt8,
                    child: Text(
                      groups[i].$1.name.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: empty
                                ? scheme.onSurfaceVariant.withValues(alpha: 0.55)
                                : null,
                            fontSize: 10,
                          ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < groups.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  _distributionRod(
                    count: groups[i].$2,
                    emptyFloor: emptyFloor,
                    fill: getHTTPMethodColor(groups[i].$1),
                    emptyFill: scheme.surfaceContainerHighest,
                    emptyBorder: scheme.outlineVariant,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ApiTypeDistributionChart extends StatelessWidget {
  const ApiTypeDistributionChart({super.key, required this.apiTypeCounts});

  final Map<APIType, int> apiTypeCounts;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final groups = [
      for (final t in APIType.values) (t, apiTypeCounts[t] ?? 0),
    ];
    final maxRaw = groups.map((e) => e.$2).fold(0, (a, b) => a > b ? a : b);
    final maxY = maxRaw == 0 ? 1.0 : maxRaw * 1.2;
    final emptyFloor = maxY * 0.05;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= groups.length) {
                    return const SizedBox.shrink();
                  }
                  final empty = groups[i].$2 == 0;
                  return Padding(
                    padding: kPt8,
                    child: Text(
                      groups[i].$1.abbr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: empty
                                ? scheme.onSurfaceVariant.withValues(alpha: 0.55)
                                : null,
                          ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < groups.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  _distributionRod(
                    count: groups[i].$2,
                    emptyFloor: emptyFloor,
                    fill: getAPIColor(groups[i].$1, brightness: brightness),
                    emptyFill: scheme.surfaceContainerHighest,
                    emptyBorder: scheme.outlineVariant,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

BarChartRodData _distributionRod({
  required int count,
  required double emptyFloor,
  required Color fill,
  required Color emptyFill,
  required Color emptyBorder,
}) {
  final empty = count == 0;
  return BarChartRodData(
    toY: empty ? emptyFloor : count.toDouble(),
    width: 28,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
    color: empty ? emptyFill.withValues(alpha: 0.55) : fill,
    borderSide: empty
        ? BorderSide(color: emptyBorder.withValues(alpha: 0.8), width: 1)
        : BorderSide.none,
  );
}

class RunHealthGrid extends StatelessWidget {
  const RunHealthGrid({super.key, required this.buckets});

  final List<int> buckets;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (buckets.isEmpty) {
      return const _ChartEmpty(label: 'No recent activity');
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final b in buckets)
          Tooltip(
            message: switch (b) {
              2 || 3 => 'Healthy',
              4 => 'Client error',
              5 => 'Server error',
              _ => 'Other',
            },
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: kBorderRadius4,
                color: b == 0
                    ? Theme.of(context).colorScheme.outlineVariant
                    : getResponseStatusCodeColor(b * 100, brightness: brightness),
              ),
            ),
          ),
      ],
    );
  }
}

class WorkflowDurationTrendChart extends StatelessWidget {
  const WorkflowDurationTrendChart({super.key, required this.points});

  final List<({DateTime at, int ms, bool success})> points;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final successColor = dashboardSuccessColor(context);
    if (points.isEmpty) {
      return const _ChartEmpty(label: 'No workflow runs yet');
    }
    final maxY = points.map((e) => e.ms).reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: (maxY * 1.15).clamp(10, double.infinity),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (v) => FlLine(
              color: scheme.outlineVariant.withValues(alpha: 0.35),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: (points.length / 4).clamp(1, 20).toDouble(),
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  if (i < 0 || i >= points.length) return const SizedBox.shrink();
                  return Text('#${i + 1}',
                      style: Theme.of(context).textTheme.labelSmall);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  formatMs(value.round()),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: _durationTouchTooltip(scheme),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i].ms.toDouble()),
              ],
              isCurved: true,
              barWidth: 2.5,
              color: scheme.primary,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) {
                  final ok = points[index].success;
                  return FlDotCirclePainter(
                    radius: 3.5,
                    color: ok ? successColor : scheme.error,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: scheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RunStatusPieChart extends StatelessWidget {
  const RunStatusPieChart({
    super.key,
    required this.successCount,
    required this.failCount,
  });

  final int successCount;
  final int failCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final successColor = dashboardSuccessColor(context);
    final total = successCount + failCount;
    if (total == 0) {
      return const _ChartEmpty(label: 'No run status data');
    }
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: [
                if (successCount > 0)
                  PieChartSectionData(
                    value: successCount.toDouble(),
                    color: successColor,
                    title: '${((successCount / total) * 100).round()}%',
                    radius: 42,
                    titleStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                if (failCount > 0)
                  PieChartSectionData(
                    value: failCount.toDouble(),
                    color: scheme.error,
                    title: '${((failCount / total) * 100).round()}%',
                    radius: 42,
                    titleStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: scheme.onError,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
              ],
            ),
          ),
        ),
        kVSpacer8,
        Text(
          'Success $successCount  ·  Failed $failCount',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _ChartEmpty extends StatelessWidget {
  const _ChartEmpty({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

LineTouchTooltipData _durationTouchTooltip(ColorScheme scheme) {
  return LineTouchTooltipData(
    getTooltipColor: (_) => scheme.inverseSurface,
    getTooltipItems: (touched) => [
      for (final t in touched)
        LineTooltipItem(
          formatMs(t.y.round()),
          TextStyle(
            color: scheme.onInverseSurface,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
    ],
  );
}
