import 'workflow_step.dart';

class WorkflowDefinition {
  final String id;
  final String name;
  final List<WorkflowStep> steps;
  final DateTime createdAt;

  const WorkflowDefinition({
    required this.id,
    required this.name,
    this.steps = const [],
    required this.createdAt,
  });

  WorkflowDefinition copyWith({
    String? id,
    String? name,
    List<WorkflowStep>? steps,
    DateTime? createdAt,
  }) {
    return WorkflowDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'steps': steps.map((s) => s.toJson()).toList(),
        'createdAt': createdAt.toUtc().toIso8601String(),
      };

  factory WorkflowDefinition.fromJson(Map<String, dynamic> json) =>
      WorkflowDefinition(
        id: json['id'] as String,
        name: json['name'] as String,
        steps: (json['steps'] as List<dynamic>? ?? [])
            .map((e) => WorkflowStep.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      );
}
