import 'package:api_testing_suite/src/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/workflow_model.dart';

/// Provider for workflows list
import 'workflows_notifier.dart';

/// Provider for workflows list
final workflowsProvider = StateNotifierProvider<WorkflowsNotifier, List<WorkflowModel>>((ref) {
  return WorkflowsNotifier(ref);
});

/// Provider for current workflow ID
final currentWorkflowProvider = StateProvider<String?>((ref) => null);

/// Provider for active workflow
final activeWorkflowProvider = Provider<WorkflowModel?>((ref) {
  final currentWorkflowId = ref.watch(currentWorkflowProvider);
  final workflows = ref.watch(workflowsProvider);
  
  if (currentWorkflowId == null) return null;
  
  return workflows.firstWhere(
    (workflow) => workflow.id == currentWorkflowId,
    // orElse: () => WorkflowModel.create(),
  );
});

/// Provider for workflow execution state
final workflowExecutionStateProvider = StateNotifierProvider<WorkflowExecutionNotifier, WorkflowExecutionState>((ref) {
  return WorkflowExecutionNotifier(ref);
});

enum WorkflowExecutionStatus {
  idle,
  running,
  paused,
  completed,
}

class WorkflowExecutionState {
  final WorkflowExecutionStatus status;
  final String? currentNodeId;
  final List<String> executedNodeIds;
  final Map<String, dynamic> executionContext;

  WorkflowExecutionState({
    this.status = WorkflowExecutionStatus.idle,
    this.currentNodeId,
    this.executedNodeIds = const [],
    this.executionContext = const {},
  });

  WorkflowExecutionState copyWith({
    WorkflowExecutionStatus? status,
    String? currentNodeId,
    List<String>? executedNodeIds,
    Map<String, dynamic>? executionContext,
  }) {
    return WorkflowExecutionState(
      status: status ?? this.status,
      currentNodeId: currentNodeId ?? this.currentNodeId,
      executedNodeIds: executedNodeIds ?? this.executedNodeIds,
      executionContext: executionContext ?? this.executionContext,
    );
  }
}

class WorkflowExecutionNotifier extends StateNotifier<WorkflowExecutionState> {
  final Ref _ref;
  
  WorkflowExecutionNotifier(this._ref) : super(WorkflowExecutionState());

  Future<void> start() async {
    if (state.status == WorkflowExecutionStatus.running) return;
    
    final workflow = _ref.read(activeWorkflowProvider);
    if (workflow == null || workflow.nodes.isEmpty) return;

    final firstNode = workflow.nodes.first;
    
    state = WorkflowExecutionState(
      status: WorkflowExecutionStatus.running,
      currentNodeId: firstNode.id,
      executedNodeIds: [],
      executionContext: {},
    );

    await _executeNode(firstNode.id);
  }

  Future<void> pause() async {
    if (state.status != WorkflowExecutionStatus.running) return;
    
    state = state.copyWith(status: WorkflowExecutionStatus.paused);
  }

  Future<void> resume() async {
    if (state.status != WorkflowExecutionStatus.paused) return;
    
    state = state.copyWith(status: WorkflowExecutionStatus.running);
    
    if (state.currentNodeId != null) {
      await _executeNode(state.currentNodeId!);
    }
  }

  Future<void> stop() async {
    state = WorkflowExecutionState();
    
    final workflow = _ref.read(activeWorkflowProvider);
    if (workflow != null) {
      _ref.read(workflowsProvider.notifier).updateNodes(
        workflow.id,
        workflow.nodes.map((node) => node.copyWith(status: NodeStatus.inactive)).toList(),
      );
    }
  }

  Future<void> _executeNode(String nodeId) async {
    if (state.status != WorkflowExecutionStatus.running) return;
    
    final workflow = _ref.read(activeWorkflowProvider);
    if (workflow == null) return;
    
    final nodeIndex = workflow.nodes.indexWhere((node) => node.id == nodeId);
    if (nodeIndex == -1) return;
    
    final node = workflow.nodes[nodeIndex];
    
    _ref.read(workflowsProvider.notifier).updateNode(
      workflow.id,
      node.copyWith(status: NodeStatus.running),
    );
    
    await Future.delayed(const Duration(seconds: 1));
    
    final isSuccess = DateTime.now().millisecondsSinceEpoch % 5 != 0; // 80% success rate
    
    _ref.read(workflowsProvider.notifier).updateNode(
      workflow.id,
      node.copyWith(status: isSuccess ? NodeStatus.success : NodeStatus.failure),
    );
    
    final updatedExecutedNodeIds = [...state.executedNodeIds, nodeId];
    state = state.copyWith(
      executedNodeIds: updatedExecutedNodeIds,
    );
    
    // If failed and is conditional, stop execution
    // if (!isSuccess && node.connectedToIds.isNotEmpty) {
    //   final connections = workflow.connections.where(
    //     (conn) => conn.sourceId == nodeId && conn.isConditional
    //   ).toList();
      
    //   if (connections.isNotEmpty) {
    //     state = state.copyWith(status: WorkflowExecutionStatus.completed);
    //     return;
    //   }
    // }
    
    // // Get next nodes
    // final nextNodeIds = node.connectedToIds.isEmpty 
    //     ? [] 
    //     : workflow.connections
    //         .where((conn) => conn.sourceId == nodeId)
    //         .map((conn) => conn.targetId)
    //         .toList();
    
    // // If no next nodes, workflow is completed
    // if (nextNodeIds.isEmpty) {
    //   state = state.copyWith(status: WorkflowExecutionStatus.completed);
    //   return;
    // }
    
    // // Execute next nodes
    // for (final nextNodeId in nextNodeIds) {
    //   state = state.copyWith(currentNodeId: nextNodeId);
    //   await _executeNode(nextNodeId);
      
    //   // If execution was paused or stopped, break the loop
    //   if (state.status != WorkflowExecutionStatus.running) {
    //     break;
    //   }
    // }
  }
}
