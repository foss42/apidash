enum WorkflowExecutionStatus {
  idle,
  running,
  paused,
  completed,
  error
}

class WorkflowExecutionState {
  final WorkflowExecutionStatus status;
  final String? errorMessage;

  const WorkflowExecutionState({
    this.status = WorkflowExecutionStatus.idle,
    this.errorMessage,
  });

  WorkflowExecutionState copyWith({
    WorkflowExecutionStatus? status,
    String? errorMessage,
  }) {
    return WorkflowExecutionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
