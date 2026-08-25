import 'package:apidash/utils/ui_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'dashboard_common.dart';

const _kChartHeight = 220.0;
const _kBottomTitleSize = 28.0;
const _kLeftTitleSize = 46.0;

FlBorderData _chartBorder(ColorScheme scheme) => FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: scheme.outlineVariant, width: 1),
        left: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
    );

FlGridData _chartGrid(ColorScheme scheme) => FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (v) => FlLine(
        color: scheme.outlineVariant.withValues(alpha: 0.28),
        strokeWidth: 1,
      ),
    );

Widget _bottomIndexTitle(
  BuildContext context,
  double value,
  TitleMeta meta,
  int count,
) {
  if (value != value.roundToDouble()) return const SizedBox.shrink();
  final i = value.toInt();
  if (i < 0 || i >= count) return const SizedBox.shrink();
  final step = (count / 5).ceil().clamp(1, count);
  if (i != 0 && i != count - 1 && i % step != 0) {
    return const SizedBox.shrink();
  }
  return SideTitleWidget(
    meta: meta,
    space: 6,
    child: Text(
      '#${i + 1}',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    ),
  );
}

Widget _leftMsTitle(BuildContext context, double value, TitleMeta meta) {
  if (value < 0) return const SizedBox.shrink();
  return SideTitleWidget(
    meta: meta,
    space: 6,
    child: Text(
      formatMs(value.round()),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    ),
  );
}

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
      height: _kChartHeight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8, top: 8),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (points.length - 1).clamp(0, 1 << 20).toDouble(),
            minY: 0,
            maxY: (maxY * 1.2).clamp(10, double.infinity),
            clipData: const FlClipData.all(),
            gridData: _chartGrid(scheme),
            borderData: _chartBorder(scheme),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: _kBottomTitleSize,
                  interval: 1,
                  getTitlesWidget: (value, meta) =>
                      _bottomIndexTitle(context, value, meta, points.length),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: _kLeftTitleSize,
                  getTitlesWidget: (value, meta) =>
                      _leftMsTitle(context, value, meta),
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
                curveSmoothness: 0.2,
                preventCurveOverShooting: true,
                preventCurveOvershootingThreshold: 0.5,
                isStrokeCapRound: true,
                barWidth: 2.5,
                color: scheme.primary,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: scheme.primary.withValues(alpha: 0.1),
                  cutOffY: 0,
                  applyCutOffY: true,
                ),
              ),
            ],
          ),
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
    return _DistributionBarChart(
      labels: [for (final g in groups) g.$1],
      counts: [for (final g in groups) g.$3],
      colors: [
        for (final g in groups)
          getResponseStatusCodeColor(g.$2 * 100, brightness: brightness),
      ],
      scheme: scheme,
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
    return _DistributionBarChart(
      labels: [for (final v in _tracked) v.name.toUpperCase()],
      counts: [for (final v in _tracked) methodCounts[v] ?? 0],
      colors: [for (final v in _tracked) getHTTPMethodColor(v)],
      scheme: scheme,
      barWidth: 20,
      compactLabels: true,
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
    final types = APIType.values;
    return _DistributionBarChart(
      labels: [for (final t in types) t.abbr],
      counts: [for (final t in types) apiTypeCounts[t] ?? 0],
      colors: [for (final t in types) getAPIColor(t, brightness: brightness)],
      scheme: scheme,
    );
  }
}

class _DistributionBarChart extends StatelessWidget {
  const _DistributionBarChart({
    required this.labels,
    required this.counts,
    required this.colors,
    required this.scheme,
    this.barWidth = 26,
    this.compactLabels = false,
  });

  final List<String> labels;
  final List<int> counts;
  final List<Color> colors;
  final ColorScheme scheme;
  final double barWidth;
  final bool compactLabels;

  @override
  Widget build(BuildContext context) {
    final maxRaw = counts.fold(0, (a, b) => a > b ? a : b);
    final maxY = maxRaw == 0 ? 1.0 : maxRaw * 1.25;
    final emptyFloor = (maxY * 0.06).clamp(0.04, maxY);

    return SizedBox(
      height: _kChartHeight,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 4),
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: maxY,
            alignment: BarChartAlignment.spaceAround,
            groupsSpace: 10,
            gridData: _chartGrid(scheme),
            borderData: _chartBorder(scheme),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    if (value != value.roundToDouble() || value < 0) {
                      return const SizedBox.shrink();
                    }
                    if (maxRaw > 0 && value > maxRaw) {
                      return const SizedBox.shrink();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      space: 4,
                      child: Text(
                        value.round().toString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: _kBottomTitleSize,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (value != value.roundToDouble() ||
                        i < 0 ||
                        i >= labels.length) {
                      return const SizedBox.shrink();
                    }
                    final empty = counts[i] == 0;
                    return SideTitleWidget(
                      meta: meta,
                      space: 6,
                      child: Text(
                        labels[i],
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: empty
                                  ? scheme.onSurfaceVariant
                                      .withValues(alpha: 0.5)
                                  : scheme.onSurfaceVariant,
                              fontSize: compactLabels ? 9 : 11,
                              fontWeight:
                                  empty ? FontWeight.w400 : FontWeight.w600,
                            ),
                      ),
                    );
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => scheme.primary,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  if (groupIndex < 0 || groupIndex >= counts.length) {
                    return null;
                  }
                  return BarTooltipItem(
                    '${counts[groupIndex]}',
                    TextStyle(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  );
                },
              ),
            ),
            barGroups: [
              for (var i = 0; i < counts.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: counts[i] == 0 ? emptyFloor : counts[i].toDouble(),
                      width: barWidth,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                      color: counts[i] == 0
                          ? scheme.surfaceContainerHighest
                              .withValues(alpha: 0.65)
                          : colors[i],
                      borderSide: counts[i] == 0
                          ? BorderSide(
                              color:
                                  scheme.outlineVariant.withValues(alpha: 0.9),
                            )
                          : BorderSide.none,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
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
                    : getResponseStatusCodeColor(
                        b * 100,
                        brightness: brightness,
                      ),
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
      height: _kChartHeight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8, top: 8),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (points.length - 1).clamp(0, 1 << 20).toDouble(),
            minY: 0,
            maxY: (maxY * 1.2).clamp(10, double.infinity),
            clipData: const FlClipData.all(),
            gridData: _chartGrid(scheme),
            borderData: _chartBorder(scheme),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: _kBottomTitleSize,
                  interval: 1,
                  getTitlesWidget: (value, meta) =>
                      _bottomIndexTitle(context, value, meta, points.length),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: _kLeftTitleSize,
                  getTitlesWidget: (value, meta) =>
                      _leftMsTitle(context, value, meta),
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
                curveSmoothness: 0.2,
                preventCurveOverShooting: true,
                preventCurveOvershootingThreshold: 0.5,
                isStrokeCapRound: true,
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
                  cutOffY: 0,
                  applyCutOffY: true,
                ),
              ),
            ],
          ),
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
                    titleStyle:
                        Theme.of(context).textTheme.labelMedium?.copyWith(
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
                    titleStyle:
                        Theme.of(context).textTheme.labelMedium?.copyWith(
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    getTooltipColor: (_) => scheme.primary,
    getTooltipItems: (touched) => [
      for (final t in touched)
        LineTooltipItem(
          formatMs(t.y.round()),
          TextStyle(
            color: scheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
    ],
  );
}
