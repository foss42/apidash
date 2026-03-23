import 'package:apidash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/workflow_state.dart';
import '../providers/agentic_testing_providers.dart';
import 'test_review_card.dart';

class TestGenerationPanel extends ConsumerStatefulWidget {
  const TestGenerationPanel({super.key});

  @override
  ConsumerState<TestGenerationPanel> createState() => _TestGenerationPanelState();
}

class _TestGenerationPanelState extends ConsumerState<TestGenerationPanel> {
  late final TextEditingController _endpointController;

  @override
  void initState() {
    super.initState();
    final initialEndpoint = ref.read(selectedRequestModelProvider)?.httpRequestModel?.url;
    _endpointController = TextEditingController(text: initialEndpoint ?? '');
  }

  @override
  void dispose() {
    _endpointController.dispose();
    super.dispose();
  }

  Future<void> _onGeneratePressed() async {
    final selectedRequest = ref.read(selectedRequestModelProvider);
    final notifier = ref.read(agenticTestingStateMachineProvider.notifier);

    final endpoint = _endpointController.text.trim().isNotEmpty
        ? _endpointController.text.trim()
        : (selectedRequest?.httpRequestModel?.url ?? '');

    if (endpoint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select or enter an endpoint before generating tests.'),
        ),
      );
      return;
    }

    await notifier.startGeneration(
      endpoint: endpoint,
      method: selectedRequest?.httpRequestModel?.method.name.toUpperCase(),
      headers: selectedRequest?.httpRequestModel?.headersMap,
      requestBody: selectedRequest?.httpRequestModel?.body,
    );
  }

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(agenticTestingStateMachineProvider);
    final notifier = ref.read(agenticTestingStateMachineProvider.notifier);
    final isGenerating =
        workflow.workflowState == AgenticWorkflowState.generating;
    final canGenerate = workflow.workflowState == AgenticWorkflowState.idle;

    final stateColor = switch (workflow.workflowState) {
      AgenticWorkflowState.idle => Theme.of(context).colorScheme.outline,
      AgenticWorkflowState.generating => Colors.blue,
      AgenticWorkflowState.awaitingApproval => Colors.orange,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agentic API Testing Prototype',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'State Machine: IDLE -> GENERATING -> AWAITING_APPROVAL',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Chip(
              side: BorderSide(color: stateColor),
              label: Text(workflow.workflowState.label),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                workflow.statusMessage ?? 'Ready to generate API test cases.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        if (workflow.errorMessage != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.errorContainer,
            ),
            child: Text(
              workflow.errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _endpointController,
                enabled: !isGenerating,
                decoration: const InputDecoration(
                  labelText: 'Endpoint',
                  hintText: '/users or https://api.example.com/users',
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: isGenerating || !canGenerate ? null : _onGeneratePressed,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Tests'),
            ),
          ],
        ),
        if (isGenerating) ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
        ],
        const SizedBox(height: 12),
        if (workflow.generatedTests.isNotEmpty)
          Text(
            'Approved: ${workflow.approvedCount}  Rejected: ${workflow.rejectedCount}  Pending: ${workflow.pendingCount}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        const SizedBox(height: 8),
        Expanded(
          child: workflow.generatedTests.isEmpty
              ? Center(
                  child: Text(
                    'Generate tests to review them here.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  itemCount: workflow.generatedTests.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final testCase = workflow.generatedTests[index];
                    return TestReviewCard(
                      testCase: testCase,
                      onApprove: workflow.workflowState ==
                              AgenticWorkflowState.awaitingApproval
                          ? () => notifier.approveTest(testCase.id)
                          : null,
                      onReject: workflow.workflowState ==
                              AgenticWorkflowState.awaitingApproval
                          ? () => notifier.rejectTest(testCase.id)
                          : null,
                    );
                  },
                ),
        ),
        if (workflow.workflowState == AgenticWorkflowState.awaitingApproval) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              FilledButton.icon(
                onPressed: workflow.generatedTests.isEmpty
                    ? null
                    : notifier.approveAll,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Approve All'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed:
                    workflow.generatedTests.isEmpty ? null : notifier.rejectAll,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Reject All'),
              ),
              const Spacer(),
              TextButton(
                onPressed: notifier.reset,
                child: const Text('Reset'),
              ),
            ],
          ),
        ] else if (workflow.generatedTests.isNotEmpty) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: notifier.reset,
              child: const Text('Start Over'),
            ),
          ),
        ],
      ],
    );
  }
}
