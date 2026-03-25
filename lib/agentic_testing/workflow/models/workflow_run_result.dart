class WorkflowRunResult {
  final String stepId;
  final String stepName;
  final int? statusCode;
  final int? expectedStatusCode;
  final bool passed;
  final Duration? duration;
  final Map<String, dynamic> extractedValues;
  final String? error;

  const WorkflowRunResult({
    required this.stepId,
    required this.stepName,
    this.statusCode,
    this.expectedStatusCode,
    required this.passed,
    this.duration,
    this.extractedValues = const {},
    this.error,
  });
}
