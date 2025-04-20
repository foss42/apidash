import 'package:flutter/material.dart';
import 'package:api_testing_suite/src/stress_test/models/api_request_result.dart';

class ResultCardPercentiles extends StatelessWidget {
  final List<ApiRequestResult> results;
  const ResultCardPercentiles({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final successfulResults = results.where((r) => r.error == null).toList();
    if (successfulResults.isEmpty) {
      return const Text('No successful responses to analyze');
    }
    successfulResults.sort((a, b) => a.duration.compareTo(b.duration));
    final p50Index = (successfulResults.length * 0.5).floor();
    final p75Index = (successfulResults.length * 0.75).floor();
    final p90Index = (successfulResults.length * 0.9).floor();
    final p95Index = (successfulResults.length * 0.95).floor();
    final p99Index = (successfulResults.length * 0.99).floor();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _buildPercentileRow(context, 'Min',
              '${successfulResults.first.duration.inMilliseconds} ms'),
          _buildPercentileRow(context, 'P50',
              '${successfulResults[p50Index].duration.inMilliseconds} ms'),
          _buildPercentileRow(context, 'P75',
              '${successfulResults[p75Index].duration.inMilliseconds} ms'),
          _buildPercentileRow(context, 'P90',
              '${successfulResults[p90Index].duration.inMilliseconds} ms'),
          _buildPercentileRow(context, 'P95',
              '${successfulResults[p95Index].duration.inMilliseconds} ms'),
          _buildPercentileRow(context, 'P99',
              '${successfulResults[p99Index].duration.inMilliseconds} ms'),
          _buildPercentileRow(context, 'Max',
              '${successfulResults.last.duration.inMilliseconds} ms'),
        ],
      ),
    );
  }

  Widget _buildPercentileRow(BuildContext context, String percentile, String value) {
    return Tooltip(
      message: '$percentile percentile response time',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(percentile, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
