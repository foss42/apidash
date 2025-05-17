import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workflow_model.dart';
import '../workflow_provider.dart';
import '../widgets/workflow_canvas.dart';

class WorkflowEditorScreen extends ConsumerWidget {
  const WorkflowEditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflow = ref.watch(workflowProvider);
    final showSidebar = ref.watch(sidebarVisibilityProvider);
    // final selectedNavIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(workflow.name),
        actions: [

          IconButton(
            icon: Icon(showSidebar ? Icons.inbox : Icons.menu),
            tooltip: showSidebar ? 'Hide Sidebar' : 'Show Sidebar',
            onPressed: () {
              ref.read(sidebarVisibilityProvider.notifier).state = !showSidebar;
              print('Sidebar visibility: $showSidebar');
            },
          ),
        ],
      ),

      body: Row(
        children: [
          if (showSidebar)
            Container(
              width: 180,
              color: Colors.white,
              child: _buildNodeTypesPanel(context, ref),
            ),

          Expanded(
            child: WorkflowCanvas(
              workflow: workflow,
              onWorkflowChanged: (updatedWorkflow) {
                ref.read(workflowProvider.notifier).updateWorkflow(updatedWorkflow);
              },
            ),
          ),
        ],
      ),


    );
  }

  // This is a separate widget for the node types panel
  Widget _buildNodeTypesPanel(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Text(
            'Node Types',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.blue.shade700,
            ),
          ),
        ),
        Divider(height: 1),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildNodeTypeButton(context, 'Request', Icons.http, 'request', ref),
              _buildNodeTypeButton(context, 'Condition', Icons.call_split, 'condition', ref),
              _buildNodeTypeButton(context, 'Transform', Icons.transform, 'transform', ref),
              // Add more node types as needed
            ],
          ),
        ),
      ],
    );
  }



  // Helper method to build a node type button with icon and text
  Widget _buildNodeTypeButton(BuildContext context, String name, IconData icon, String nodeType, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(workflowProvider.notifier).addNode(nodeType);
        print('Tapped on node type: $name');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue.shade600),
            const SizedBox(width: 12),
            Text(name),
          ],
        ),
      ),
    );
  }


}