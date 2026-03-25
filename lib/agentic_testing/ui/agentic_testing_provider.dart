import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/request_model.dart';
import '../engine/ai_generation_service.dart';
import '../engine/rule_generation_service.dart';
import '../execution/apidash_request_executor.dart';
import '../memory/hive_memory_repository.dart';
import '../models/models.dart';
import '../workflow/testing_workflow_orchestrator.dart';

final agenticMemoryRepositoryProvider = Provider<HiveMemoryRepository>((ref) {
  return HiveMemoryRepository();
});

final testingOrchestratorProvider = Provider<TestingWorkflowOrchestrator>((ref) {
  final memoryRepo = ref.watch(agenticMemoryRepositoryProvider);
  return TestingWorkflowOrchestrator(
    executor: ApidashRequestExecutor(),
    memoryRepository: memoryRepo,
  );
});

final ruleGenerationServiceProvider = Provider<RuleGenerationService>((ref) {
  return const RuleGenerationService();
});

final aiGenerationServiceProvider = Provider<AIGenerationService>((ref) {
  return const AIGenerationService();
});

class AgenticTestState {
  final bool isGenerating;
  final bool isRunning;
  final bool isAiGenerating;
  final List<TestCase> generatedCases;
  final Set<String> selectedCaseIds;
  final TestSuite? latestSuite;
  final String? error;
  final String? aiError;

  AgenticTestState({
    this.isGenerating = false,
    this.isRunning = false,
    this.isAiGenerating = false,
    this.generatedCases = const [],
    this.selectedCaseIds = const {},
    this.latestSuite,
    this.error,
    this.aiError,
  });

  bool get hasGenerated => generatedCases.isNotEmpty;
  int get selectedCount => selectedCaseIds.length;

  AgenticTestState copyWith({
    bool? isGenerating,
    bool? isRunning,
    bool? isAiGenerating,
    List<TestCase>? generatedCases,
    Set<String>? selectedCaseIds,
    TestSuite? latestSuite,
    String? error,
    String? aiError,
    bool clearError = false,
    bool clearAiError = false,
    bool clearSuite = false,
  }) {
    return AgenticTestState(
      isGenerating: isGenerating ?? this.isGenerating,
      isRunning: isRunning ?? this.isRunning,
      isAiGenerating: isAiGenerating ?? this.isAiGenerating,
      generatedCases: generatedCases ?? this.generatedCases,
      selectedCaseIds: selectedCaseIds ?? this.selectedCaseIds,
      latestSuite: clearSuite ? null : (latestSuite ?? this.latestSuite),
      error: clearError ? null : (error ?? this.error),
      aiError: clearAiError ? null : (aiError ?? this.aiError),
    );
  }
}

class AgenticTestingNotifier extends Notifier<AgenticTestState> {
  @override
  AgenticTestState build() => AgenticTestState();

  void generateTests(RequestModel requestModel) {
    if (requestModel.httpRequestModel == null) return;

    state = state.copyWith(
        isGenerating: true, clearError: true, clearSuite: true);

    try {
      final service = ref.read(ruleGenerationServiceProvider);
      final cases = service.generateForRequest(requestModel);
      final allIds = cases.map((c) => c.id).toSet();
      state = state.copyWith(
        isGenerating: false,
        generatedCases: cases,
        selectedCaseIds: allIds,
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        error: 'Failed to generate tests: $e',
      );
    }
  }

  Future<void> generateMoreWithAi({
    required RequestModel requestModel,
    required WidgetRef ref,
    required String userInstructions,
  }) async {
    state = state.copyWith(isAiGenerating: true, clearAiError: true);

    try {
      final service = ref.read(aiGenerationServiceProvider);
      final newCases = await service.generate(
        requestModel: requestModel,
        existingCases: state.generatedCases,
        userInstructions: userInstructions,
        ref: ref,
      );

      // Deduplicate by id
      final existingIds = state.generatedCases.map((c) => c.id).toSet();
      final unique = newCases.where((c) => !existingIds.contains(c.id)).toList();

      final merged = [...state.generatedCases, ...unique];
      final newSelected = {
        ...state.selectedCaseIds,
        ...unique.map((c) => c.id),
      };

      state = state.copyWith(
        isAiGenerating: false,
        generatedCases: merged,
        selectedCaseIds: newSelected,
      );
    } catch (e) {
      state = state.copyWith(
        isAiGenerating: false,
        aiError: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void toggleSelection(String id) {
    final current = Set<String>.from(state.selectedCaseIds);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(selectedCaseIds: current);
  }

  void selectAll() {
    final allIds = state.generatedCases.map((c) => c.id).toSet();
    state = state.copyWith(selectedCaseIds: allIds);
  }

  void deselectAll() {
    state = state.copyWith(selectedCaseIds: {});
  }

  Future<void> runSelectedTests(RequestModel requestModel) async {
    if (requestModel.httpRequestModel == null) return;
    if (state.selectedCaseIds.isEmpty) return;

    state = state.copyWith(isRunning: true, clearError: true);

    final orchestrator = ref.read(testingOrchestratorProvider);

    final casesToRun = state.generatedCases
        .where((c) => state.selectedCaseIds.contains(c.id))
        .toList();

    try {
      final resultSuite = await orchestrator.runCases(casesToRun, requestModel);
      state = state.copyWith(
        isRunning: false,
        latestSuite: resultSuite,
      );
    } catch (e) {
      state = state.copyWith(
        isRunning: false,
        error: 'Test workflow crashed: $e',
      );
    }
  }

  void clearState() {
    state = AgenticTestState();
  }
}

final agenticTestingProvider =
    NotifierProvider<AgenticTestingNotifier, AgenticTestState>(() {
  return AgenticTestingNotifier();
});