import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_agent/apidash_agent.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum AgentMode { unitTest, workflow }

enum AgentStatus { idle, generating, review, running, complete }

class AgentTestingState {
  static const Object _keepErrorMessage = Object();

  final AgentMode mode;
  final AgentStatus status;
  final String apiKey;
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
    this.apiKey = '',
    this.errorMessage,
    this.testCases = const [],
    this.testResults = const [],
    this.workflowSteps = const [],
    this.stepResults = const [],
  });

  AgentTestingState copyWith({
    AgentMode? mode,
    AgentStatus? status,
    String? apiKey,
    Object? errorMessage = _keepErrorMessage,
    List<TestCase>? testCases,
    List<TestResult>? testResults,
    List<WorkflowStep>? workflowSteps,
    List<WorkflowStepResult>? stepResults,
  }) {
    return AgentTestingState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      apiKey: apiKey ?? this.apiKey,
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
  static const _apiKeyPrefsKey = 'agent_api_key';

  @override
  AgentTestingState build() {
    Future.microtask(_loadSavedApiKey);
    return const AgentTestingState();
  }

  // Builds AIRequestModel from the stored API key (Gemini provider)
  AIRequestModel get _aiModel => AIRequestModel(
      modelApiProvider: ModelAPIProvider.gemini,
      model: 'gemini-2.5-flash-lite',
        apiKey: state.apiKey,
      );

  void setMode(AgentMode mode) =>
      state = state.copyWith(mode: mode, status: AgentStatus.idle);

  void setApiKey(String key) {
    state = state.copyWith(apiKey: key);
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_apiKeyPrefsKey, key);
    });
  }

  void reset() => state = AgentTestingState(apiKey: state.apiKey, mode: state.mode);

  Future<void> _loadSavedApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final savedKey = prefs.getString(_apiKeyPrefsKey) ?? '';
    if (savedKey.isNotEmpty && state.apiKey != savedKey) {
      state = state.copyWith(apiKey: savedKey);
    }
  }

  // ── Unit Test Flow ────────────────────────────────────────────────────────

  Future<void> generateUnitTests({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) async {
    if (state.apiKey.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter your Gemini API key first.');
      return;
    }
    state = state.copyWith(
      status: AgentStatus.generating,
      errorMessage: null,
      testCases: [],
      testResults: [],
    );
    try {
      final agent = UnitTestAgent(aiRequestModel: _aiModel);
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
    state = state.copyWith(
      status: AgentStatus.running,
      testResults: [],
      errorMessage: null,
    );
    try {
      final agent = UnitTestAgent(aiRequestModel: _aiModel);
      final results = await agent.runSelectedTests(state.testCases);
      state = state.copyWith(status: AgentStatus.complete, testResults: results);
    } catch (e) {
      state = state.copyWith(
        status: AgentStatus.review,
        errorMessage: 'Run failed: $e',
      );
    }
  }

  // ── Workflow Flow ─────────────────────────────────────────────────────────

  Future<void> generateWorkflow(List<Map<String, dynamic>> requests) async {
    if (state.apiKey.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter your Gemini API key first.');
      return;
    }
    state = state.copyWith(
      status: AgentStatus.generating,
      errorMessage: null,
      workflowSteps: [],
      stepResults: [],
    );
    try {
      final agent = WorkflowAgent(aiRequestModel: _aiModel);
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
    state = state.copyWith(
      status: AgentStatus.running,
      stepResults: [],
      errorMessage: null,
    );
    try {
      final agent = WorkflowAgent(aiRequestModel: _aiModel);
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