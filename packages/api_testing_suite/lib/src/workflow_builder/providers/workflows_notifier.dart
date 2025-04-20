import 'dart:async';

import 'package:api_testing_suite/api_testing_suite.dart';
import 'package:apidash_core/models/http_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class WorkflowsNotifier extends StateNotifier<List<WorkflowModel>> {
  final Map<String, WorkflowExecutor> _executionEngines = {};
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
    WorkflowNodeModel nodeToSave = updatedNode;
    if (updatedNode.nodeType == NodeType.request) {
      final nodeData = updatedNode.nodeData;
      final url = nodeData['url'] ?? '';
      final method = nodeData['method'] ?? 'GET';
      if (updatedNode.requestModel != null) {
        nodeToSave = updatedNode.copyWith(
          requestModel: updatedNode.requestModel!.copyWith(
            url: url,
            method: method,
          ),
        );
      } else {
        nodeToSave = updatedNode.copyWith(
          requestModel: RequestModel(
            id: updatedNode.id,
            name: updatedNode.label,
            method: method,
            url: url,
            httpRequestModel: HttpRequestModel(),
          ),
        );
      }
    }

    state = state.map((workflow) {
      if (workflow.id == workflowId) {
        return workflow.copyWith(
          nodes: workflow.nodes.map((node) {
            return node.id == updatedNode.id ? nodeToSave : node;
          }).toList(),
        );
      }
      return workflow;
    }).toList();
    print('Updated node: ${nodeToSave.id} | nodeData: ${nodeToSave.nodeData} | requestModel: ${nodeToSave.requestModel}');
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
    try {
      return state.firstWhere(
        (workflow) => workflow.id == workflowId,
      );
    } on StateError {
      throw StateError('Workflow not found: $workflowId in getWorkflow');
    }
  }

  void startExecution(
      String workflowId, Function(WorkflowExecutionState) onStateChanged) {
    final engine = _getOrCreateExecutionEngine(workflowId, onStateChanged: onStateChanged);
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

  WorkflowExecutor? _getOrCreateExecutionEngine(String workflowId, {Function(WorkflowExecutionState)? onStateChanged}) {
    if (_executionEngines.containsKey(workflowId)) {
      return _executionEngines[workflowId];
    }

    final workflow = getWorkflow(workflowId);
    if (workflow == null) return null;

    final engine = WorkflowExecutor(
      workflow: workflow,
      onNodeStatusChanged: (nodeId, status) =>
          updateNodeStatus(workflowId, nodeId, status),
      onExecutionStateChanged: (state) {
        setActiveNodes(workflowId, state.pendingNodeIds);
        setCompletedNodes(workflowId, state.executedNodeIds);
        if (onStateChanged != null) {
          onStateChanged(state);
        }
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
