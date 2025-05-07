import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/workflow_model.dart';




// Provider for storing the current workflow
final workflowProvider = StateNotifierProvider<WorkflowNotifier, Workflow>((ref) {
  return WorkflowNotifier();
});

// Provider for the selected node
final selectedNodeProvider = StateProvider<WorkflowNode?>((ref) => null);

// Provider for sidebar visibility
final sidebarVisibilityProvider = StateProvider<bool>((ref) => true);

// Provider for navigation rail selected index
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class WorkflowNotifier extends StateNotifier<Workflow> {
  WorkflowNotifier()
      : super(Workflow(
    name: 'New Workflow',
    nodes: [
      WorkflowNode(
        name: 'Start',
        type: 'start',
        data: {
          'position': {'x': 200.0, 'y': 150.0}
        },
        inputs: [],
        outputs: ['trigger'],
      ),
    ],
    connections: [],
  ));

  void updateWorkflow(Workflow workflow) {
    state = workflow;
  }

  void addNode(String type) {
    // Calculate a better position for the new node
    final position = {
      'x': 200.0 + (state.nodes.length * 150),
      'y': 150.0 + (state.nodes.length % 3 * 120)
    };

    // Configure inputs/outputs based on node type
    List<String> inputs = [];
    List<String> outputs = [];

    switch (type) {
      case 'start':
        outputs = ['trigger'];
        break;
      case 'request':
        inputs = ['input'];
        outputs = ['success', 'error'];
        break;
      case 'condition':
        inputs = ['input'];
        outputs = ['true', 'false'];
        break;
      case 'transform':
        inputs = ['input'];
        outputs = ['output'];
        break;
      default:
        inputs = ['input'];
        outputs = ['output'];
    }

    // Create the new node
    final node = WorkflowNode(
      name: type.substring(0, 1).toUpperCase() + type.substring(1),
      type: type,
      data: {
        'position': position,
        // Add any type-specific defaults
        if (type == 'request') 'method': 'GET',
      },
      inputs: inputs,
      outputs: outputs,
    );

    // Create an entirely new workflow to force update detection
    state = Workflow(
      id: state.id,
      name: state.name,
      nodes: [...state.nodes, node],
      connections: state.connections,
    );
  }

  void updateNode(WorkflowNode updatedNode) {
    final updatedNodes = state.nodes
        .map((node) => node.id == updatedNode.id ? updatedNode : node)
        .toList();

    state = state.copyWith(nodes: updatedNodes);
  }

  void addConnection(WorkflowConnection connection) {
    state = state.copyWith(
      connections: [...state.connections, connection],
    );
  }
}