// DashAssert – Assertion Panel UI
// Part of the AI-Powered Response Assertion Engine for API Dash
// Relates to GSoC 2026 Idea #4: Agentic API Testing

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import '../consts.dart';
import '../models/assertion_model.dart';
import '../models/assertion_preset.dart';
import '../providers/assertion_providers.dart';

// ---------------------------------------------------------------------------
// AssertionPanel — main widget
// ---------------------------------------------------------------------------

/// Main assertion panel widget, rendered in the Assertions tab.
///
/// Shows the list of assertions, action buttons (AI Suggest, Templates,
/// Run All, Clear All, Export), inline results, and the Run History section.
class AssertionPanel extends ConsumerWidget {
  const AssertionPanel({
    super.key,
    required this.requestId,
  });

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suite = ref.watch(assertionSuitesProvider)[requestId];
    final rules = suite?.rules ?? [];
    final isLoading = ref.watch(aiSuggestionLoadingProvider);

    return Column(
      children: [
        // Action bar
        _AssertionActionBar(
          requestId: requestId,
          rules: rules,
          isLoading: isLoading,
        ),
        const Divider(height: 1),
        // If no rules yet, show empty state
        if (rules.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.checklist_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No assertions yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Click "AI Suggest" or "Templates" to get started',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView(
              children: [
                // Rule list
                ...rules.map((rule) => _AssertionRuleTile(
                      requestId: requestId,
                      rule: rule,
                    )),
                // Run History section
                if ((suite?.runHistory ?? []).isNotEmpty)
                  _RunHistorySection(suite: suite!),
                const SizedBox(height: 8),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Action bar
// ---------------------------------------------------------------------------

class _AssertionActionBar extends ConsumerWidget {
  const _AssertionActionBar({
    required this.requestId,
    required this.rules,
    required this.isLoading,
  });

  final String requestId;
  final List<AssertionRule> rules;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(assertionSuitesProvider.notifier);
    final suite = ref.read(assertionSuitesProvider)[requestId];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // AI Suggest button
          FilledButton.tonalIcon(
            onPressed: isLoading ? null : () => _onAiSuggest(context, ref),
            icon: isLoading
                ? const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome, size: 14),
            label: Text(
              isLoading ? 'Thinking…' : kLabelAiSuggest,
              style: const TextStyle(fontSize: 12),
            ),
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            ),
          ),

          // Templates picker
          _TemplatesButton(requestId: requestId),

          // Add Rule
          OutlinedButton.icon(
            onPressed: () => _addBlankRule(ref),
            icon: const Icon(Icons.add, size: 14),
            label: Text(kLabelAddRule, style: const TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            ),
          ),

          // Run All
          if (rules.isNotEmpty)
            FilledButton.icon(
              onPressed: () => _onRunAll(context, ref, suite),
              icon: const Icon(Icons.play_arrow, size: 14),
              label: Text(
                'Run All (${rules.length})',
                style: const TextStyle(fontSize: 12),
              ),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
            ),

          // Clear All
          if (rules.isNotEmpty)
            OutlinedButton.icon(
              onPressed: () => notifier.clearSuite(requestId),
              icon: const Icon(Icons.clear_all, size: 14),
              label:
                  const Text('Clear All', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
            ),

          // Export
          if (rules.isNotEmpty &&
              suite != null &&
              suite.hasBeenRun)
            _ExportButton(requestId: requestId, suite: suite),
        ],
      ),
    );
  }

  void _addBlankRule(WidgetRef ref) {
    final rule = AssertionRule(
      id: 'rule_${DateTime.now().millisecondsSinceEpoch}',
      type: AssertionType.statusCode,
      description: 'New assertion',
      expectedValue: 200,
    );
    ref.read(assertionSuitesProvider.notifier).addRule(requestId, rule);
  }

