import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'providers/agent_testing_provider.dart';
import 'widgets/api_key_input.dart';
import 'widgets/test_case_checklist.dart';
import 'widgets/test_result_card.dart';
import 'widgets/workflow_step_card.dart';

class AgentTestingScreen extends ConsumerWidget {
  const AgentTestingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agentTestingProvider);
    final notifier = ref.read(agentTestingProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          // ── Top bar ──────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: cs.surfaceContainerHigh),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.smart_toy_outlined, size: 20),
                const SizedBox(width: 8),
                Text('Agent Testing',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                // Mode toggle
                SegmentedButton<AgentMode>(
                  segments: const [
                    ButtonSegment(
                      value: AgentMode.unitTest,
                      label: Text('Unit Tests'),
                      icon: Icon(Icons.science_outlined, size: 16),
                    ),
                    ButtonSegment(
                      value: AgentMode.workflow,
                      label: Text('Workflow'),
                      icon: Icon(Icons.account_tree_outlined, size: 16),
                    ),
                  ],
                  selected: {state.mode},
                  onSelectionChanged: (s) => notifier.setMode(s.first),
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: state.mode == AgentMode.unitTest
                ? _UnitTestBody(state: state, notifier: notifier)
                : _WorkflowBody(state: state, notifier: notifier),
          ),
        ],
      ),
    );
  }
}

// ── Unit Test Panel ────────────────────────────────────────────────────────

class _UnitTestBody extends ConsumerWidget {
  final AgentTestingState state;
  final AgentTestingNotifier notifier;

  const _UnitTestBody({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // grab currently selected request from API Dash
    final selectedRequest = ref.watch(
      selectedRequestModelProvider.select((r) => r?.httpRequestModel),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // API key input
          const ApiKeyInput(),
          const SizedBox(height: 12),

          // Error banner
          if (state.errorMessage != null)
            _ErrorBanner(message: state.errorMessage!),

          // ── IDLE ──
          if (state.status == AgentStatus.idle) ...[
            const SizedBox(height: 8),
            if (selectedRequest == null)
              const _EmptyHint(
                  message:
                      'Select an API request on the left, then click Generate.')
            else
              _InfoCard(request: selectedRequest),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: selectedRequest == null
                  ? null
                  : () => notifier.generateUnitTests(
                      method: selectedRequest.method.abbr,
                      url: selectedRequest.url,
                      headers: selectedRequest.enabledHeadersMap,
                      body: selectedRequest.body,
                    ),
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: const Text('Generate Test Cases'),
            ),
          ],

          // ── GENERATING ──
          if (state.status == AgentStatus.generating)
            const _GeneratingIndicator(label: 'AI is generating test cases...'),

          // ── REVIEW ──
          if (state.status == AgentStatus.review) ...[
            Row(
              children: [
                Text('${state.testCases.length} test cases generated',
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                TextButton(
                    onPressed: notifier.reset, child: const Text('Reset')),
              ],
            ),
            const SizedBox(height: 8),
            TestCaseChecklist(
              cases: state.testCases,
              onToggle: notifier.toggleTestCase,
              onSelectAll: notifier.selectAllTestCases,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: state.testCases.any((c) => c.isSelected)
                  ? notifier.runSelectedTests
                  : null,
              icon: const Icon(Icons.play_arrow, size: 16),
              label: Text(
                  'Run ${state.testCases.where((c) => c.isSelected).length} Selected'),
            ),
          ],

          // ── RUNNING ──
          if (state.status == AgentStatus.running)
            const _GeneratingIndicator(label: 'Running tests...'),

          // ── COMPLETE ──
          if (state.status == AgentStatus.complete) ...[
            _ResultsSummaryBar(results: state.testResults),
            const SizedBox(height: 8),
            ...state.testResults.map((r) => TestResultCard(result: r)),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: notifier.reset,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('New Test Run'),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Workflow Panel ─────────────────────────────────────────────────────────

class _WorkflowBody extends ConsumerWidget {
  final AgentTestingState state;
  final AgentTestingNotifier notifier;

  const _WorkflowBody({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // requestSequenceProvider gives List<String> of request IDs
    final requestIds = ref.watch(requestSequenceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ApiKeyInput(),
          const SizedBox(height: 12),

          if (state.errorMessage != null)
            _ErrorBanner(message: state.errorMessage!),

          if (state.status == AgentStatus.idle) ...[
            Text(
              '${requestIds.length} request(s) in current collection',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: requestIds.isEmpty
                  ? null
                  : () async {
                      final collection =
                          ref.read(collectionStateNotifierProvider);
                      final requestMaps = requestIds
                          .map((id) {
                            final model = collection?[id];
                            final http = model?.httpRequestModel;
                            if (http == null) return null;
                            return <String, dynamic>{
                              'method': http.method.abbr,
                              'url': http.url,
                              'headers': http.enabledHeadersMap,
                              'body': http.body,
                            };
                          })
                          .whereType<Map<String, dynamic>>()
                          .toList();
                      await notifier.generateWorkflow(requestMaps);
                    },
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: const Text('Generate Workflow Plan'),
            ),
          ],

          if (state.status == AgentStatus.generating)
            const _GeneratingIndicator(label: 'AI is planning workflow...'),

          if (state.status == AgentStatus.review ||
              state.status == AgentStatus.complete) ...[
            Text(
              '${state.workflowSteps.length} steps planned',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...state.workflowSteps.asMap().entries.map((e) {
              final result = state.stepResults.length > e.key
                  ? state.stepResults[e.key]
                  : null;
              return WorkflowStepCard(
                step: e.value,
                index: e.key,
                result: result,
              );
            }),
            const SizedBox(height: 16),
            if (state.status == AgentStatus.review)
              FilledButton.icon(
                onPressed: notifier.executeWorkflow,
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text('Execute Workflow'),
              ),
            if (state.status == AgentStatus.complete)
              OutlinedButton.icon(
                onPressed: notifier.reset,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('New Workflow'),
              ),
          ],

          if (state.status == AgentStatus.running)
            const _GeneratingIndicator(label: 'Executing workflow...'),
        ],
      ),
    );
  }
}
// ── Shared small widgets ───────────────────────────────────────────────────

class _GeneratingIndicator extends StatelessWidget {
  final String label;
  const _GeneratingIndicator({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline,
              size: 16, color: Theme.of(context).colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
              child: Text(message,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onErrorContainer))),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String message;
  const _EmptyHint({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.info_outline,
                size: 36,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final dynamic request;
  const _InfoCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.api, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${request.method.abbr}  ${request.url}',
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsSummaryBar extends StatelessWidget {
  final List results;
  const _ResultsSummaryBar({required this.results});

  @override
  Widget build(BuildContext context) {
    final passed = results.where((r) => r.overallStatus.name == 'passed').length;
    final failed = results.where((r) => r.overallStatus.name == 'failed').length;
    final skipped =
        results.where((r) => r.overallStatus.name == 'skipped').length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(count: passed, label: 'Passed', color: Colors.green),
          _SummaryItem(
              count: failed,
              label: 'Failed',
              color: Theme.of(context).colorScheme.error),
          _SummaryItem(count: skipped, label: 'Skipped', color: Colors.grey),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _SummaryItem(
      {required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}