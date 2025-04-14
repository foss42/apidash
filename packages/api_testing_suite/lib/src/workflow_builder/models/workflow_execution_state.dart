enum WorkflowExecutionStatus { idle, running, paused, completed, error }

class WorkflowExecutionState {
  final WorkflowExecutionStatus status;
  final String? errorMessage;
  final String? currentNodeId;
  final List<String> executedNodeIds;
  final List<String> pendingNodeIds;
  final Map<String, dynamic> executionResults;
  final Map<String, dynamic> executionContext;
  final DateTime? startTime;
  final DateTime? endTime;

  const WorkflowExecutionState({
    this.status = WorkflowExecutionStatus.idle,
    this.errorMessage,
    this.currentNodeId,
    this.executedNodeIds = const [],
    this.pendingNodeIds = const [],
    this.executionResults = const {},
    this.executionContext = const {},
    this.startTime,
    this.endTime,
  });

  WorkflowExecutionState copyWith({
    WorkflowExecutionStatus? status,
    String? errorMessage,
    String? currentNodeId,
    List<String>? executedNodeIds,
    List<String>? pendingNodeIds,
    Map<String, dynamic>? executionResults,
    Map<String, dynamic>? executionContext,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return WorkflowExecutionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentNodeId: currentNodeId ?? this.currentNodeId,
      executedNodeIds: executedNodeIds ?? this.executedNodeIds,
      pendingNodeIds: pendingNodeIds ?? this.pendingNodeIds,
      executionResults: executionResults ?? this.executionResults,
      executionContext: executionContext ?? this.executionContext,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  bool get isRunning => status == WorkflowExecutionStatus.running;
  bool get isPaused => status == WorkflowExecutionStatus.paused;
  bool get isCompleted => status == WorkflowExecutionStatus.completed;
  bool get hasError => status == WorkflowExecutionStatus.error;
  bool get isIdle => status == WorkflowExecutionStatus.idle;
}
