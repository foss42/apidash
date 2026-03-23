import 'package:flutter/material.dart';

import '../models/test_case_model.dart';

class TestReviewCard extends StatelessWidget {
  const TestReviewCard({
    super.key,
    required this.testCase,
    this.onApprove,
    this.onReject,
  });

  final AgenticTestCase testCase;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final decisionColor = switch (testCase.decision) {
      TestReviewDecision.pending => colorScheme.outline,
      TestReviewDecision.approved => Colors.green,
      TestReviewDecision.rejected => Colors.red,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    testCase.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                if (testCase.confidence != null)
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      '${(testCase.confidence! * 100).toStringAsFixed(0)}%',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(testCase.method),
                ),
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(testCase.endpoint),
                ),
                Chip(
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: decisionColor),
                  label: Text(testCase.decision.label),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(testCase.description),
            const SizedBox(height: 8),
            Text(
              'Expected Outcome',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(testCase.expectedOutcome),
            if (testCase.assertions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Assertions',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              ...testCase.assertions.map(
                (assertion) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('- $assertion'),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Reject'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Approve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

