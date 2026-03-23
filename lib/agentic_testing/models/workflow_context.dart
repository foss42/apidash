import 'test_case_model.dart';
import 'workflow_state.dart';

class AgenticWorkflowContext {
  const AgenticWorkflowContext({
    this.workflowState = AgenticWorkflowState.idle,
    this.endpoint = '',
    this.generatedTests = const <AgenticTestCase>[],
    this.statusMessage,
    this.errorMessage,
  });

  final AgenticWorkflowState workflowState;
  final String endpoint;
  final List<AgenticTestCase> generatedTests;
  final String? statusMessage;
  final String? errorMessage;

  int get approvedCount => generatedTests
      .where((testCase) => testCase.decision == TestReviewDecision.approved)
      .length;

  int get rejectedCount => generatedTests
      .where((testCase) => testCase.decision == TestReviewDecision.rejected)
      .length;

  int get pendingCount => generatedTests
      .where((testCase) => testCase.decision == TestReviewDecision.pending)
      .length;

  AgenticWorkflowContext copyWith({
    AgenticWorkflowState? workflowState,
    String? endpoint,
    List<AgenticTestCase>? generatedTests,
    String? statusMessage,
    bool clearStatusMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AgenticWorkflowContext(
      workflowState: workflowState ?? this.workflowState,
      endpoint: endpoint ?? this.endpoint,
      generatedTests: generatedTests ?? this.generatedTests,
      statusMessage: clearStatusMessage
          ? null
          : (statusMessage ?? this.statusMessage),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
