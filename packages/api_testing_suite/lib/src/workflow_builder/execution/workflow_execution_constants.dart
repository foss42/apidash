class WorkflowExecutionConstants {
  // Execution timing
  static const Duration nodeExecutionDelay = Duration(milliseconds: 500);
  static const Duration nextNodeScheduleDelay = Duration(milliseconds: 100);
  
  // Node execution result keys
  static const String resultStatusKey = 'status';
  static const String resultTimestampKey = 'timestamp';
  static const String resultDataKey = 'data';
  static const String resultMessageKey = 'message';
  
  // Status values
  static const String statusSuccess = 'success';
  static const String statusFailure = 'failure';
  
  // Error messages
  static const String errorNoStartingNodes = 'No starting nodes found in the workflow';
  static const String errorNodeNotFound = 'Node not found in the workflow';
}
