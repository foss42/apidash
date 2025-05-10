import 'package:api_testing_suite/src/workflow_builder/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'package:apidash_core/models/http_request_model.dart';
import 'package:uuid/uuid.dart';
import '../widgets/logs_viewer.dart';
import 'canvas/canvas_view.dart';
import 'node_details_panel.dart' as node_details;
import 'sidebar_panel.dart';
import 'toolbar_panel.dart';


enum LeftPanelTab {
  apiComponents,
  templates,
}

final leftPanelTabProvider = StateProvider<LeftPanelTab>((ref) {
  return LeftPanelTab.apiComponents;
});

/// An optimized version of the WorkflowBuilderPage that uses components
class WorkflowBuilderScreen extends ConsumerWidget {
  const WorkflowBuilderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowId = ref.watch(currentWorkflowProvider);
    final workflowExecutionState = ref.watch(workflowExecutionStateProvider);
    final connectionMode = ref.watch(connectionModeProvider);
    final executionControl = ref.watch(workflowExecutionControlProvider);
    final selectedNodeId = ref.watch(selectedNodeIdProvider);
    final leftPanelTab = ref.watch(leftPanelTabProvider);

    if (workflowId == null) {
      return _buildNoWorkflowScreen(context, ref);
    }

    WorkflowNodeModel? selectedNode;
    if (selectedNodeId != null) {
      final workflows = ref.watch(workflowsNotifierProvider);
      final workflow = workflows.firstWhere(
        (w) => w.id == workflowId,
        orElse: () => throw Exception('Workflow not found'),
      );

      selectedNode = workflow.nodes.firstWhere(
        (n) => n.id == selectedNodeId,
        orElse: () => throw Exception('Node not found'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: _buildAppBar(ref, workflowExecutionState),
      body: Column(
        children: [
          ToolbarPanel(
            connectionMode: connectionMode,
            executionState: workflowExecutionState,
            executionControl: executionControl,
            onConnectionModeToggle: () {
              ref.read(connectionModeProvider.notifier).state = !connectionMode;
            },
          ),
          Expanded(
            child: Row(
              children: [
                SidebarPanel(
                  selectedTab: leftPanelTab,
                  onTabChanged: (tab) {
                    ref.read(leftPanelTabProvider.notifier).state = tab;
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CanvasView(
                          key: ValueKey('${workflowId}_${selectedNode != null ? selectedNode.id : ''}_${DateTime.now().millisecondsSinceEpoch}'),
                          workflowId: workflowId,
                        ),
                      ),
                      Expanded(
                        child: LogsViewer(workflowId: workflowId),
                      ),
                    ],
                  ),
                ),
                if (selectedNode != null)
                  node_details.NodeDetailsPanel(
                    node: selectedNode,
                    workflowId: workflowId,
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          final workflowId = ref.read(currentWorkflowProvider);
          if (workflowId == null) return;
          final position = const Offset(100, 100);
          final node = WorkflowNodeModel.create(
            requestId: workflowId,
            position: position,
            label: 'New API',
            nodeType: NodeType.request,
            requestModel: RequestModel(
              id: const Uuid().v4(),
              httpRequestModel: HttpRequestModel(),
            ),
          );
          ref.read(workflowsNotifierProvider.notifier).addNode(workflowId, node);
          debugPrint('[FAB] Added node with ID: ${node.id} at position: $position');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(
      WidgetRef ref, WorkflowExecutionState workflowExecutionState) {
    return AppBar(
      backgroundColor: const Color(0xFF171717),
      title: const Text('Workflow Builder'),
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            //TODO: Implement save workflow
            // ref.read(workflowsNotifierProvider.notifier).saveWorkflows();
            ScaffoldMessenger.of(ref.context).showSnackBar(
              const SnackBar(content: Text('Workflow saved')),
            );
          },
          tooltip: 'Save Workflow',
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            ScaffoldMessenger.of(ref.context).showSnackBar(
              const SnackBar(
                  content: Text('Settings will be implemented soon')),
            );
          },
          tooltip: 'Workflow Settings',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildNoWorkflowScreen(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        title: const Text('Workflow Builder'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            color: const Color(0xFF212121),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.account_tree,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Create a New Workflow',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Get started by creating a new API workflow',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showCreateWorkflowDialog(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Create Workflow',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Importing workflows will be implemented soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.upload_file, color: Colors.blue),
                    label: const Text(
                      'Import Workflow',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateWorkflowDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Workflow'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Workflow Name',
                  hintText: 'Enter a name for your workflow',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter a description for your workflow',
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final notifier = ref.read(workflowsNotifierProvider.notifier);
                  final workflowId = notifier.createWorkflow(
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim(),
                  );
                  ref.read(currentWorkflowProvider.notifier).state = workflowId;
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
