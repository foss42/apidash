import 'package:flutter/material.dart';
import 'package:apidash_agent/apidash_agent.dart';

class WorkflowStepCard extends StatefulWidget {
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
  State<WorkflowStepCard> createState() => _WorkflowStepCardState();
}

class _WorkflowStepCardState extends State<WorkflowStepCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final result = widget.result;
    final step = widget.step;

    // ── Status icon ───────────────────────────────────────────────────────
    Widget statusIcon;
    if (result == null) {
      statusIcon = CircleAvatar(
        radius: 12,
        backgroundColor: cs.surfaceContainerHighest,
        child: Text(
          '${widget.index + 1}',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      final pass = result.overallStatus == TestStatus.passed;
      statusIcon = Icon(
        pass ? Icons.check_circle : Icons.cancel,
        color: pass ? Colors.green : cs.error,
        size: 24,
      );
    }

    // ── Has expandable content? ───────────────────────────────────────────
    final hasExtractions = step.dataExtractions.isNotEmpty;
    final hasAssertions = step.assertions.isNotEmpty;
    final hasResults = result?.assertionResults.isNotEmpty ?? false;
    final hasExtracted = result != null && result.extractedValues.isNotEmpty;
    final hasError = result?.errorMessage != null;
    final isExpandable = hasExtractions || hasAssertions || hasResults || hasError;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Header row ─────────────────────────────────────────────────
          InkWell(
            onTap: isExpandable
                ? () => setState(() => _expanded = !_expanded)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  statusIcon,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.name,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${step.method.toUpperCase()}  ${step.url}',
                          style: TextStyle(
                              fontSize: 11, color: cs.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (result != null)
                    Text(
                      '${result.durationMs}ms',
                      style: TextStyle(
                          fontSize: 11, color: cs.onSurfaceVariant),
                    ),
                  if (isExpandable) ...[
                    const SizedBox(width: 8),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Expanded details ───────────────────────────────────────────
          if (_expanded) ...[
            Divider(height: 1, color: cs.surfaceContainerHigh),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Planned assertions ────────────────────────────────
                  if (hasAssertions && result == null) ...[
                    _sectionLabel(context, 'ASSERTIONS'),
                    const SizedBox(height: 4),
                    ...step.assertions.map((a) => _assertionPlanRow(context, a)),
                    const SizedBox(height: 8),
                  ],

                  // ── Assertion results (after execution) ───────────────
                  if (hasResults) ...[
                    _sectionLabel(context, 'ASSERTION RESULTS'),
                    const SizedBox(height: 4),
                    ...result!.assertionResults.map(
                      (r) => _assertionResultRow(context, r),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // ── Data extractions plan ─────────────────────────────
                  if (hasExtractions) ...[
                    _sectionLabel(context, 'DATA EXTRACTIONS'),
                    const SizedBox(height: 4),
                    ...step.dataExtractions.map(
                      (d) => _extractionPlanRow(context, d),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // ── Extracted values (after execution) ────────────────
                  if (hasExtracted) ...[
                    _sectionLabel(context, 'EXTRACTED VALUES'),
                    const SizedBox(height: 4),
                    ...result!.extractedValues.entries.map(
                      (e) => _extractedValueRow(context, e.key, e.value),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // ── Error ─────────────────────────────────────────────
                  if (hasError) ...[
                    _sectionLabel(context, 'ERROR', isError: true),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cs.errorContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        result!.errorMessage!,
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onErrorContainer,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Sub-builders ─────────────────────────────────────────────────────────

  Widget _sectionLabel(BuildContext context, String label,
      {bool isError = false}) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _assertionPlanRow(BuildContext context, Assertion a) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.radio_button_unchecked, size: 12),
          const SizedBox(width: 6),
          Text(
            '${a.type.name} = ${a.expected}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _assertionResultRow(BuildContext context, AssertionResult r) {
    final cs = Theme.of(context).colorScheme;
    final color = r.skipped
        ? cs.onSurfaceVariant
        : (r.passed ? Colors.green : cs.error);
    final icon = r.skipped
        ? Icons.skip_next
        : (r.passed ? Icons.check : Icons.close);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              r.message,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _extractionPlanRow(BuildContext context, DataBinding d) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.arrow_outward,
              size: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            'Extract ',
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          Text(
            '\${${d.variableName}}',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            ' from ',
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          Text(
            d.jsonPath,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _extractedValueRow(
      BuildContext context, String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.tag, size: 12, color: Colors.teal),
          const SizedBox(width: 6),
          Text(
            '\${$key}',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
              color: Colors.teal,
            ),
          ),
          const Text(' = ', style: TextStyle(fontSize: 12)),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}