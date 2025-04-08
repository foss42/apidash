import 'package:api_testing_suite/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/request_model.dart';

import '../models/workflow_model.dart';

/// Notifier class for workflows state management
class WorkflowsNotifier extends StateNotifier<List<WorkflowModel>> {
  final Ref _ref;
  
  WorkflowsNotifier(this._ref) : super([]);

  /// Add a new workflow
  void add() {
    final newWorkflow = WorkflowModel.create();
    state = [...state, newWorkflow];
    // We need to update the state provider directly through the ref
    _ref.read(StateProvider<String?>((ref) => null).notifier).state = newWorkflow.id;
  }

  /// Update an existing workflow
  void update(WorkflowModel workflow) {
    state = [
      for (final existingWorkflow in state)
        if (existingWorkflow.id == workflow.id) workflow else existingWorkflow,
    ];
  }

  /// Add a node to a workflow
  void addNode(String workflowId, WorkflowNodeModel node) {
    state = [
      for (final workflow in state)
        if (workflow.id == workflowId)
          workflow.copyWith(nodes: [...workflow.nodes, node])
        else
          workflow,
    ];
  }

  /// Update a node in a workflow
  void updateNode(String workflowId, WorkflowNodeModel updatedNode) {
    state = [
      for (final workflow in state)
        if (workflow.id == workflowId)
          workflow.copyWith(
            nodes: [
              for (final node in workflow.nodes)
                if (node.id == updatedNode.id) updatedNode else node,
            ],
          )
        else
          workflow,
    ];
  }
  
  /// Update multiple nodes in a workflow
  void updateNodes(String workflowId, List<WorkflowNodeModel> updatedNodes) {
    state = [
      for (final workflow in state)
        if (workflow.id == workflowId)
          workflow.copyWith(nodes: updatedNodes)
        else
          workflow,
    ];
  }

  /// Update a node's position in a workflow
  void updateNodePosition(String workflowId, String nodeId, Offset position) {
    state = [
      for (final workflow in state)
        if (workflow.id == workflowId)
          workflow.copyWith(
            nodes: [
              for (final node in workflow.nodes)
                if (node.id == nodeId)
                  node.copyWith(position: position)
                else
                  node,
            ],
          )
        else
          workflow,
    ];
  }

  /// Remove a node from a workflow
  void removeNode(String workflowId, String nodeId) {
    state = [
      for (final workflow in state)
        if (workflow.id == workflowId)
          workflow.copyWith(
            nodes: workflow.nodes.where((node) => node.id != nodeId).toList(),
            connections: workflow.connections.where(
              (conn) => conn.sourceId != nodeId && conn.targetId != nodeId
            ).toList(),
          )
        else
          workflow,
    ];
  }

  /// Add a connection between nodes in a workflow
  void addConnection(String workflowId, WorkflowConnectionModel connection) {
    state = [
      for (final workflow in state)
        if (workflow.id == workflowId)
          workflow.copyWith(connections: [...workflow.connections, connection])
        else
          workflow,
    ];
  }

  /// Update a connection in a workflow
  void updateConnection(String workflowId, WorkflowConnectionModel updatedConnection) {
    state = [
      for (final workflow in state)
        if (workflow.id == workflowId)
          workflow.copyWith(
            connections: [
              for (final connection in workflow.connections)
                if (connection.id == updatedConnection.id) updatedConnection else connection,
            ],
          )
        else
          workflow,
    ];
  }

  /// Remove a connection from a workflow
  void removeConnection(String workflowId, String connectionId) {
    state = [
      for (final workflow in state)
        if (workflow.id == workflowId)
          workflow.copyWith(
            connections: workflow.connections.where((conn) => conn.id != connectionId).toList(),
          )
        else
          workflow,
    ];
  }

  /// Delete a workflow
  void delete(String workflowId) {
    state = state.where((workflow) => workflow.id != workflowId).toList();
    if (_ref.read(StateProvider<String?>((ref) => null)) == workflowId) {
      _ref.read(StateProvider<String?>((ref) => null).notifier).state = state.isNotEmpty ? state.first.id : null;
    }
  }

  /// Import a request as a workflow node
  void importRequestAsNode(String workflowId, String requestId, Offset position, Map<String, RequestModel> collection) {
    try {
      // Get the request from the collection
      final request = collection[requestId];
      if (request == null) {
        debugPrint('Request not found with ID: $requestId');
        return;
      }
      
      final node = WorkflowNodeModel.create(
        requestId: requestId,
        position: position,
        label: request.name.isNotEmpty ? request.name : 'Request ${requestId.substring(0, 4)}',
        requestModel: request,
      );
      
      addNode(workflowId, node);
    } catch (e) {
      debugPrint('Error importing node: $e');
    }
  }
}
