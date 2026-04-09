import 'package:flutter/material.dart';
import 'package:apidash_agent/apidash_agent.dart'; // WorkflowStep, WorkflowStepResult, TestStatus

class WorkflowStepCard extends StatelessWidget {
  final WorkflowStep step;
  final int index;
  final WorkflowStepResult? result; // null = not yet executed

  const WorkflowStepCard({
    super.key,
    required this.step,
    required this.index,
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget statusWidget;
    if (result == null) {
      // Not run yet — show step number badge
      statusWidget = CircleAvatar(
        radius: 12,
        backgroundColor: cs.surfaceContainerHighest,
        child: Text(
          '${index + 1}',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      final pass = result!.overallStatus == TestStatus.passed;
      statusWidget = Icon(
        pass ? Icons.check_circle : Icons.cancel,
        color: pass ? Colors.green : cs.error,
        size: 24,
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: statusWidget,
        title: Text(
          step.name,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        // WorkflowStep has method + url fields directly, no nested .request
        subtitle: Text(
          '${step.method.toUpperCase()}  ${step.url}',
          style: const TextStyle(fontSize: 11),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: result != null
            ? Text(
                '${result!.durationMs}ms',
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
              )
            : null,
      ),
    );
  }
}