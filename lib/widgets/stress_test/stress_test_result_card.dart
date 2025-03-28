import 'package:flutter/material.dart';
import 'package:apidash/models/stress_test/stress_test_models.dart';

class StressTestResultCard extends StatelessWidget {
  final StressTestSummary summary;

  const StressTestResultCard({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDarkMode ? Colors.green[400] : Colors.green[700];
    final errorColor = isDarkMode ? Colors.red[400] : Colors.red[700];
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.grey[200];
    final textColor = isDarkMode ? Colors.grey[400] : Colors.grey[800];
    
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Total Requests',
                    '${summary.results.length}',
                    Icons.http,
                    textColor,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Total Duration',
                    '${(summary.totalDuration.inMilliseconds / 1000).toStringAsFixed(2)}s',
                    Icons.timer,
                    textColor,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    'Avg Response Time',
                    '${summary.avgResponseTime.toStringAsFixed(2)}ms',
                    Icons.speed,
                    textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    context,
                    'Success',
                    summary.successCount,
                    summary.results.length,
                    successColor!,
                  ),
                ),
                Expanded(
                  child: _buildStatusItem(
                    context,
                    'Failed',
                    summary.failureCount,
                    summary.results.length,
                    errorColor!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Response Time Distribution',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _buildResponseTimeDistribution(context, summary.results),
            const SizedBox(height: 16),
            Text(
              'Status Code Distribution',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _buildStatusCodeDistribution(context, summary.results),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color? textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String label,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0.0';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '$count',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '($percentage%)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: total > 0 ? count / total : 0,
            backgroundColor: Colors.grey[400],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildResponseTimeDistribution(BuildContext context, List<ApiRequestResult> results) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              percentile,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCodeDistribution(BuildContext context, List<ApiRequestResult> results) {
    final statusCodeCounts = <int, int>{};
    for (final result in results) {
      if (result.statusCode != -1) { // Skip errors
        statusCodeCounts[result.statusCode] = 
            (statusCodeCounts[result.statusCode] ?? 0) + 1;
      }
    }
    
    if (statusCodeCounts.isEmpty) {
      return const Text('No status codes to analyze');
    }
    
    final sortedEntries = statusCodeCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sortedEntries.map((entry) {
        final statusCode = entry.key;
        final count = entry.value;
        final isSuccess = statusCode >= 200 && statusCode < 300;
        final isRedirect = statusCode >= 300 && statusCode < 400;
        final isClientError = statusCode >= 400 && statusCode < 500;
        final isServerError = statusCode >= 500;
        
        Color chipColor;
        if (isSuccess) {
          chipColor = Colors.green;
        } else if (isRedirect) {
          chipColor = Colors.blue;
        } else if (isClientError) {
          chipColor = Colors.orange;
        } else if (isServerError) {
          chipColor = Colors.red;
        } else {
          chipColor = Colors.grey;
        }
        
        return Chip(
          label: Text('$statusCode ($count)'),
          backgroundColor: chipColor.withOpacity(0.2),
          labelStyle: TextStyle(color: chipColor),
        );
      }).toList(),
    );
  }
}
