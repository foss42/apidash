import 'package:flutter/material.dart';
import 'package:apidash_agent/apidash_agent.dart'; // TestResult, TestStatus

class TestResultCard extends StatelessWidget {
  final TestResult result;
  const TestResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // All TestStatus cases covered — including pending
    final (icon, color, label) = switch (result.overallStatus) {
      TestStatus.passed  => (Icons.check_circle, Colors.green, 'PASSED'),
      TestStatus.failed  => (Icons.cancel, cs.error, 'FAILED'),
      TestStatus.skipped => (Icons.skip_next, Colors.grey, 'SKIPPED'),
      TestStatus.pending => (Icons.hourglass_empty, Colors.orange, 'PENDING'),
    };

    final body = result.actualBody; // String? — handle null below

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: Icon(icon, color: color, size: 20),
        title: Text(
          result.testCase.description,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '$label  •  ${result.durationMs}ms  •  HTTP ${result.actualStatusCode}',
          style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text('Assertions',
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                ...result.assertionResults.map((ar) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          ar.passed ? Icons.check : Icons.close,
                          size: 14,
                          color: ar.passed ? Colors.green : cs.error,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(ar.message,
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  );
                }),
                // Only show body section if it is non-null and non-empty
                if (body != null && body.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Response Body',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      body.length > 300
                          ? '${body.substring(0, 300)}...'
                          : body,
                      style: const TextStyle(
                          fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}