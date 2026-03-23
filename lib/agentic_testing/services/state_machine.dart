import 'package:flutter_riverpod/legacy.dart';

import '../models/test_case_model.dart';
import '../models/workflow_context.dart';
import '../models/workflow_state.dart';
import 'test_generator.dart';

class InvalidWorkflowTransitionException implements Exception {
  const InvalidWorkflowTransitionException(this.from, this.to);

  final AgenticWorkflowState from;
  final AgenticWorkflowState to;

  @override
  String toString() {
    return 'Invalid transition from ${from.label} to ${to.label}';
  }
}

class AgenticTestingStateMachine extends StateNotifier<AgenticWorkflowContext> {
  AgenticTestingStateMachine({
    required AgenticTestGenerator testGenerator,
  })  : _testGenerator = testGenerator,
        super(const AgenticWorkflowContext());

  final AgenticTestGenerator _testGenerator;

  static const Map<AgenticWorkflowState, Set<AgenticWorkflowState>>
      _allowedTransitions = {
    AgenticWorkflowState.idle: {
      AgenticWorkflowState.generating,
    },
    AgenticWorkflowState.generating: {
      AgenticWorkflowState.awaitingApproval,
      AgenticWorkflowState.idle,
    },
    AgenticWorkflowState.awaitingApproval: {
      AgenticWorkflowState.idle,
    },
  };

  Future<void> startGeneration({
    required String endpoint,
    String? method,
    Map<String, String>? headers,
    String? requestBody,
  }) async {
    final normalizedEndpoint = endpoint.trim();
    if (normalizedEndpoint.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please provide an endpoint before generating tests.',
        clearStatusMessage: true,
      );
      return;
    }

    if (state.workflowState != AgenticWorkflowState.idle) {
      state = state.copyWith(
        errorMessage:
            'Cannot start generation while state is ${state.workflowState.label}.',
      );
      return;
    }

    _transitionTo(
      AgenticWorkflowState.generating,
      endpoint: normalizedEndpoint,
      generatedTests: const <AgenticTestCase>[],
      statusMessage: 'Generating test cases...',
      clearErrorMessage: true,
    );

    try {
      final tests = await _testGenerator.generateTests(
        endpoint: normalizedEndpoint,
        method: method,
        headers: headers,
        requestBody: requestBody,
      );

      _transitionTo(
        AgenticWorkflowState.awaitingApproval,
        generatedTests: tests,
        statusMessage:
            'Generated ${tests.length} test cases. Review and approve/reject.',
        clearErrorMessage: true,
      );
    } catch (e) {
      _transitionTo(
        AgenticWorkflowState.idle,
        generatedTests: const <AgenticTestCase>[],
        errorMessage: 'Failed to generate tests: $e',
        clearStatusMessage: true,
      );
    }
  }

  void approveTest(String testId) {
    _setDecision(testId, TestReviewDecision.approved);
  }

  void rejectTest(String testId) {
    _setDecision(testId, TestReviewDecision.rejected);
  }

  void approveAll() {
    if (!_requireState(AgenticWorkflowState.awaitingApproval)) {
      return;
    }
    final reviewedTests = state.generatedTests
        .map(
          (testCase) =>
              testCase.copyWith(decision: TestReviewDecision.approved),
        )
        .toList();
    _completeReview(
      reviewedTests,
      statusMessage: 'Approved ${reviewedTests.length} test cases.',
    );
  }

  void rejectAll() {
    if (!_requireState(AgenticWorkflowState.awaitingApproval)) {
      return;
    }
    final reviewedTests = state.generatedTests
        .map(
          (testCase) =>
              testCase.copyWith(decision: TestReviewDecision.rejected),
        )
        .toList();
    _completeReview(
      reviewedTests,
      statusMessage: 'Rejected ${reviewedTests.length} test cases.',
    );
  }

  void reset() {
    if (state.workflowState == AgenticWorkflowState.generating) {
      return;
    }
    if (state.workflowState == AgenticWorkflowState.awaitingApproval) {
      _transitionTo(
        AgenticWorkflowState.idle,
        generatedTests: const <AgenticTestCase>[],
        statusMessage: 'Review reset. Ready to generate again.',
        clearErrorMessage: true,
      );
      return;
    }
    state = const AgenticWorkflowContext();
  }

  void _completeReview(
    List<AgenticTestCase> reviewedTests, {
    required String statusMessage,
  }) {
    _transitionTo(
      AgenticWorkflowState.idle,
      generatedTests: reviewedTests,
      statusMessage: statusMessage,
      clearErrorMessage: true,
    );
  }

  void _setDecision(String testId, TestReviewDecision decision) {
    if (!_requireState(AgenticWorkflowState.awaitingApproval)) {
      return;
    }
    final updatedTests = state.generatedTests.map((testCase) {
      if (testCase.id != testId) {
        return testCase;
      }
      return testCase.copyWith(decision: decision);
    }).toList();
    state = state.copyWith(
      generatedTests: updatedTests,
      statusMessage:
          'Reviewed ${updatedTests.length - _pendingCount(updatedTests)} of ${updatedTests.length} tests.',
      clearErrorMessage: true,
    );
  }

  int _pendingCount(List<AgenticTestCase> tests) {
    return tests
        .where((testCase) => testCase.decision == TestReviewDecision.pending)
        .length;
  }

  bool _requireState(AgenticWorkflowState expected) {
    if (state.workflowState != expected) {
      state = state.copyWith(
        errorMessage:
            'Invalid action for current state ${state.workflowState.label}.',
      );
      return false;
    }
    return true;
  }

  void _transitionTo(
    AgenticWorkflowState nextState, {
    String? endpoint,
    List<AgenticTestCase>? generatedTests,
    String? statusMessage,
    bool clearStatusMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    final current = state.workflowState;
    if (current != nextState) {
      final allowed = _allowedTransitions[current] ?? const {};
      if (!allowed.contains(nextState)) {
        throw InvalidWorkflowTransitionException(current, nextState);
      }
    }

    state = state.copyWith(
      workflowState: nextState,
      endpoint: endpoint,
      generatedTests: generatedTests,
      statusMessage: statusMessage,
      clearStatusMessage: clearStatusMessage,
      errorMessage: errorMessage,
      clearErrorMessage: clearErrorMessage,
    );
  }
}
