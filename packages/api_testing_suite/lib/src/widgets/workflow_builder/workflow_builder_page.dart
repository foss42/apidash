import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workflow_providers.dart';
import 'workflow_canvas.dart';

/// The main page for building and editing workflows
class WorkflowBuilderPage extends ConsumerWidget {
  const WorkflowBuilderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowId = ref.watch(currentWorkflowProvider);
    final execState = ref.watch(workflowExecutionStateProvider);
    
    if (workflowId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No workflow selected'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(workflowsProvider.notifier).add();
              },
              child: const Text('Create New Workflow'),
            ),
          ],
        ),
      );
    }
    
    return Scaffold(
      body: Column(
        children: [
          // Toolbar 
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Workflow Builder',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                // Execution controls
                if (execState.status == WorkflowExecutionStatus.idle) ...[
                  IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.green),
                    tooltip: 'Start Workflow',
                    onPressed: () {
                      ref.read(workflowExecutionStateProvider.notifier).start();
                    },
                  ),
                ] else if (execState.status == WorkflowExecutionStatus.running) ...[
                  IconButton(
                    icon: const Icon(Icons.pause, color: Colors.orange),
                    tooltip: 'Pause Workflow',
                    onPressed: () {
                      ref.read(workflowExecutionStateProvider.notifier).pause();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.red),
                    tooltip: 'Stop Workflow',
                    onPressed: () {
                      ref.read(workflowExecutionStateProvider.notifier).stop();
                    },
                  ),
                ] else if (execState.status == WorkflowExecutionStatus.paused) ...[
                  IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.green),
                    tooltip: 'Resume Workflow',
                    onPressed: () {
                      ref.read(workflowExecutionStateProvider.notifier).resume();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.red),
                    tooltip: 'Stop Workflow',
                    onPressed: () {
                      ref.read(workflowExecutionStateProvider.notifier).stop();
                    },
                  ),
                ],
                
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Node',
                  onPressed: () {
                    _showAddNodeDialog(context, ref, workflowId);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: 'Save Workflow',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Workflow saved')),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Main canvas area
          Expanded(
            child: WorkflowCanvas(workflowId: workflowId),
          ),
        ],
      ),
    );
  }
  
  void _showAddNodeDialog(BuildContext context, WidgetRef ref, String workflowId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Node'),
        content: const Text('Select an API request to add as a node'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: @abhinavs1920 Add a node based on a selected request
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
