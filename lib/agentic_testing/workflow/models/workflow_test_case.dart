import '../../models/test_expectation.dart';

class WorkflowTestCase {
  final String id;
  final String name;
  final String description;
  
  /// Initial variables to seed the workflow with (e.g. login credentials)
  final Map<String, String> initialVariables;

  /// Expectations per step (stepId -> expectation)
  final Map<String, TestExpectation> stepExpectations;

  const WorkflowTestCase({
    required this.id,
    required this.name,
    required this.description,
    this.initialVariables = const {},
    this.stepExpectations = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'initialVariables': initialVariables,
        'stepExpectations': stepExpectations.map((k, v) => MapEntry(k, v.toJson())),
      };

  factory WorkflowTestCase.fromJson(Map<String, dynamic> json) => WorkflowTestCase(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        initialVariables: Map<String, String>.from(json['initialVariables'] as Map? ?? {}),
        stepExpectations: (json['stepExpectations'] as Map? ?? {}).map(
          (k, v) => MapEntry(k as String, TestExpectation.fromJson(Map<String, dynamic>.from(v as Map))),
        ),
      );
}
