import 'package:flutter/material.dart';
import 'package:api_testing_suite/src/stress_test/models/api_request_result.dart';

class ResultCardStatusCodes extends StatelessWidget {
  final List<ApiRequestResult> results;
  const ResultCardStatusCodes({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusCodeCounts = <int, int>{};
    for (final result in results) {
      if (result.statusCode != -1) {
        statusCodeCounts[result.statusCode] =
            (statusCodeCounts[result.statusCode] ?? 0) + 1;
      }
    }
    if (statusCodeCounts.isEmpty) {
      return const Text('No status codes to analyze');
    }
    final sortedEntries = statusCodeCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
          return Tooltip(
            message: 'Status $statusCode: $count responses',
            child: Semantics(
              label: 'HTTP status $statusCode, $count responses',
              child: Chip(
                label: Text('$statusCode ($count)'),
                backgroundColor: chipColor.withAlpha(isDarkMode ? 80 : 51),
                labelStyle: TextStyle(
                  color: chipColor.computeLuminance() < 0.5
                      ? Colors.white
                      : chipColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
