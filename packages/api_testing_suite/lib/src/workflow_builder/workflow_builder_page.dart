import 'package:apidash_core/consts.dart';
import 'package:apidash_core/models/http_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/models.dart';
import 'workflow_providers.dart';
import 'workflow_canvas.dart';
import 'models/workflow_execution_state.dart';
import 'widgets/widgets.dart';

enum LeftPanelTab {
  apiComponents,
  templates,
}

final leftPanelTabProvider = StateProvider<LeftPanelTab>((ref) {
  return LeftPanelTab.apiComponents;
});

class WorkflowBuilderPage extends ConsumerWidget {
  const WorkflowBuilderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflowId = ref.watch(currentWorkflowProvider);
    final workflowExecutionState = ref.watch(workflowExecutionStateProvider);
    final connectionMode = ref.watch(connectionModeProvider);
    final executionControl = ref.watch(workflowExecutionControlProvider);
    final selectedNodeId = ref.watch(selectedNodeIdProvider);

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
          _buildToolbar(
              ref, connectionMode, workflowExecutionState, executionControl),
          Expanded(
            child: Row(
              children: [
                _buildLeftPanel(ref),
                Expanded(
                  child: _buildCanvasWithLogs(workflowId),
                ),
                if (selectedNode != null)
                  NodeDetailsPanel(
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
          final notifier = ref.read(workflowsNotifierProvider.notifier);
          notifier.addNode(
            workflowId,
            WorkflowNodeModel.create(
              requestId: workflowId,
              position: const Offset(100, 100),
              label: 'New API',
              nodeType: NodeType.request,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildToolbar(
    WidgetRef ref,
    bool connectionMode,
    WorkflowExecutionState executionState,
    WorkflowExecutionControl executionControl,
  ) {
    return Container(
      height: 56,
      color: const Color(0xFF212121),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ToggleButton(
            icon: Icons.cable,
            label: 'Connection Mode',
            isActive: connectionMode,
            onPressed: () {
              ref.read(connectionModeProvider.notifier).state = !connectionMode;
            },
          ),

          const SizedBox(width: 16),

          Container(width: 1, height: 24, color: Colors.grey.shade700),

          const SizedBox(width: 16),

          _buildExecutionControls(executionState, executionControl),

          const Spacer(),

          if (executionState.isRunning ||
              executionState.isPaused ||
              executionState.isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(executionState),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStatusIcon(executionState),
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getStatusText(executionState),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExecutionControls(
    WorkflowExecutionState executionState,
    WorkflowExecutionControl executionControl,
  ) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          color: executionState.isRunning ? Colors.grey : Colors.green,
          onPressed: executionState.isRunning
              ? null
              : executionControl.startExecution,
          tooltip: 'Start Execution',
        ),

        IconButton(
          icon: Icon(executionState.isPaused ? Icons.play_circle : Icons.pause),
          color: !executionState.isRunning && !executionState.isPaused
              ? Colors.grey
              : executionState.isPaused
                  ? Colors.amber
                  : Colors.blue,
          onPressed: !executionState.isRunning && !executionState.isPaused
              ? null
              : executionState.isPaused
                  ? executionControl.resumeExecution
                  : executionControl.pauseExecution,
          tooltip: executionState.isPaused ? 'Resume' : 'Pause',
        ),

        IconButton(
          icon: const Icon(Icons.stop),
          color: !executionState.isRunning && !executionState.isPaused
              ? Colors.grey
              : Colors.red,
          onPressed: !executionState.isRunning && !executionState.isPaused
              ? null
              : executionControl.stopExecution,
          tooltip: 'Stop Execution',
        ),
      ],
    );
  }

  AppBar _buildAppBar(
    WidgetRef ref,
    WorkflowExecutionState workflowExecutionState,
  ) {
    final workflowId = ref.watch(currentWorkflowProvider);
    final workflows = ref.watch(workflowsNotifierProvider);
    final workflow = workflowId != null
        ? workflows.firstWhere(
            (w) => w.id == workflowId,
            orElse: () => throw Exception('Workflow not found'),
          )
        : null;

    return AppBar(
      backgroundColor: const Color(0xFF212121),
      title: Row(
        children: [
          const Icon(Icons.account_tree, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            workflow?.name ?? 'Workflow Builder',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        if (workflowExecutionState.isRunning ||
            workflowExecutionState.isPaused ||
            workflowExecutionState.isCompleted ||
            workflowExecutionState.hasError)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Chip(
              backgroundColor: _getStatusColor(workflowExecutionState),
              label: Text(
                _getStatusText(workflowExecutionState),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              avatar: Icon(
                _getStatusIcon(workflowExecutionState),
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLeftPanel(WidgetRef ref) {
    final selectedTab = ref.watch(leftPanelTabProvider);
    
    return Container(
      width: 250,
      color: const Color(0xFF252525),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF212121),
            child: Row(
              children: [
                _buildSidebarItem(
                  Icons.api,
                  'API Components',
                  selectedTab == LeftPanelTab.apiComponents,
                  onTap: () => ref.read(leftPanelTabProvider.notifier).state = 
                      LeftPanelTab.apiComponents,
                ),
                _buildSidebarItem(
                  Icons.description_outlined,
                  'Templates',
                  selectedTab == LeftPanelTab.templates,
                  onTap: () => ref.read(leftPanelTabProvider.notifier).state = 
                      LeftPanelTab.templates,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: selectedTab == LeftPanelTab.apiComponents
                ? const APIComponentList()
                : const TemplatesList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSidebarItem(
    IconData icon, 
    String title, 
    bool isSelected, 
    {VoidCallback? onTap}
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            color: isSelected
                ? const Color(0xFF2A2A2A)
                : const Color(0xFF212121),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.grey,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCanvasWithLogs(String workflowId) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: _buildRightPanel(workflowId),
        ),
        
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LogsViewer(workflowId: workflowId),
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel(String? workflowId) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: workflowId != null
          ? WorkflowCanvas(workflowId: workflowId)
          : const Center(child: Text('No workflow selected')),
    );
  }

  Widget _buildNoWorkflowScreen(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        title: const Row(
          children: [
            Icon(Icons.account_tree, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Workflow Builder',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 100,
              color: Colors.blue.withOpacity(0.7),
            ),
            const SizedBox(height: 32),
            const Text(
              'Welcome to Workflow Builder',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Create and manage API workflows visually',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Create New Workflow'),
              onPressed: () {
                final notifier = ref.read(workflowsNotifierProvider.notifier);
                final newWorkflowId = notifier.createWorkflow(
                  name: 'New Workflow',
                  description: 'Created on ${DateTime.now().toLocal()}',
                );

                ref.read(currentWorkflowProvider.notifier).state = newWorkflowId;
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(WorkflowExecutionState state) {
    if (state.hasError) return Colors.red;
    if (state.isCompleted) return Colors.green;
    if (state.isPaused) return Colors.amber;
    if (state.isRunning) return Colors.blue;
    return Colors.grey;
  }

  IconData _getStatusIcon(WorkflowExecutionState state) {
    if (state.hasError) return Icons.error_outline;
    if (state.isCompleted) return Icons.check_circle_outline;
    if (state.isPaused) return Icons.pause_circle_outline;
    if (state.isRunning) return Icons.sync;
    return Icons.hourglass_empty;
  }

  String _getStatusText(WorkflowExecutionState state) {
    if (state.hasError) return 'Failed';
    if (state.isCompleted) return 'Completed';
    if (state.isPaused) return 'Paused';
    if (state.isRunning) return 'Running';
    return 'Ready';
  }
}

class ToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const ToggleButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive ? Colors.blue : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.blue : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class APIComponentList extends ConsumerWidget {
  const APIComponentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'API Request Components',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        _APIComponentCard(
          icon: Icons.call_made,
          title: 'GET Request',
          description: 'Fetch data from an API',
          requestModel: RequestModel(
            id: 'api1',
            name: 'GET Request',
            httpRequestModel: HttpRequestModel(
              method: HTTPVerb.get,
              url: 'https://api.example.com/data',
            ),
          ),
        ),
        _APIComponentCard(
          icon: Icons.send,
          title: 'POST Request',
          description: 'Send data to an API',
          requestModel: RequestModel(
            id: 'api2',
            name: 'POST Request',
            httpRequestModel: HttpRequestModel(
              method: HTTPVerb.post,
              url: 'https://api.example.com/create',
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Flow Control Components',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        _FlowControlCard(
          icon: Icons.fork_right,
          title: 'Condition',
          description: 'Branch based on a condition',
          nodeType: NodeType.condition,
        ),
        _FlowControlCard(
          icon: Icons.settings,
          title: 'Action',
          description: 'Perform a custom action',
          nodeType: NodeType.action,
        ),
        _FlowControlCard(
          icon: Icons.call_received,
          title: 'Response',
          description: 'Simulate an API response',
          nodeType: NodeType.response,
        ),
      ],
    );
  }
}

class TemplatesList extends StatelessWidget {
  const TemplatesList({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'Workflow Templates',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        _TemplateCard(
          title: 'Authentication Flow',
          description: 'Login, get token, and fetch user data',
          icon: Icons.security,
        ),
        _TemplateCard(
          title: 'CRUD Operations',
          description: 'Create, read, update, and delete resources',
          icon: Icons.storage,
        ),
        _TemplateCard(
          title: 'Data Processing',
          description: 'Fetch, transform, and store data',
          icon: Icons.transform,
        ),
      ],
    );
  }
}

class _APIComponentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final RequestModel? requestModel;

  const _APIComponentCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.requestModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Draggable<WorkflowNodeModel>(
        data: WorkflowNodeModel.create(
          requestId: 'temp_id', 
          position: const Offset(0, 0), 
          label: title,
          requestModel: requestModel,
        ),
        feedback: Material(
          color: Colors.transparent,
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: ListTile(
            leading: Icon(icon, color: Colors.grey),
            title: Text(title),
            subtitle: Text(description),
          ),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(title),
          subtitle: Text(description),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
      ),
    );
  }
}

class _FlowControlCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final NodeType nodeType;

  const _FlowControlCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.nodeType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Draggable<WorkflowNodeModel>(
        data: WorkflowNodeModel.create(
          requestId: 'temp_id', 
          position: const Offset(0, 0), 
          label: title,
          nodeType: nodeType,
          nodeData: nodeType == NodeType.condition
              ? {'condition': 'statusCode == 200'}
              : nodeType == NodeType.action
                  ? {'actionType': 'transform', 'actionConfig': ''}
                  : {},
        ),
        feedback: Material(
          color: Colors.transparent,
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: nodeType == NodeType.condition
                    ? Colors.amber
                    : nodeType == NodeType.action
                        ? Colors.green
                        : Colors.purple,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: nodeType == NodeType.condition
                          ? Colors.amber
                          : nodeType == NodeType.action
                              ? Colors.green
                              : Colors.purple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: ListTile(
            leading: Icon(icon, color: Colors.grey),
            title: Text(title),
            subtitle: Text(description),
          ),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: nodeType == NodeType.condition
                ? Colors.amber
                : nodeType == NodeType.action
                    ? Colors.green
                    : Colors.purple,
          ),
          title: Text(title),
          subtitle: Text(description),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _TemplateCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        subtitle: Text(description),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        trailing: const Icon(Icons.add_circle_outline, color: Colors.teal),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Template "$title" will be implemented soon'),
            ),
          );
        },
      ),
    );
  }
}

class GridBackgroundPainter extends CustomPainter {
  final Color gridColor;
  final double step;

  GridBackgroundPainter({
    required this.gridColor,
    required this.step,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
