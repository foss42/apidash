import 'package:api_testing_suite/src/stress_test/models/stress_test_models.dart';
import 'package:flutter/material.dart';
import 'package:api_testing_suite/src/stress_test/widgets/result_card_summary.dart';
import 'package:api_testing_suite/src/stress_test/widgets/result_card_status.dart';
import 'package:api_testing_suite/src/stress_test/widgets/result_card_percentiles.dart';
import 'package:api_testing_suite/src/stress_test/widgets/result_card_status_codes.dart';

class StressTestResultCard extends StatelessWidget {
  final StressTestSummary summary;

  const StressTestResultCard({super.key, required this.summary});

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
            ResultCardSummary(
              totalRequests: summary.results.length,
              totalDuration: summary.totalDuration.inMilliseconds / 1000,
              avgResponseTime: summary.avgResponseTime,
              textColor: textColor!,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ResultCardStatus(
                    label: 'Success',
                    count: summary.successCount,
                    total: summary.results.length,
                    color: successColor!,
                  ),
                ),
                Expanded(
                  child: ResultCardStatus(
                    label: 'Failed',
                    count: summary.failureCount,
                    total: summary.results.length,
                    color: errorColor!,
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
            ResultCardPercentiles(results: summary.results),
            const SizedBox(height: 16),
            Text(
              'Status Code Distribution',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ResultCardStatusCodes(results: summary.results),
          ],
        ),
      ),
    );
  }
}
