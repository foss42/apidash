import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/workflow_node_model.dart';
import '../models/workflow_connection_model.dart';
import '../models/workflow_model.dart';
import '../models/node_status.dart';

class WorkflowsNotifier extends StateNotifier<List<WorkflowModel>> {
  WorkflowsNotifier() : super([]);

  void addWorkflow(String name) {
    state = [
      ...state,
      WorkflowModel(
        id: const Uuid().v4(),
        name: name,
        nodes: [],
        connections: [],
      ),
    ];
  }

  void removeWorkflow(String id) {
    state = state.where((workflow) => workflow.id != id).toList();
  }

  void addNode(String workflowId, WorkflowNodeModel node) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(
          nodes: [...workflow.nodes, node],
        );
      }
      return workflow;
    }).toList();
  }

  // void removeNode(String nodeId) {
  //   state = state.map((workflow) {
  //     // Find the node to remove
  //     final nodeToRemove = workflow.nodes.firstWhere(
  //       (node) => node.id == nodeId,
  //       orElse: () => throw Exception('Node not found'),
  //     );

  //     // Remove any connections involving this node
  //     final updatedConnections = workflow.connections.where(
  //       (conn) => conn.sourceId != nodeId && conn.targetId != nodeId,
  //     ).toList();

  //     return workflow.copyWith(
  //       nodes: workflow.nodes.where((node) => node.id != nodeId).toList(),
  //       connections: updatedConnections,
  //     );
  //   }).toList();
  // }

  void updateNodePosition(String nodeId, Offset position) {
    state = state.map((workflow) {
      return workflow.copyWith(
        nodes: workflow.nodes.map((node) {
          if (node.id == nodeId) {
            return node.copyWith(position: position);
          }
          return node;
        }).toList(),
      );
    }).toList();
  }

  void selectNode(String nodeId) {
    // Implementation for selecting a node
    // This could update a selected node state or trigger an action
  }

  // void addConnection(String workflowId, String sourceId, String targetId) {
  //   if (sourceId == targetId) return; // Prevent self-connections

  //   state = state.map((workflow) {
  //     if (workflow.id == workflowId) {
  //       // Check if connection already exists
  //       final connectionExists = workflow.connections.any(
  //         (conn) => conn.sourceId == sourceId && conn.targetId == targetId,
  //       );

  //       if (!connectionExists) {
  //         final newConnection = WorkflowConnectionModel.create(
  //           sourceId: sourceId,
  //           targetId: targetId,
  //           workflowId: workflowId,
  //           position: Offset.zero, // This will be updated based on node positions
  //         );

  //         return workflow.copyWith(
  //           connections: [...workflow.connections, newConnection],
  //         );
  //       }
  //     }
  //     return workflow;
  //   }).toList();
  // }

  // void removeConnection(String connectionId) {
  //   state = state.map((workflow) {
  //     return workflow.copyWith(
  //       connections: workflow.connections.where((conn) => conn.id != connectionId).toList(),
  //     );
  //   }).toList();
  // }

  void updateNodeStatus(String nodeId, NodeStatus status) {
    state = state.map((workflow) {
      return workflow.copyWith(
        nodes: workflow.nodes.map((node) {
          if (node.id == nodeId) {
            return node.copyWith(status: status);
          }
          return node;
        }).toList(),
      );
    }).toList();
  }
}
