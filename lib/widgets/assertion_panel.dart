// DashAssert – Assertion Panel Widget
// Part of the AI-Powered Response Assertion Engine for API Dash
// Relates to GSoC 2026 Idea #4: Agentic API Testing

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/assertion_providers.dart';
import 'package:apidash/models/assertion_model.dart';

/// Displays and manages assertion rules for a single API request.
///
/// Shows pass/fail results inline and provides AI-based suggestions,
/// manual rule creation, and Markdown/JSON export.
class AssertionPanel extends ConsumerStatefulWidget {
  const AssertionPanel({
    super.key,
    required this.requestId,
    this.httpResponseModel,
    this.requestUrl,
  });

  final String requestId;
  final HttpResponseModel? httpResponseModel;
  final String? requestUrl;

  @override
  ConsumerState<AssertionPanel> createState() => _AssertionPanelState();
}

class _AssertionPanelState extends ConsumerState<AssertionPanel> {
  @override
  void initState() {
    super.initState();
    // Ensure a suite exists for this request.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(assertionSuitesProvider.notifier)
          .createSuiteForRequest(widget.requestId);
    });
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _runAssertions() async {
    final responseModel = widget.httpResponseModel;
    if (responseModel == null) {
      _showSnack('No response available. Send a request first.');
      return;
    }
    final engine = ref.read(assertionEngineProvider);
    final suite = ref
        .read(assertionSuitesProvider.notifier)
        .getSuiteForRequest(widget.requestId);
    if (suite.rules.isEmpty) {
      _showSnack('No assertion rules defined. Add rules or use AI Suggest.');
      return;
    }
    final updatedSuite = engine.executeAll(suite, responseModel);
    ref
        .read(assertionSuitesProvider.notifier)
        .updateSuiteResults(widget.requestId, updatedSuite);
  }

  Future<void> _aiSuggest() async {
    final responseModel = widget.httpResponseModel;
    if (responseModel == null) {
      _showSnack('No response available. Send a request first.');
      return;
    }
    ref.read(aiSuggestionLoadingProvider.notifier).state = true;
    try {
      final suggester = ref.read(aiSuggesterProvider);
      final suggestions = await suggester.suggestAssertions(
        responseModel,
        requestUrl: widget.requestUrl,
      );
      if (suggestions.isEmpty) {
        _showSnack('No suggestions generated for this response.');
      } else {
        ref
            .read(assertionSuitesProvider.notifier)
            .addRules(widget.requestId, suggestions);
        _showSnack('Added ${suggestions.length} AI-suggested assertions.');
      }
    } catch (e) {
      _showSnack('Error generating suggestions: $e');
    } finally {
      ref.read(aiSuggestionLoadingProvider.notifier).state = false;
    }
  }

  void _exportMarkdown() {
    final engine = ref.read(assertionEngineProvider);
    final suite = ref
        .read(assertionSuitesProvider.notifier)
        .getSuiteForRequest(widget.requestId);
    final report = engine.exportMarkdownReport(
      suite,
      requestUrl: widget.requestUrl ?? '',
    );
    Clipboard.setData(ClipboardData(text: report));
    _showSnack('Markdown report copied to clipboard!');
  }

  void _exportJson() {
    final engine = ref.read(assertionEngineProvider);
    final suite = ref
        .read(assertionSuitesProvider.notifier)
        .getSuiteForRequest(widget.requestId);
    final report = engine.exportJsonReport(suite);
    const encoder = JsonEncoder.withIndent('  ');
    Clipboard.setData(ClipboardData(text: encoder.convert(report)));
    _showSnack('JSON report copied to clipboard!');
  }

  void _clearAll() {
    ref.read(assertionSuitesProvider.notifier).clearSuite(widget.requestId);
  }

  void _removeRule(String ruleId) {
    ref
        .read(assertionSuitesProvider.notifier)
        .removeRule(widget.requestId, ruleId);
  }

  // ---------------------------------------------------------------------------
  // Add Rule dialog
  // ---------------------------------------------------------------------------

  Future<void> _showAddRuleDialog() async {
    final formKey = GlobalKey<FormState>();
    AssertionType selectedType = AssertionType.statusCode;
    final descController = TextEditingController();
    final expectedController = TextEditingController();
    final jsonPathController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Add Assertion Rule'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type dropdown
                      DropdownButtonFormField<AssertionType>(
                        value: selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Assertion Type',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: AssertionType.values
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(
                                  t.label,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setDialogState(() => selectedType = v);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      // Description
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'e.g. Status code is 200',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Description is required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      // Expected value
                      TextFormField(
                        controller: expectedController,
                        decoration: InputDecoration(
                          labelText:
                              selectedType == AssertionType.responseTimeUnder
                              ? 'Threshold (ms)'
                              : selectedType == AssertionType.headerExists
                              ? 'Header Name'
                              : 'Expected Value',
                          hintText: _expectedHint(selectedType),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        validator: (v) {
                          if (selectedType == AssertionType.jsonFieldExists) {
                            return null; // value optional for existence check
                          }
                          if (v == null || v.trim().isEmpty) {
                            return 'Expected value is required';
                          }
                          return null;
                        },
                      ),
                      // JSON Path (conditional)
                      if (selectedType.requiresJsonPath ||
                          selectedType == AssertionType.headerValue) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: jsonPathController,
                          decoration: InputDecoration(
                            labelText: selectedType == AssertionType.headerValue
                                ? 'Header Name (case-insensitive)'
                                : 'JSON Path (dot notation)',
                            hintText: selectedType == AssertionType.headerValue
                                ? 'e.g. content-type'
                                : 'e.g. user.address.city',
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          validator: (v) {
                            if (selectedType.requiresJsonPath ||
                                selectedType == AssertionType.headerValue) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Path/header name is required';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    final rule = AssertionRule(
                      id: 'rule_${DateTime.now().millisecondsSinceEpoch}',
                      type: selectedType,
                      description: descController.text.trim(),
                      expectedValue: expectedController.text.trim().isEmpty
                          ? null
                          : expectedController.text.trim(),
                      jsonPath: jsonPathController.text.trim().isEmpty
                          ? null
                          : jsonPathController.text.trim(),
                    );
                    ref
                        .read(assertionSuitesProvider.notifier)
                        .addRule(widget.requestId, rule);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Add Rule'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final suitesMap = ref.watch(assertionSuitesProvider);
    final aiLoading = ref.watch(aiSuggestionLoadingProvider);
    final suite = suitesMap[widget.requestId];
    final rules = suite?.rules ?? [];
    final hasResponse = widget.httpResponseModel != null;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Top action bar ──────────────────────────────────────────────────
        _ActionBar(
          hasResponse: hasResponse,
          aiLoading: aiLoading,
          ruleCount: rules.length,
          onAddRule: _showAddRuleDialog,
          onAiSuggest: _aiSuggest,
          onRun: _runAssertions,
          onClearAll: rules.isNotEmpty ? _clearAll : null,
          onExportMarkdown: _exportMarkdown,
          onExportJson: _exportJson,
        ),
        const Divider(height: 1),
        // ── Rules list ──────────────────────────────────────────────────────
        Expanded(
          child: rules.isEmpty
              ? _EmptyState(hasResponse: hasResponse)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: rules.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (ctx, i) => _AssertionRuleRow(
                    rule: rules[i],
                    onRemove: () => _removeRule(rules[i].id),
                  ),
                ),
        ),
        const Divider(height: 1),
        // ── Bottom summary bar ─────────────────────────────────────────────
        if (suite != null && suite.hasBeenRun)
          _SummaryBar(suite: suite, colorScheme: colorScheme),
      ],
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  String _expectedHint(AssertionType type) {
    switch (type) {
      case AssertionType.statusCode:
        return '200';
      case AssertionType.responseTimeUnder:
        return '500';
      case AssertionType.headerExists:
        return 'content-type';
      case AssertionType.headerValue:
        return 'application/json';
      case AssertionType.bodyContains:
        return 'success';
      case AssertionType.jsonFieldExists:
        return '(optional)';
      case AssertionType.jsonFieldValue:
        return 'expected value';
    }
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.hasResponse,
    required this.aiLoading,
    required this.ruleCount,
    required this.onAddRule,
    required this.onAiSuggest,
    required this.onRun,
    required this.onClearAll,
    required this.onExportMarkdown,
    required this.onExportJson,
  });

  final bool hasResponse;
  final bool aiLoading;
  final int ruleCount;
  final VoidCallback onAddRule;
  final VoidCallback onAiSuggest;
  final VoidCallback onRun;
  final VoidCallback? onClearAll;
  final VoidCallback onExportMarkdown;
  final VoidCallback onExportJson;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          // Title
          const Icon(Icons.bolt, size: 16),
          const SizedBox(width: 4),
          Text(kLabelAssertions, style: Theme.of(context).textTheme.labelLarge),
          const Spacer(),
          // Add Rule
          _ActionChip(icon: Icons.add, label: kLabelAddRule, onTap: onAddRule),
          const SizedBox(width: 6),
          // AI Suggest
          _ActionChip(
            icon: Icons.auto_awesome,
            label: kLabelAiSuggest,
            loading: aiLoading,
            enabled: hasResponse,
            onTap: onAiSuggest,
            highlighted: true,
          ),
          const SizedBox(width: 6),
          // Run
          _ActionChip(
            icon: Icons.play_arrow,
            label: kLabelRunAssertions,
            enabled: hasResponse && ruleCount > 0,
            onTap: onRun,
          ),
          const SizedBox(width: 6),
          // Export menu
          PopupMenuButton<String>(
            tooltip: kLabelExportReport,
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'markdown',
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, size: 16),
                    SizedBox(width: 8),
                    Text('Export as Markdown'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'json',
                child: Row(
                  children: [
                    Icon(Icons.data_object, size: 16),
                    SizedBox(width: 8),
                    Text('Export as JSON'),
                  ],
                ),
              ),
              if (onClearAll != null)
                PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(
                        Icons.clear_all,
                        size: 16,
                        color: Theme.of(ctx).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Clear All Rules',
                        style: TextStyle(
                          color: Theme.of(ctx).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            onSelected: (v) {
              if (v == 'markdown') onExportMarkdown();
              if (v == 'json') onExportJson();
              if (v == 'clear') onClearAll?.call();
            },
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.more_vert, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.loading = false,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool loading;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveEnabled = enabled && !loading;
    final color = highlighted ? cs.primary : cs.onSurface;
    return InkWell(
      onTap: effectiveEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: color,
                ),
              )
            else
              Icon(
                icon,
                size: 14,
                color: effectiveEnabled
                    ? color
                    : cs.onSurface.withOpacity(0.38),
              ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: effectiveEnabled
                    ? color
                    : cs.onSurface.withOpacity(0.38),
                fontWeight: highlighted ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssertionRuleRow extends StatelessWidget {
  const _AssertionRuleRow({required this.rule, required this.onRemove});

  final AssertionRule rule;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      dense: true,
      minVerticalPadding: 4,
      leading: _statusIcon(rule.status, cs),
      title: Text(
        rule.description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: _buildSubtitle(context, cs),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 16),
        onPressed: onRemove,
        tooltip: 'Remove rule',
        color: cs.onSurface.withOpacity(0.5),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context, ColorScheme cs) {
    final parts = <String>[];
    if (rule.jsonPath != null) parts.add('path: ${rule.jsonPath}');
    if (rule.actualValue != null && rule.status != AssertionStatus.pending) {
      parts.add('actual: ${rule.actualValue}');
    }
    if (rule.errorMessage != null) parts.add(rule.errorMessage!);
    if (parts.isEmpty) return null;
    return Text(
      parts.join('  ·  '),
      style: TextStyle(
        fontSize: 11,
        color:
            rule.status == AssertionStatus.fail ||
                rule.status == AssertionStatus.error
            ? cs.error
            : cs.onSurface.withOpacity(0.6),
      ),
    );
  }

  Widget _statusIcon(AssertionStatus status, ColorScheme cs) {
    switch (status) {
      case AssertionStatus.pass:
        return Icon(Icons.check_circle, color: Colors.green.shade600, size: 20);
      case AssertionStatus.fail:
        return Icon(Icons.cancel, color: cs.error, size: 20);
      case AssertionStatus.error:
        return Icon(
          Icons.warning_amber_rounded,
          color: Colors.orange.shade700,
          size: 20,
        );
      case AssertionStatus.pending:
        return Icon(
          Icons.pending_outlined,
          color: cs.onSurface.withOpacity(0.4),
          size: 20,
        );
    }
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.suite, required this.colorScheme});
  final AssertionSuite suite;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final passColor = Colors.green.shade600;
    final failColor = colorScheme.error;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Text(
            '${suite.passCount}/${suite.rules.length} passed',
            style: TextStyle(
              fontSize: 12,
              color: suite.allPassed ? passColor : failColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (suite.errorCount > 0) ...[
            const SizedBox(width: 8),
            Text(
              '${suite.errorCount} error${suite.errorCount > 1 ? 's' : ''}',
              style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
            ),
          ],
          const Spacer(),
          if (suite.lastRunAt != null)
            Text(
              'Last run: ${_formatTime(suite.lastRunAt!)}',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasResponse});
  final bool hasResponse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.rule_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No assertion rules yet',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasResponse
                  ? 'Click "✨ AI Suggest" to auto-generate rules\nor "+ Add Rule" to create manually.'
                  : 'Send a request first, then use\n"✨ AI Suggest" to auto-generate rules.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
