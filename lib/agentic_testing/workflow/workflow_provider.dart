import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/request_model.dart';
import '../../providers/providers.dart';
import 'models/workflow_definition.dart';
import 'models/workflow_run_result.dart';
import 'models/workflow_step.dart';
import 'workflow_runner.dart';
import 'models/workflow_test_case.dart';
import 'ai_workflow_generation_service.dart';
import 'ai_workflow_testing_service.dart';

const _uuid = Uuid();

class WorkflowState {
  final WorkflowDefinition workflow;
  final bool isRunning;
  final bool isAiGenerating;
  final List<WorkflowRunResult>? lastResults;
  final String? error;
  final String? aiError;
  final List<WorkflowTestCase> generatedCases;
  final Set<String> selectedCaseIds;

  const WorkflowState({
    required this.workflow,
    this.isRunning = false,
    this.isAiGenerating = false,
    this.lastResults,
    this.error,
    this.aiError,
    this.generatedCases = const [],
    this.selectedCaseIds = const {},
  });

  bool get hasResults => lastResults != null;

  List<WorkflowRunResult>? get currentResults => lastResults;

  WorkflowState copyWith({
    WorkflowDefinition? workflow,
    bool? isRunning,
    bool? isAiGenerating,
    List<WorkflowRunResult>? lastResults,
    String? error,
    String? aiError,
    List<WorkflowTestCase>? generatedCases,
    Set<String>? selectedCaseIds,
    bool clearResults = false,
    bool clearError = false,
    bool clearAiError = false,
    bool clearTests = false,
  }) {
    return WorkflowState(
      workflow: workflow ?? this.workflow,
      isRunning: isRunning ?? this.isRunning,
      isAiGenerating: isAiGenerating ?? this.isAiGenerating,
      lastResults: clearResults ? null : (lastResults ?? this.lastResults),
      error: clearError ? null : (error ?? this.error),
      aiError: clearAiError ? null : (aiError ?? this.aiError),
      generatedCases: clearTests ? const [] : (generatedCases ?? this.generatedCases),
      selectedCaseIds: clearTests ? const {} : (selectedCaseIds ?? this.selectedCaseIds),
    );
  }
}

class WorkflowNotifier extends Notifier<WorkflowState> {
  @override
  WorkflowState build() {
    return WorkflowState(
      workflow: WorkflowDefinition(
        id: _uuid.v4(),
        name: 'My Workflow',
        steps: const [],
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  void addStep(String requestId, String requestName) {
    final step = WorkflowStep(
      stepId: _uuid.v4(),
      requestId: requestId,
      name: requestName,
    );
    final updated = state.workflow.copyWith(
      steps: [...state.workflow.steps, step],
    );
    state = state.copyWith(
      workflow: updated,
      clearResults: true,
      clearAiError: true,
    );
  }

  void removeStep(String stepId) {
    final filtered =
        state.workflow.steps.where((s) => s.stepId != stepId).toList();
    state = state.copyWith(
      workflow: state.workflow.copyWith(steps: filtered),
      clearResults: true,
      clearAiError: true,
    );
  }

  void reorderSteps(int oldIndex, int newIndex) {
    final steps = [...state.workflow.steps];
    final item = steps.removeAt(oldIndex);
    steps.insert(newIndex, item);
    state = state.copyWith(
      workflow: state.workflow.copyWith(steps: steps),
      clearResults: true,
      clearAiError: true,
    );
  }

  void updateStep(WorkflowStep updated) {
    final steps = state.workflow.steps
        .map((s) => s.stepId == updated.stepId ? updated : s)
        .toList();
    state = state.copyWith(
      workflow: state.workflow.copyWith(steps: steps),
      clearResults: true,
      clearAiError: true,
    );
  }

  Future<void> runWorkflow(WidgetRef ref) async {
    if (state.workflow.steps.isEmpty) return;

    state = state.copyWith(isRunning: true, clearError: true, clearResults: true);

    try {
      final collection = ref.read(collectionStateNotifierProvider) ?? {};
      final runner = WorkflowRunner();
      final results = await runner.run(state.workflow, collection);
      state = state.copyWith(isRunning: false, lastResults: results);
    } catch (e) {
      state = state.copyWith(
        isRunning: false,
        error: 'Workflow failed: $e',
      );
    }
  }

  Future<void> generateWithAi(WidgetRef ref, String instructions) async {
    if (state.workflow.steps.isEmpty) return;

    state = state.copyWith(isAiGenerating: true, clearAiError: true);

    try {
      final collection = ref.read(collectionStateNotifierProvider) ?? {};
      const service = AIWorkflowGenerationService();

      final modifications = await service.generate(
        workflow: state.workflow,
        collection: collection,
        userInstructions: instructions,
        ref: ref,
      );

      // Apply modifications to workflow steps
      final updatedSteps = state.workflow.steps.map((step) {
        final mod = modifications.firstWhere(
          (m) => m['stepId'] == step.stepId,
          orElse: () => {},
        );
        if (mod.isEmpty) return step;

        return step.copyWith(
          extract: Map<String, String>.from(mod['extract'] ?? step.extract),
          inject: Map<String, String>.from(mod['inject'] ?? step.inject),
        );
      }).toList();

      state = state.copyWith(
        isAiGenerating: false,
        workflow: state.workflow.copyWith(steps: updatedSteps),
      );
    } catch (e) {
      state = state.copyWith(
        isAiGenerating: false,
        aiError: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> generateTestsWithAi(WidgetRef ref, String instructions) async {
    if (state.workflow.steps.isEmpty) return;
    state = state.copyWith(isAiGenerating: true, clearAiError: true);
    try {
      final collection = ref.read(collectionStateNotifierProvider) ?? {};
      const service = AIWorkflowTestingService();
      final cases = await service.generate(
        workflow: state.workflow,
        collection: collection,
        userInstructions: instructions,
        ref: ref,
      );
      final existingIds = state.generatedCases.map((c) => c.id).toSet();
      final uniqueCases = cases.where((c) => !existingIds.contains(c.id)).toList();
      
      state = state.copyWith(
        isAiGenerating: false,
        generatedCases: [...state.generatedCases, ...uniqueCases],
        selectedCaseIds: {...state.selectedCaseIds, ...uniqueCases.map((c) => c.id)},
      );
    } catch (e) {
      state = state.copyWith(
        isAiGenerating: false,
        aiError: 'Test generation failed: $e',
      );
    }
  }

  void toggleTestCaseSelection(String id) {
    final ids = {...state.selectedCaseIds};
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    state = state.copyWith(selectedCaseIds: ids);
  }

  void selectAllTests() {
    state = state.copyWith(selectedCaseIds: state.generatedCases.map((c) => c.id).toSet());
  }

  void deselectAllTests() {
    state = state.copyWith(selectedCaseIds: const {});
  }

  void clearTests() {
    state = state.copyWith(clearTests: true);
  }

  void clearResults() {
    state = state.copyWith(
        clearResults: true, clearError: true, clearAiError: true);
  }

  void renameWorkflow(String name) {
    state = state.copyWith(workflow: state.workflow.copyWith(name: name));
  }
}

final workflowProvider =
    NotifierProvider<WorkflowNotifier, WorkflowState>(() => WorkflowNotifier());
