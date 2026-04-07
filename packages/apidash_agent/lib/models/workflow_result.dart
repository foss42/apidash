import 'test_case.dart';
import 'test_result.dart';
import 'workflow_step.dart';

class WorkflowStepResult {
  final WorkflowStep step;
  final int? actualStatusCode;
  final String? actualBody;
  final int durationMs;
  final List<AssertionResult> assertionResults;
  final TestStatus overallStatus;
  final Map<String, dynamic> extractedValues; // e.g. {"userId": 42}
  final String? errorMessage;

  WorkflowStepResult({
    required this.step,
    this.actualStatusCode,
    this.actualBody,
    required this.durationMs,
    required this.assertionResults,
    required this.overallStatus,
    required this.extractedValues,
    this.errorMessage,
  });
}

class WorkflowResult {
  final List<WorkflowStepResult> stepResults;
  final TestStatus overallStatus;
  final int totalDurationMs;

  WorkflowResult({
    required this.stepResults,
    required this.overallStatus,
    required this.totalDurationMs,
  });

  int get passedSteps =>
      stepResults.where((s) => s.overallStatus == TestStatus.passed).length;

  int get failedSteps =>
      stepResults.where((s) => s.overallStatus == TestStatus.failed).length;
}