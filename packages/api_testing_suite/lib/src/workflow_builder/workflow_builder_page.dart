import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'workflow_providers.dart';
import 'workflow_canvas.dart';
import '../models/workflow_execution_state.dart';

class WorkflowBuilderPage extends ConsumerWidget {
  const WorkflowBuilderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowId = ref.watch(currentWorkflowProvider);
    final workflowExecutionState = ref.watch(workflowExecutionStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workflow Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              ref.read(workflowExecutionStateProvider.notifier).state = 
                workflowExecutionState.copyWith(status: WorkflowExecutionStatus.running);
            },
          ),
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () {
              ref.read(workflowExecutionStateProvider.notifier).state = 
                workflowExecutionState.copyWith(status: WorkflowExecutionStatus.paused);
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              ref.read(workflowExecutionStateProvider.notifier).state = 
                workflowExecutionState.copyWith(status: WorkflowExecutionStatus.idle);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: WorkflowCanvas(
              workflowId: workflowId,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(workflowsNotifierProvider.notifier).addWorkflow('New Workflow');
                  },
                  child: const Text('New Workflow'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Add Node'),
                        content: const Text('Select node type'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Add Node'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
