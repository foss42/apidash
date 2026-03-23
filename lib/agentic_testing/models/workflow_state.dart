enum AgenticWorkflowState { idle, generating, awaitingApproval }

extension AgenticWorkflowStateLabel on AgenticWorkflowState {
  String get label {
    switch (this) {
      case AgenticWorkflowState.idle:
        return 'IDLE';
      case AgenticWorkflowState.generating:
        return 'GENERATING';
      case AgenticWorkflowState.awaitingApproval:
        return 'AWAITING_APPROVAL';
    }
  }
}
