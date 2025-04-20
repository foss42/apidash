import 'dart:async';

import '../models/models.dart';

/// A more optimized execution engine that follows single responsibility principle
class WorkflowExecutor {
  final WorkflowModel workflow;
  final Function(String, NodeStatus) onNodeStatusChanged;
  final Function(WorkflowExecutionState) onExecutionStateChanged;
  
  WorkflowExecutionState _executionState;
  
  final Map<String, List<String>> _nodeDependencyMap = {};
  final Map<String, List<String>> _nodeOutgoingMap = {};
  
  // Stream control for execution commands
  final _executionController = StreamController<ExecutionCommand>.broadcast();
  StreamSubscription? _executionSubscription;
  Timer? _executionTimer;

  WorkflowExecutor({
    required this.workflow,
    required this.onNodeStatusChanged,
    required this.onExecutionStateChanged,
  }) : _executionState = const WorkflowExecutionState() {
    _initializeDependencyMaps();
    _setupExecutionListener();
  }

  void _initializeDependencyMaps() {
    // Clear existing maps
    _nodeDependencyMap.clear();
    _nodeOutgoingMap.clear();

    // Initialize empty lists for each node
    for (final node in workflow.nodes) {
      _nodeDependencyMap[node.id] = [];
      _nodeOutgoingMap[node.id] = [];
    }

    // Populate the dependency maps based on connections
    for (final connection in workflow.connections) {
      final sourceId = connection.sourceId;
      final targetId = connection.targetId;

      // Add the target as dependent on source
      if (_nodeDependencyMap.containsKey(targetId)) {
        _nodeDependencyMap[targetId]!.add(sourceId);
      }

      // Add target as outgoing from source
      if (_nodeOutgoingMap.containsKey(sourceId)) {
        _nodeOutgoingMap[sourceId]!.add(targetId);
      }
    }
  }

  /// Start the workflow execution
  void start() {
    if (_executionState.isRunning) return;

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

    _executeNextNodes();
  }

   void pause() {
    if (!_executionState.isRunning) return;

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.paused,
      ),
    );

    _cancelExecutionTimer();
  }

  void resume() {
    if (!_executionState.isPaused) return;

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.running,
      ),
    );

    _executeNextNodes();
  }

  void stop() {
    _cancelExecutionTimer();

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.idle,
        currentNodeId: null,
      ),
    );
  }

  void reset() {
    _resetExecutionState();
  }

  void _resetExecutionState() {
    _updateExecutionState(const WorkflowExecutionState());
  }

  List<WorkflowNodeModel> _findInitialNodes() {
    return workflow.nodes.where((node) {
      return _nodeDependencyMap[node.id]?.isEmpty ?? true;
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
          reset();
          break;
      }
    });
  }

  void _executeNextNodes() {
    if (!_executionState.isRunning) return;

    final pendingNodeIds = List<String>.from(_executionState.pendingNodeIds);
    if (pendingNodeIds.isEmpty) {
      _completeExecution();
      return;
    }

    final nodeId = pendingNodeIds.first;
    pendingNodeIds.removeAt(0);

    final node = workflow.nodes.firstWhere(
      (n) => n.id == nodeId,
      orElse: () => throw StateError('Node not found: $nodeId in WorkflowExecutor._executeNextNodes'),
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
      final success = _executeNode(node);
      final newStatus = success ? NodeStatus.success : NodeStatus.failure;

      onNodeStatusChanged(nodeId, newStatus);

      final updatedResults = Map<String, dynamic>.from(_executionState.executionResults);
      updatedResults[nodeId] = {
        'status': success ? 'success' : 'failure',
        'timestamp': DateTime.now().toIso8601String(),
        'data': {'message': 'Executed ${node.label}'},
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

  bool _executeNode(WorkflowNodeModel node) {
    switch (node.nodeType) {
      case NodeType.request:
        return true;
      case NodeType.condition:
        return true;
      case NodeType.action:
        return true;
      default:
        return true;
    }
  }

  void _scheduleNextExecution() {
    _executionTimer = Timer(const Duration(milliseconds: 100), _executeNextNodes);
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
