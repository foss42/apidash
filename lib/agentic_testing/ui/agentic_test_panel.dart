import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/request_model.dart';
import '../models/test_result.dart';
import '../models/test_source.dart';
import '../models/test_status.dart';
import 'agentic_testing_provider.dart';

class AgenticTestPanel extends ConsumerWidget {
  final RequestModel currentRequest;

  const AgenticTestPanel({super.key, required this.currentRequest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testState = ref.watch(agenticTestingProvider);
    final notifier = ref.read(agenticTestingProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    final showResults = testState.latestSuite != null && !testState.isRunning;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                showResults ? 'Test Results' : 'Agentic Test Suite',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (showResults)
                TextButton.icon(
                  onPressed: () => notifier.clearState(),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset'),
                )
              else
                FilledButton.icon(
                  onPressed: testState.isGenerating || testState.isRunning
                      ? null
                      : () => notifier.generateTests(currentRequest),
                  icon: testState.isGenerating
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.auto_awesome, size: 16),
                  label: Text(
                      testState.isGenerating ? 'Generating...' : 'Generate Tests'),
                ),
            ],
          ),

          // ── Error banner ─────────────────────────────────────────
          if (testState.error != null) ...[
            const SizedBox(height: 12),
            _ErrorBanner(message: testState.error!),
          ],
          if (testState.aiError != null) ...[
            const SizedBox(height: 12),
            _ErrorBanner(message: '⚡ AI: ${testState.aiError!}'),
          ],

          const SizedBox(height: 12),

          // ── RESULTS VIEW ─────────────────────────────────────────
          if (showResults) ...[
            _ResultsSummaryBar(latestSuite: testState.latestSuite!),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: testState.latestSuite!.results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final result = testState.latestSuite!.results[index];
                  final tc = testState.latestSuite!.testCases.firstWhere(
                    (c) => c.id == result.testCaseId,
                    orElse: () => testState.generatedCases.firstWhere(
                      (c) => c.id == result.testCaseId,
                    ),
                  );
                  return _ResultTile(testCase: tc, result: result);
                },
              ),
            ),
          ]

          // ── EMPTY STATE ──────────────────────────────────────────
          else if (!testState.hasGenerated && !testState.isGenerating)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.science_outlined,
                        size: 48,
                        color: colorScheme.onSurface.withOpacity(0.3)),
                    const SizedBox(height: 12),
                    Text(
                      'No tests generated yet.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Click "Generate Tests" to create rule-based test cases.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.4),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )

          // ── CHECKLIST VIEW ───────────────────────────────────────
          else if (testState.hasGenerated) ...[
            Row(
              children: [
                Text(
                  '${testState.generatedCases.length} test cases',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => notifier.selectAll(),
                  child: const Text('All', style: TextStyle(fontSize: 12)),
                ),
                Text('/', style: TextStyle(color: colorScheme.outline)),
                TextButton(
                  onPressed: () => notifier.deselectAll(),
                  child: const Text('None', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: testState.generatedCases.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final tc = testState.generatedCases[index];
                  final isSelected = testState.selectedCaseIds.contains(tc.id);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: testState.isRunning || testState.isAiGenerating
                        ? null
                        : (_) => notifier.toggleSelection(tc.id),
                    title: Text(tc.name,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(
                      tc.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    secondary: _SourceBadge(source: tc.source),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                // Generate More → opens bottom sheet
                OutlinedButton.icon(
                  onPressed: testState.isAiGenerating || testState.isRunning
                      ? null
                      : () => _showGenerateMoreSheet(context, ref, notifier),
                  icon: testState.isAiGenerating
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.psychology_outlined, size: 16),
                  label: Text(
                      testState.isAiGenerating ? 'Thinking...' : 'Generate More'),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed:
                      testState.isRunning || testState.selectedCount == 0
                          ? null
                          : () => notifier.runSelectedTests(currentRequest),
                  icon: testState.isRunning
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.play_arrow, size: 16),
                  label: Text(testState.isRunning
                      ? 'Running...'
                      : 'Run (${testState.selectedCount})'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showGenerateMoreSheet(
    BuildContext context,
    WidgetRef ref,
    AgenticTestingNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _GenerateMoreSheet(
        currentRequest: currentRequest,
        notifier: notifier,
        ref: ref,
      ),
    );
  }
}

// ── Generate More Bottom Sheet ───────────────────────────────────────────────
class _GenerateMoreSheet extends StatefulWidget {
  final RequestModel currentRequest;
  final AgenticTestingNotifier notifier;
  final WidgetRef ref;

  const _GenerateMoreSheet({
    required this.currentRequest,
    required this.notifier,
    required this.ref,
  });

  @override
  State<_GenerateMoreSheet> createState() => _GenerateMoreSheetState();
}

class _GenerateMoreSheetState extends State<_GenerateMoreSheet> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await widget.notifier.generateMoreWithAi(
        requestModel: widget.currentRequest,
        ref: widget.ref,
        userInstructions: _controller.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text('Generate More with AI',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'AI will inspect your API spec and generate edge-case tests beyond the rule engine.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'Optional: "Focus on SQL injection, rate limiting, and missing fields..."',
              labelText: 'Instructions',
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            _ErrorBanner(message: _error!),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _loading ? null : _generate,
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.auto_awesome, size: 16),
              label: Text(_loading ? 'Generating...' : 'Generate with AI'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ───────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.onErrorContainer, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: TextStyle(color: colorScheme.onErrorContainer)),
          ),
        ],
      ),
    );
  }
}

class _ResultsSummaryBar extends StatelessWidget {
  final dynamic latestSuite;
  const _ResultsSummaryBar({required this.latestSuite});

  @override
  Widget build(BuildContext context) {
    final results = latestSuite.results as List;
    final passed = results.where((r) => r.status == TestStatus.pass).length;
    final failed = results.length - passed;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        _SummaryChip(
            label: '$passed passed',
            color: Colors.green.shade600,
            icon: Icons.check_circle_outline),
        const SizedBox(width: 8),
        if (failed > 0)
          _SummaryChip(
              label: '$failed failed',
              color: colorScheme.error,
              icon: Icons.cancel_outlined),
        const Spacer(),
        Text('${results.length} ran',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                )),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _SummaryChip(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    ]);
  }
}

class _ResultTile extends StatelessWidget {
  final dynamic testCase;
  final TestResult result;
  const _ResultTile({required this.testCase, required this.result});

  @override
  Widget build(BuildContext context) {
    final passed = result.status == TestStatus.pass;
    final color =
        passed ? Colors.green.shade600 : Theme.of(context).colorScheme.error;

    return ListTile(
      leading: Icon(
          passed ? Icons.check_circle : Icons.cancel,
          color: color,
          size: 22),
      title:
          Text(testCase.name, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(testCase.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Row(children: [
            _StatusPill(
              label:
                  'Got ${result.actualStatus ?? "—"} · Expected ${testCase.expectation.expectedStatus}',
              passed: passed,
            ),
            if (result.durationMs != null) ...[
              const SizedBox(width: 8),
              Text('${result.durationMs}ms',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.45),
                      )),
            ]
          ]),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final bool passed;
  const _StatusPill({required this.label, required this.passed});

  @override
  Widget build(BuildContext context) {
    final color =
        passed ? Colors.green.shade600 : Theme.of(context).colorScheme.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  final TestSource source;
  const _SourceBadge({required this.source});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAi = source == TestSource.ai;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isAi
            ? colorScheme.tertiaryContainer
            : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        source.name,
        style: TextStyle(
          fontSize: 10,
          color: isAi
              ? colorScheme.onTertiaryContainer
              : colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}