  Future<void> _onAiSuggest(BuildContext context, WidgetRef ref) async {
    // TODO: get real response from collection provider
    // For now, show a snackbar guiding the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Send the request first, then use AI Suggest to auto-generate assertions.',
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _onRunAll(
    BuildContext context,
    WidgetRef ref,
    AssertionSuite? suite,
  ) {
    if (suite == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Send the request first to run assertions against the live response.',
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Templates picker button
// ---------------------------------------------------------------------------

class _TemplatesButton extends ConsumerWidget {
  const _TemplatesButton({required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<AssertionPreset>(
      tooltip: kLabelApplyTemplate,
      offset: const Offset(0, 32),
      child: OutlinedButton.icon(
        onPressed: null, // handled by PopupMenuButton
        icon: const Icon(Icons.dashboard_customize_outlined, size: 14),
        label: Text(kLabelTemplates, style: const TextStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          // Remove pointer events from inner button; outer handles taps
          disabledForegroundColor:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      itemBuilder: (context) => kDashAssertPresets
          .map(
            (p) => PopupMenuItem<AssertionPreset>(
              value: p,
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Text(p.icon, style: const TextStyle(fontSize: 20)),
                title: Text(
                  p.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  p.description,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          )
          .toList(),
      onSelected: (preset) {
        ref
            .read(assertionSuitesProvider.notifier)
            .applyPreset(requestId, preset);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Export button
// ---------------------------------------------------------------------------

class _ExportButton extends ConsumerWidget {
  const _ExportButton({required this.requestId, required this.suite});

  final String requestId;
  final AssertionSuite suite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.read(assertionEngineProvider);
    return PopupMenuButton<String>(
      tooltip: kLabelExportReport,
      offset: const Offset(0, 32),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'markdown', child: Text('Export as Markdown')),
        const PopupMenuItem(value: 'json', child: Text('Export as JSON')),
      ],
      onSelected: (format) {
        final text = format == 'markdown'
            ? engine.exportMarkdownReport(suite)
            : const JsonEncoder.withIndent('  ')
                .convert(engine.exportJsonReport(suite));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Report copied! ($format, ${text.length} chars)',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.download_outlined, size: 14),
        label: Text(kLabelExportReport, style: const TextStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          disabledForegroundColor:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rule tile
// ---------------------------------------------------------------------------

class _AssertionRuleTile extends ConsumerWidget {
  const _AssertionRuleTile({
    required this.requestId,
    required this.rule,
  });

  final String requestId;
  final AssertionRule rule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    Color statusColor;
    IconData statusIcon;
    switch (rule.status) {
      case AssertionStatus.pass:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case AssertionStatus.fail:
        statusColor = colorScheme.error;
        statusIcon = Icons.cancel_outlined;
        break;
      case AssertionStatus.error:
        statusColor = Colors.orange;
        statusIcon = Icons.warning_amber_outlined;
        break;
      case AssertionStatus.pending:
        statusColor = colorScheme.outline;
        statusIcon = Icons.radio_button_unchecked;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: rule.status == AssertionStatus.pending
              ? colorScheme.outline.withValues(alpha: 0.3)
              : statusColor.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          rule.type.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          rule.description,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (rule.status != AssertionStatus.pending) ...[
                    const SizedBox(height: 4),
                    _buildResultRow(context, rule),
                  ],
                ],
              ),
            ),
            // Delete button
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 16,
                color: colorScheme.outline,
              ),
              visualDensity: VisualDensity.compact,
              onPressed: () => ref
                  .read(assertionSuitesProvider.notifier)
                  .removeRule(requestId, rule.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, AssertionRule rule) {
    final colorScheme = Theme.of(context).colorScheme;
    if (rule.status == AssertionStatus.error && rule.errorMessage != null) {
      return Text(
        '⚠ ${rule.errorMessage}',
        style: TextStyle(fontSize: 11, color: Colors.orange.shade700),
      );
    }
    final expected = rule.expectedValue?.toString() ?? '—';
    final actual = rule.actualValue ?? '—';
    final passed = rule.status == AssertionStatus.pass;
    return Row(
      children: [
        Text(
          'Expected: ',
          style: TextStyle(fontSize: 11, color: colorScheme.outline),
        ),
        Text(
          expected,
          style: const TextStyle(
            fontSize: 11,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Got: ',
          style: TextStyle(fontSize: 11, color: colorScheme.outline),
        ),
        Text(
          actual,
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'monospace',
            color: passed ? Colors.green : colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Run History section
// ---------------------------------------------------------------------------

/// Collapsible section showing the last 10 assertion run results.
class _RunHistorySection extends StatelessWidget {
  const _RunHistorySection({required this.suite});

  final AssertionSuite suite;

  @override
  Widget build(BuildContext context) {
    final history = suite.runHistory.reversed.take(10).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: ExpansionTile(
          dense: true,
          title: Text(
            '$kLabelRunHistory (${suite.runHistory.length})',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: history.map((run) {
            final allPass = run.failCount == 0 && run.totalCount > 0;
            return ListTile(
              dense: true,
              leading: Icon(
                allPass ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: allPass ? Colors.green : Theme.of(context).colorScheme.error,
                size: 16,
              ),
              title: Text(
                '${run.passCount}/${run.totalCount} passed',
                style: const TextStyle(fontSize: 12),
              ),
              subtitle: Text(
                _formatRelativeTime(run.runAt),
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              trailing: run.statusCode != null
                  ? _StatusCodeChip(statusCode: run.statusCode!)
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Formats a [DateTime] as a relative time string (e.g. "2m ago").
  String _formatRelativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _StatusCodeChip extends StatelessWidget {
  const _StatusCodeChip({required this.statusCode});

  final int statusCode;

  @override
  Widget build(BuildContext context) {
    final isSuccess = statusCode < 400;
    final color = isSuccess ? Colors.green : Theme.of(context).colorScheme.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isSuccess
            ? Colors.green.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        '$statusCode',
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
