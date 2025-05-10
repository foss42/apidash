import 'dart:async';

import 'package:api_testing_suite/src/common/utils/error_handler.dart';
import 'package:api_testing_suite/src/common/utils/logger.dart';
import 'workflow_execution_constants.dart';
import '../models/models.dart';

/// Executes workflows by processing nodes in dependency order
///
/// The WorkflowExecutor is responsible for managing the execution state
/// of a workflow, tracking dependencies between nodes, and executing
/// nodes in the correct order.
class WorkflowExecutor {
  final WorkflowModel workflow;
  
  final Function(String, NodeStatus) onNodeStatusChanged;
  final Function(WorkflowExecutionState) onExecutionStateChanged;
  WorkflowExecutionState _executionState;
  final Map<String, List<String>> _nodeDependencyMap = {};
  final Map<String, List<String>> _nodeOutgoingMap = {};
  
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
    _nodeDependencyMap.clear();
    _nodeOutgoingMap.clear();

    for (final node in workflow.nodes) {
      _nodeDependencyMap[node.id] = [];
      _nodeOutgoingMap[node.id] = [];
    }

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
    
    ApiTestLogger.debug('Initialized dependency maps for workflow ${workflow.id}');
  }

  /// Starts the workflow execution
  ///
  /// If the workflow is already running, this method does nothing.
  /// If the workflow has completed or encountered an error, it is reset first.
  void start() {
    if (_executionState.isRunning) {
      ApiTestLogger.debug('Workflow already running, ignoring start command');
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
          errorMessage: WorkflowExecutionConstants.errorNoStartingNodes,
        ),
      );
      ApiTestLogger.error('Cannot start workflow: no starting nodes found');
      return;
    }

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.running,
        startTime: DateTime.now(),
        pendingNodeIds: initialNodes.map((node) => node.id).toList(),
      ),
    );
    
    ApiTestLogger.info('Started workflow execution with ${initialNodes.length} initial nodes');
    _executeNextNodes();
  }

  void pause() {
    if (!_executionState.isRunning) {
      ApiTestLogger.debug('Workflow not running, ignoring pause command');
      return;
    }

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.paused,
      ),
    );

    _cancelExecutionTimer();
    ApiTestLogger.info('Paused workflow execution');
  }

  /// Resumes a paused workflow execution
  ///
  /// If the workflow is not paused, this method does nothing.
  void resume() {
    if (!_executionState.isPaused) {
      ApiTestLogger.debug('Workflow not paused, ignoring resume command');
      return;
    }

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.running,
      ),
    );

    ApiTestLogger.info('Resumed workflow execution');
    _executeNextNodes();
  }

  /// Stops the workflow execution
  ///
  /// This cancels any pending executions and resets the current node.
  void stop() {
    _cancelExecutionTimer();

    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.idle,
        currentNodeId: null,
      ),
    );
    
    ApiTestLogger.info('Stopped workflow execution');
  }

  void reset() {
    _resetExecutionState();
    ApiTestLogger.info('Reset workflow execution state');
  }

  void _resetExecutionState() {
    _updateExecutionState(const WorkflowExecutionState());
  }

  /// Finds nodes that have no dependencies
  ///
  /// These nodes can be used as starting points for execution.
  List<WorkflowNodeModel> _findInitialNodes() {
    return workflow.nodes.where((node) {
      return _nodeDependencyMap[node.id]?.isEmpty ?? true;
    }).toList();
  }

  void _setupExecutionListener() {
    _cancelExecutionSubscription();

    _executionSubscription = _executionController.stream.listen((command) {
      ApiTestLogger.debug('Received execution command: $command');
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

    final node = ErrorHandler.execute<WorkflowNodeModel>('finding node for execution', () {
      return workflow.nodes.firstWhere(
        (n) => n.id == nodeId,
        orElse: () => throw StateError('${WorkflowExecutionConstants.errorNodeNotFound}: $nodeId'),
      );
    });
    
    if (node == null) {
      ApiTestLogger.error('Failed to execute node: $nodeId - node not found');
      _updateExecutionState(
        _executionState.copyWith(
          status: WorkflowExecutionStatus.error,
          errorMessage: '${WorkflowExecutionConstants.errorNodeNotFound}: $nodeId',
        ),
      );
      return;
    }

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
    ApiTestLogger.debug('Executing node: ${node.label} (ID: $nodeId)');

    _executionTimer = Timer(WorkflowExecutionConstants.nodeExecutionDelay, () {
      final success = _executeNode(node);
      final newStatus = success ? NodeStatus.success : NodeStatus.failure;

      onNodeStatusChanged(nodeId, newStatus);
      ApiTestLogger.debug('Node execution ${success ? "succeeded" : "failed"}: ${node.label}');

      final updatedResults = Map<String, dynamic>.from(_executionState.executionResults);
      updatedResults[nodeId] = {
        WorkflowExecutionConstants.resultStatusKey: 
            success ? WorkflowExecutionConstants.statusSuccess : WorkflowExecutionConstants.statusFailure,
        WorkflowExecutionConstants.resultTimestampKey: DateTime.now().toIso8601String(),
        WorkflowExecutionConstants.resultDataKey: {
          WorkflowExecutionConstants.resultMessageKey: 'Executed ${node.label}'
        },
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

  /// Executes a single node and returns whether execution was successful
  ///
  /// The implementation of this method will vary based on the node type.
  bool _executeNode(WorkflowNodeModel node) {
    try {
      ApiTestLogger.debug('Processing node of type: ${node.nodeType}');
      switch (node.nodeType) {
        case NodeType.request:
          return true;
        case NodeType.condition:
          return true;
        case NodeType.action:
          return true;// TODO: implement action execution
        default:
          ApiTestLogger.warning('Unknown node type: ${node.nodeType}');
          return true;// TODO: handle unknown node types
      }
    } catch (e) {
      ApiTestLogger.error('Error executing node ${node.id}', e);
      return false;
    }
  }

  void _scheduleNextExecution() {
    _executionTimer = Timer(
      WorkflowExecutionConstants.nextNodeScheduleDelay, 
      _executeNextNodes
    );
  }

  void _completeExecution() {
    _updateExecutionState(
      _executionState.copyWith(
        status: WorkflowExecutionStatus.completed,
        endTime: DateTime.now(),
      ),
    );
    ApiTestLogger.info('Workflow execution completed successfully');
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
    ApiTestLogger.debug('Disposed workflow executor');
  }
}
