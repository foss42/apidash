import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/performance_test_result.dart';

class PerformanceTestChart extends StatelessWidget {
  final List<PerformanceTestResult> results;

  const PerformanceTestChart({
    Key? key,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= results.length) return const Text('');
                      return Text(
                        '${results[value.toInt()].timestamp.second}s',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                // Requests per second
                LineChartBarData(
                  spots: List.generate(
                    results.length,
                    (index) => FlSpot(
                      index.toDouble(),
                      results[index].requestsPerSecond,
                    ),
                  ),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
                // Average response time
                LineChartBarData(
                  spots: List.generate(
                    results.length,
                    (index) => FlSpot(
                      index.toDouble(),
                      results[index].avgResponseTime,
                    ),
                  ),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
                // Error rate
                LineChartBarData(
                  spots: List.generate(
                    results.length,
                    (index) => FlSpot(
                      index.toDouble(),
                      results[index].errorRate,
                    ),
                  ),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(color: Colors.blue, label: 'Requests/s'),
            const SizedBox(width: 16),
            _LegendItem(color: Colors.green, label: 'Avg Response Time (ms)'),
            const SizedBox(width: 16),
            _LegendItem(color: Colors.red, label: 'Error Rate (%)'),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 4,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
} 