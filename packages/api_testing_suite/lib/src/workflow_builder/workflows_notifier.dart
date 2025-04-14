import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/workflow_node_model.dart';
import 'models/workflow_connection_model.dart';
import 'models/workflow_model.dart';
import 'models/node_status.dart';
import 'models/workflow_execution_state.dart';
import 'dag_execution_engine.dart';

class WorkflowsNotifier extends StateNotifier<List<WorkflowModel>> {
  final Map<String, DagExecutionEngine> _executionEngines = {};
  Timer? _debounceTimer;

  WorkflowsNotifier() : super([]);

  String createWorkflow({String? name, String? description}) {
    final newWorkflow = WorkflowModel.create(
      name: name ?? 'New Workflow',
      description: description ?? '',
    );

    state = [...state, newWorkflow];
    return newWorkflow.id;
  }

  void updateWorkflow(WorkflowModel updatedWorkflow) {
    state = [
      for (final workflow in state)
        if (workflow.id == updatedWorkflow.id) updatedWorkflow else workflow,
    ];
  }

  void deleteWorkflow(String workflowId) {
    _executionEngines[workflowId]?.dispose();
    _executionEngines.remove(workflowId);

    state = state.where((workflow) => workflow.id != workflowId).toList();
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

  void updateNode(String workflowId, WorkflowNodeModel updatedNode) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(
          nodes: workflow.nodes.map((node) {
            return node.id == updatedNode.id ? updatedNode : node;
          }).toList(),
        );
      }
      return workflow;
    }).toList();
  }

  void updateNodeStatus(String workflowId, String nodeId, NodeStatus status) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(
          nodes: workflow.nodes.map((node) {
            return node.id == nodeId ? node.copyWith(status: status) : node;
          }).toList(),
        );
      }
      return workflow;
    }).toList();
  }

  void updateNodePosition(String workflowId, String nodeId, Offset position) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 50), () {
      state = state.map((workflow) {
        if (workflow.id == workflowId) {
          return workflow.copyWith(
            nodes: workflow.nodes.map((node) {
              return node.id == nodeId
                  ? node.copyWith(position: position)
                  : node;
            }).toList(),
          );
        }
        return workflow;
      }).toList();
    });
  }

  void removeNode(String workflowId, String nodeId) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(
          nodes: workflow.nodes.where((node) => node.id != nodeId).toList(),
          connections: workflow.connections
              .where(
                  (conn) => conn.sourceId != nodeId && conn.targetId != nodeId)
              .toList(),
        );
      }
      return workflow;
    }).toList();
  }

  void selectNode(String workflowId, String? nodeId) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(selectedNodeId: nodeId);
      }
      return workflow;
    }).toList();
  }

  void createConnection(String workflowId, String sourceId, String targetId) {
    if (sourceId == targetId) return;

    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        final connectionExists = workflow.connections.any(
          (conn) => conn.sourceId == sourceId && conn.targetId == targetId,
        );

        if (!connectionExists) {
          final newConnection = WorkflowConnectionModel.create(
            sourceId: sourceId,
            targetId: targetId,
            workflowId: workflowId,
            position: Offset.zero,
          );

          return workflow.copyWith(
            connections: [...workflow.connections, newConnection],
          );
        }
      }
      return workflow;
    }).toList();

    _resetExecutionEngine(workflowId);
  }

  void removeConnection(String workflowId, String connectionId) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(
          connections: workflow.connections
              .where((conn) => conn.id != connectionId)
              .toList(),
        );
      }
      return workflow;
    }).toList();

    _resetExecutionEngine(workflowId);
  }

  void setActiveNodes(String workflowId, List<String> nodeIds) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(activeNodeIds: nodeIds);
      }
      return workflow;
    }).toList();
  }

  void setCompletedNodes(String workflowId, List<String> nodeIds) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(completedNodeIds: nodeIds);
      }
      return workflow;
    }).toList();
  }

  void setStartNode(String workflowId, String? nodeId) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(startNodeId: nodeId);
      }
      return workflow;
    }).toList();
  }

  WorkflowModel? getWorkflow(String workflowId) {
    return state.firstWhere(
      (workflow) => workflow.id == workflowId,
      orElse: () => throw Exception('Workflow not found: $workflowId'),
    );
  }

  void startExecution(
      String workflowId, Function(WorkflowExecutionState) onStateChanged) {
    final engine = _getOrCreateExecutionEngine(workflowId);
    if (engine != null) {
      engine.start();
    }
  }

  void pauseExecution(String workflowId) {
    final engine = _executionEngines[workflowId];
    engine?.pause();
  }

  void resumeExecution(String workflowId) {
    final engine = _executionEngines[workflowId];
    engine?.resume();
  }

  void stopExecution(String workflowId) {
    final engine = _executionEngines[workflowId];
    engine?.stop();
  }

  DagExecutionEngine? _getOrCreateExecutionEngine(String workflowId) {
    if (_executionEngines.containsKey(workflowId)) {
      return _executionEngines[workflowId];
    }

    final workflow = getWorkflow(workflowId);
    if (workflow == null) return null;

    final engine = DagExecutionEngine(
      workflow: workflow,
      onNodeStatusChanged: (nodeId, status) =>
          updateNodeStatus(workflowId, nodeId, status),
      onExecutionStateChanged: (state) {
        setActiveNodes(workflowId, state.pendingNodeIds);
        setCompletedNodes(workflowId, state.executedNodeIds);
      },
    );

    _executionEngines[workflowId] = engine;
    return engine;
  }

  void _resetExecutionEngine(String workflowId) {
    _executionEngines[workflowId]?.dispose();
    _executionEngines.remove(workflowId);
  }

  void startNodeDrag(String workflowId, String nodeId, Offset position) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(
          nodes: workflow.nodes.map((node) {
            return node.id == nodeId 
                ? node.copyWith(
                    position: position,
                    isDragging: true,
                  )
                : node.copyWith(
                    isDragging: false,
                  );
          }).toList(),
        );
      }
      return workflow;
    }).toList();
  }

  void updateNodeDrag(String workflowId, String nodeId, Offset position) {
    updateNodePosition(workflowId, nodeId, position);
  }

  void finishNodeDrag(String workflowId, String nodeId) {
    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(
          nodes: workflow.nodes.map((node) {
            return node.id == nodeId 
                ? node.copyWith(
                    isDragging: false,
                  )
                : node;
          }).toList(),
        );
      }
      return workflow;
    }).toList();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();

    for (final engine in _executionEngines.values) {
      engine.dispose();
    }
    _executionEngines.clear();

    super.dispose();
  }
}
