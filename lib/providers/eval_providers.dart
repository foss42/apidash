import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/eval/eval_consts.dart';
import '../services/eval_service.dart';

class BenchmarkState {
  final bool isRunning;
  final String? result;
  final List<String> logs;
  final BenchmarkType? selectedBenchmark;
  final String? selectedModel;
  final int concurrency;
  final int total;
  final String? workflowPlan;
  final String? errorMessage;

  BenchmarkState({
    this.isRunning = false,
    this.result,
    this.logs = const [],
    this.selectedBenchmark,
    this.selectedModel,
    this.concurrency = 5,
    this.total = 20,
    this.workflowPlan,
    this.errorMessage,
  });

  BenchmarkState copyWith({
    bool? isRunning,
    String? result,
    List<String>? logs,
    BenchmarkType? selectedBenchmark,
    String? selectedModel,
    int? concurrency,
    int? total,
    String? workflowPlan,
    String? errorMessage,
  }) {
    return BenchmarkState(
      isRunning: isRunning ?? this.isRunning,
      result: result ?? this.result,
      logs: logs ?? this.logs,
      selectedBenchmark: selectedBenchmark ?? this.selectedBenchmark,
      selectedModel: selectedModel ?? this.selectedModel,
      concurrency: concurrency ?? this.concurrency,
      total: total ?? this.total,
      workflowPlan: workflowPlan ?? this.workflowPlan,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class BenchmarkNotifier extends Notifier<BenchmarkState> {
  @override
  BenchmarkState build() {
    return BenchmarkState();
  }

  void selectBenchmark(BenchmarkType benchmark) {
    state = state.copyWith(selectedBenchmark: benchmark);
  }

  void selectModel(String model) {
    state = state.copyWith(selectedModel: model);
  }

  void updateConcurrency(int value) {
    state = state.copyWith(concurrency: value);
  }

  void updateTotal(int value) {
    state = state.copyWith(total: value);
  }

  void updateWorkflowPlan(String plan) {
    state = state.copyWith(workflowPlan: plan);
  }

  Future<void> runBenchmark() async {
    if (state.selectedBenchmark == null || state.isRunning) return;

    state = state.copyWith(
      isRunning: true,
      result: null,
      logs: [],
      errorMessage: null,
    );

    try {
      await EvalService.runBenchmark(
        benchmarkType: state.selectedBenchmark!,
        modelName: state.selectedModel ?? "default",
        concurrency: state.concurrency,
        total: state.total,
        workflow: state.workflowPlan,
        onLog: (log) {
          state = state.copyWith(logs: [...state.logs, log]);
        },
        onResult: (result) {
          state = state.copyWith(result: result);
        },
        onError: (error) {
          state = state.copyWith(errorMessage: error);
        },
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isRunning: false);
    }
  }
}

final benchmarkProvider = NotifierProvider<BenchmarkNotifier, BenchmarkState>(() {
  return BenchmarkNotifier();
});
