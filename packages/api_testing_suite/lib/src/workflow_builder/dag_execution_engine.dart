import 'dart:async';

import 'package:flutter/foundation.dart';
import 'models/workflow_model.dart';
import 'models/workflow_node_model.dart';
import 'models/node_status.dart';
import 'models/workflow_execution_state.dart';

/// A class that handles the execution of a workflow DAG
class DagExecutionEngine {

  final WorkflowModel workflow;
  final Function(String, NodeStatus) onNodeStatusChanged;
  final Function(WorkflowExecutionState) onExecutionStateChanged;
  WorkflowExecutionState _executionState;
  late Map<String, List<String>> _nodeDependencyMap;
  late Map<String, List<String>> _nodeOutgoingMap;
  final _executionController = StreamController<ExecutionCommand>.broadcast();
  StreamSubscription? _executionSubscription;
  Timer? _executionTimer;

  DagExecutionEngine({
    required this.workflow,
    required this.onNodeStatusChanged,
    required this.onExecutionStateChanged,
  }) : _executionState = const WorkflowExecutionState() {
    _initializeDependencyMaps();
  }

  void _initializeDependencyMaps() {
    _nodeDependencyMap = {};
    _nodeOutgoingMap = {};

    for (final node in workflow.nodes) {
      _nodeDependencyMap[node.id] = [];
      _nodeOutgoingMap[node.id] = [];
    }

    for (final connection in workflow.connections) {
      final sourceId = connection.sourceId;
      final targetId = connection.targetId;

      if (_nodeDependencyMap.containsKey(targetId)) {
        _nodeDependencyMap[targetId]!.add(sourceId);
      }

      if (_nodeOutgoingMap.containsKey(sourceId)) {
        _nodeOutgoingMap[sourceId]!.add(targetId);
      }
    }
  }

  void start() {
    if (_executionState.isRunning) {
      return; 
    }

    if (_executionState.isCompleted || _executionState.hasError) {
      _resetExecutionState();
    }

    final initialNodes = _findInitialNodes();
    if (initialNodes.isEmpty) {
      _updateExecutionState(
        _executionState.copyWith(
          status: WorkflowExecutionStatus.error,
          errorMessage: 'No starting nodes found in the workflow',
        ),
      );
      return;
    }

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.running,
        startTime: DateTime.now(),
        pendingNodeIds: initialNodes.map((node) => node.id).toList(),
      ),
    );

    _setupExecutionListener();
    _executeNextNodes();
  }

  void pause() {
    if (!_executionState.isRunning) {
      return;
    }

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.paused,
      ),
    );

    _cancelExecutionTimer();
  }

  void resume() {
    if (!_executionState.isPaused) {
      return;
    }

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.running,
      ),
    );

    _executeNextNodes();
  }

  void stop() {
    _cancelExecutionSubscription();
    _cancelExecutionTimer();

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.idle,
        currentNodeId: null,
      ),
    );
  }

  void _resetExecutionState() {
    _updateExecutionState(
      const WorkflowExecutionState(),
    );
  }

  List<WorkflowNodeModel> _findInitialNodes() {
    return workflow.nodes.where((node) {
      return _nodeDependencyMap[node.id]!.isEmpty;
    }).toList();
  }

  void _setupExecutionListener() {
    _cancelExecutionSubscription();

    _executionSubscription = _executionController.stream.listen((command) {
      switch (command) {
        case ExecutionCommand.start:
          start();
          break;
        case ExecutionCommand.pause:
          pause();
          break;
        case ExecutionCommand.resume:
          resume();
          break;
        case ExecutionCommand.stop:
          stop();
          break;
        case ExecutionCommand.reset:
          _resetExecutionState();
          break;
      }
    });
  }

  void _executeNextNodes() {
    if (!_executionState.isRunning) {
      return;
    }

    final pendingNodeIds = List<String>.from(_executionState.pendingNodeIds);
    if (pendingNodeIds.isEmpty) {
      _completeExecution();
      return;
    }

    final nodeId = pendingNodeIds.first;
    pendingNodeIds.removeAt(0);

    final node = workflow.nodes.firstWhere(
      (n) => n.id == nodeId,
      orElse: () => throw Exception('Node not found: $nodeId'),
    );

    final dependencies = _nodeDependencyMap[nodeId] ?? [];
    final allDependenciesMet = dependencies.every(
      (depId) => _executionState.executedNodeIds.contains(depId),
    );

    if (!allDependenciesMet) {
      pendingNodeIds.add(nodeId);

      _updateExecutionState(
        _executionState.copyWith(
          pendingNodeIds: pendingNodeIds,
        ),
      );

      _scheduleNextExecution();
      return;
    }

    _updateExecutionState(
      _executionState.copyWith(
        currentNodeId: nodeId,
        pendingNodeIds: pendingNodeIds,
      ),
    );

    onNodeStatusChanged(nodeId, NodeStatus.running);

    _executionTimer = Timer(const Duration(milliseconds: 500), () {

      final success = true;
      final newStatus = success ? NodeStatus.success : NodeStatus.failure;

      onNodeStatusChanged(nodeId, newStatus);

      final updatedResults =
          Map<String, dynamic>.from(_executionState.executionResults);
      updatedResults[nodeId] = {
        'status': success ? 'success' : 'failure',
        'timestamp': DateTime.now().toIso8601String(),
        'data': {'message': 'Simulated ${success ? 'success' : 'failure'}'},
      };

      final nextNodeIds = _nodeOutgoingMap[nodeId] ?? [];
      final updatedPendingIds = List<String>.from(pendingNodeIds);

      for (final nextNodeId in nextNodeIds) {
        if (!updatedPendingIds.contains(nextNodeId) &&
            !_executionState.executedNodeIds.contains(nextNodeId)) {
          updatedPendingIds.add(nextNodeId);
        }
      }

      _updateExecutionState(
        _executionState.copyWith(
          currentNodeId: null,
          executedNodeIds: [..._executionState.executedNodeIds, nodeId],
          pendingNodeIds: updatedPendingIds,
          executionResults: updatedResults,
        ),
      );

      if (updatedPendingIds.isNotEmpty) {
        _scheduleNextExecution();
      } else {
        _completeExecution();
      }
    });
  }
  void _scheduleNextExecution() {
    _executionTimer =
        Timer(const Duration(milliseconds: 100), _executeNextNodes);
  }

  void _completeExecution() {
    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.completed,
        endTime: DateTime.now(),
      ),
    );
  }

  void _updateExecutionState(WorkflowExecutionState newState) {
    _executionState = newState;
    onExecutionStateChanged(newState);
  }

  void _cancelExecutionTimer() {
    _executionTimer?.cancel();
    _executionTimer = null;
  }

  void _cancelExecutionSubscription() {
    _executionSubscription?.cancel();
    _executionSubscription = null;
  }

  void dispose() {
    _cancelExecutionSubscription();
    _cancelExecutionTimer();
    _executionController.close();
  }
}

enum ExecutionCommand {
  start,
  pause,
  resume,
  stop,
  reset,
}
