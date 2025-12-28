
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/evaluation_model.dart';

final evaluationsProvider = StateNotifierProvider<EvaluationsNotifier, List<EvaluationModel>>((ref) {
  return EvaluationsNotifier();
});

class EvaluationsNotifier extends StateNotifier<List<EvaluationModel>> {
  EvaluationsNotifier() : super([]);

  void addEvaluation(String name, String dataset, List<String> models) {
    final newEval = EvaluationModel(
      id: const Uuid().v4(),
      name: name,
      datasetPath: dataset,
      models: models,
      status: EvaluationStatus.pending,
    );
    state = [newEval, ...state];
  }

  Future<void> runEvaluation(String id) async {
    // 1. Mark as running
    state = state.map((eval) {
      if (eval.id == id) {
        return eval.copyWith(status: EvaluationStatus.running);
      }
      return eval;
    }).toList();

    // 2. Simulate delay (Mock execution)
    await Future.delayed(const Duration(seconds: 2));

    // 3. Generate Mock Results
    state = state.map((eval) {
      if (eval.id == id) {
        final mockResults = eval.models.map((m) {
          return EvaluationResult(
            modelId: m,
            score: (0.7 + (0.3 * (DateTime.now().millisecond / 1000))),     // Random score 0.7-1.0
            latencyMs: 150 + (DateTime.now().millisecond % 500),            // Random latency
          );
        }).toList();

        return eval.copyWith(
          status: EvaluationStatus.completed,
          results: mockResults,
        );
      }
      return eval;
    }).toList();
  }
  
  void deleteEvaluation(String id) {
    state = state.where((eval) => eval.id != id).toList();
  }
}
