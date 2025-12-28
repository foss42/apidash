
enum EvaluationStatus {
  pending,
  running,
  completed,
}

class EvaluationResult {
  final String modelId;
  final double score;
  final int latencyMs;

  EvaluationResult({
    required this.modelId,
    required this.score,
    required this.latencyMs,
  });
}

class EvaluationModel {
  final String id;
  final String name;
  final String datasetPath;
  final List<String> models;
  final EvaluationStatus status;
  final List<EvaluationResult> results;

  EvaluationModel({
    required this.id,
    required this.name,
    required this.datasetPath,
    required this.models,
    this.status = EvaluationStatus.pending,
    this.results = const [],
  });

  EvaluationModel copyWith({
    String? id,
    String? name,
    String? datasetPath,
    List<String>? models,
    EvaluationStatus? status,
    List<EvaluationResult>? results,
  }) {
    return EvaluationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      datasetPath: datasetPath ?? this.datasetPath,
      models: models ?? this.models,
      status: status ?? this.status,
      results: results ?? this.results,
    );
  }
}
