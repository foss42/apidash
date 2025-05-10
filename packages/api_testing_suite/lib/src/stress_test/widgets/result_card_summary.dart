import 'package:flutter/material.dart';

class ResultCardSummary extends StatelessWidget {
  final int totalRequests;
  final double totalDuration;
  final double avgResponseTime;
  final Color textColor;
  const ResultCardSummary({
    super.key,
    required this.totalRequests,
    required this.totalDuration,
    required this.avgResponseTime,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem(
            context,
            'Total Requests',
            '$totalRequests',
            Icons.http,
            textColor,
          ),
        ),
        Expanded(
          child: _buildSummaryItem(
            context,
            'Total Duration',
            '${totalDuration.toStringAsFixed(2)}s',
            Icons.timer,
            textColor,
          ),
        ),
        Expanded(
          child: _buildSummaryItem(
            context,
            'Avg Response Time',
            '${avgResponseTime.toStringAsFixed(2)}ms',
            Icons.speed,
            textColor,
          ),
        ),
      ],
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
}
