import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_agent/apidash_agent.dart';
import 'package:apidash/providers/providers.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum AgentMode { unitTest, workflow }

enum AgentStatus { idle, generating, review, running, complete }

class AgentTestingState {
  static const Object _keepErrorMessage = Object();

  final AgentMode mode;
  final AgentStatus status;
  final String? errorMessage;

  // Unit test
  final List<TestCase> testCases;
  final List<TestResult> testResults;

  // Workflow
  final List<WorkflowStep> workflowSteps;
  final List<WorkflowStepResult> stepResults;

  const AgentTestingState({
    this.mode = AgentMode.unitTest,
    this.status = AgentStatus.idle,
    this.errorMessage,
    this.testCases = const [],
    this.testResults = const [],
    this.workflowSteps = const [],
    this.stepResults = const [],
  });

  AgentTestingState copyWith({
    AgentMode? mode,
    AgentStatus? status,
    Object? errorMessage = _keepErrorMessage,
    List<TestCase>? testCases,
    List<TestResult>? testResults,
    List<WorkflowStep>? workflowSteps,
    List<WorkflowStepResult>? stepResults,
  }) {
    return AgentTestingState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      errorMessage: errorMessage == _keepErrorMessage
          ? this.errorMessage
          : errorMessage as String?,
      testCases: testCases ?? this.testCases,
      testResults: testResults ?? this.testResults,
      workflowSteps: workflowSteps ?? this.workflowSteps,
      stepResults: stepResults ?? this.stepResults,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier — uses Notifier<T>, NOT StateNotifier (flutter_riverpod >= 2.0)
// ---------------------------------------------------------------------------

class AgentTestingNotifier extends Notifier<AgentTestingState> {
  @override
  AgentTestingState build() => const AgentTestingState();

  AIRequestModel? get _aiModel {
    final json = ref.read(settingsProvider).defaultAIModel;
    if (json == null) return null;
    try {
      return AIRequestModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  void setMode(AgentMode mode) =>
      state = state.copyWith(mode: mode, status: AgentStatus.idle);

  void reset() => state = AgentTestingState(mode: state.mode);

  // ── Unit Test Flow ────────────────────────────────────────────────────────

  Future<void> generateUnitTests({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) async {
    final model = _aiModel;
    if (model == null) {
      state = state.copyWith(
        errorMessage:
            'No AI model configured. Go to Settings -> Models and set a default model.',
      );
      return;
    }
    state = state.copyWith(
      status: AgentStatus.generating,
      errorMessage: null,
      testCases: [],
      testResults: [],
    );
    try {
      final agent = UnitTestAgent(aiRequestModel: model);
      final cases = await agent.generateTestCases(
        method: method,
        url: url,
        headers: headers,
        body: body,
      );
      state = state.copyWith(status: AgentStatus.review, testCases: cases);
    } catch (e) {
      state = state.copyWith(
        status: AgentStatus.idle,
        errorMessage: 'Generation failed: $e',
      );
    }
  }

  void toggleTestCase(String id) {
    final updated = state.testCases
        .map((tc) => tc.id == id ? tc.copyWith(isSelected: !tc.isSelected) : tc)
        .toList();
    state = state.copyWith(testCases: updated);
  }

  void selectAllTestCases(bool selected) {
    final updated = state.testCases
        .map((tc) => tc.copyWith(isSelected: selected))
        .toList();
    state = state.copyWith(testCases: updated);
  }

  Future<void> runSelectedTests() async {
    final model = _aiModel;
    if (model == null) {
      state = state.copyWith(
        errorMessage:
            'No AI model configured. Go to Settings -> Models and set a default model.',
      );
      return;
    }
    state = state.copyWith(
      status: AgentStatus.running,
      testResults: [],
      errorMessage: null,
    );
    try {
      final agent = UnitTestAgent(aiRequestModel: model);
      final results = await agent.runSelectedTests(state.testCases);
      state = state.copyWith(
        status: AgentStatus.complete,
        testResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        status: AgentStatus.review,
        errorMessage: 'Run failed: $e',
      );
    }
  }

  // ── Workflow Flow ─────────────────────────────────────────────────────────

  Future<void> generateWorkflow(List<Map<String, dynamic>> requests) async {
    final model = _aiModel;
    if (model == null) {
      state = state.copyWith(
        errorMessage:
            'No AI model configured. Go to Settings -> Models and set a default model.',
      );
      return;
    }
    state = state.copyWith(
      status: AgentStatus.generating,
      errorMessage: null,
      workflowSteps: [],
      stepResults: [],
    );
    try {
      final agent = WorkflowAgent(aiRequestModel: model);
      final steps = await agent.generatePlan(requests);
      state = state.copyWith(status: AgentStatus.review, workflowSteps: steps);
    } catch (e) {
      state = state.copyWith(
        status: AgentStatus.idle,
        errorMessage: 'Workflow generation failed: $e',
      );
    }
  }

  Future<void> executeWorkflow() async {
    final model = _aiModel;
    if (model == null) {
      state = state.copyWith(
        errorMessage:
            'No AI model configured. Go to Settings -> Models and set a default model.',
      );
      return;
    }
    state = state.copyWith(
      status: AgentStatus.running,
      stepResults: [],
      errorMessage: null,
    );
    try {
      final agent = WorkflowAgent(aiRequestModel: model);
      final results = <WorkflowStepResult>[];
      await for (final result in agent.execute(state.workflowSteps)) {
        results.add(result);
        // partial emit — UI updates live after each step
        state = state.copyWith(stepResults: List.from(results));
      }
      state = state.copyWith(status: AgentStatus.complete);
    } catch (e) {
      state = state.copyWith(
        status: AgentStatus.review,
        errorMessage: 'Execution failed: $e',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Provider — NotifierProvider (riverpod 2.x)
// ---------------------------------------------------------------------------

final agentTestingProvider =
    NotifierProvider<AgentTestingNotifier, AgentTestingState>(
      AgentTestingNotifier.new,
    );
