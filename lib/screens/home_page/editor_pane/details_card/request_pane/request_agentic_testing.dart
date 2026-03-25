import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/agentic_testing/agentic_testing.dart';
import '../../../../../agentic_testing/workflow/workflow_panel.dart';

enum TestingMode {
  unit,
  workflow,
}

final testingModeProvider = StateProvider<TestingMode>((_) => TestingMode.unit);

class EditRequestAgenticTesting extends ConsumerWidget {
  const EditRequestAgenticTesting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRequest = ref.watch(selectedRequestModelProvider);
    final mode = ref.watch(testingModeProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SegmentedButton<TestingMode>(
              segments: const [
                ButtonSegment<TestingMode>(
                  value: TestingMode.unit,
                  icon: Icon(Icons.science_outlined),
                  label: Text('Unit Test'),
                ),
                ButtonSegment<TestingMode>(
                  value: TestingMode.workflow,
                  icon: Icon(Icons.account_tree_outlined),
                  label: Text('Workflow Test'),
                ),
              ],
              selected: {mode},
              onSelectionChanged: (selection) {
                ref.read(testingModeProvider.notifier).state = selection.first;
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: mode == TestingMode.workflow
              ? const WorkflowPanel()
              : (currentRequest == null
                  ? const Center(child: Text('No request selected.'))
                  : AgenticTestPanel(currentRequest: currentRequest)),
        ),
      ],
    );
  }
}
