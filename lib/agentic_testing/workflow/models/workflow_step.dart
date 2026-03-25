class WorkflowStep {
  final String stepId;
  final String requestId;
  final String name;

  /// Extract rules: varName → dot-path in response
  /// e.g. {"token": "body.data.access_token", "userId": "body.data.id"}
  /// Supported prefixes: body.<path>, header.<Header-Name>
  final Map<String, String> extract;

  /// Inject rules: target → template value with {{varName}}
  /// e.g. {"header.Authorization": "Bearer {{token}}", "body.user": "{{userId}}"}
  /// Supported targets: header.<Name>, body (full body replace), url
  final Map<String, String> inject;

  const WorkflowStep({
    required this.stepId,
    required this.requestId,
    required this.name,
    this.extract = const {},
    this.inject = const {},
  });

  WorkflowStep copyWith({
    String? stepId,
    String? requestId,
    String? name,
    Map<String, String>? extract,
    Map<String, String>? inject,
  }) {
    return WorkflowStep(
      stepId: stepId ?? this.stepId,
      requestId: requestId ?? this.requestId,
      name: name ?? this.name,
      extract: extract ?? this.extract,
      inject: inject ?? this.inject,
    );
  }

  Map<String, dynamic> toJson() => {
        'stepId': stepId,
        'requestId': requestId,
        'name': name,
        'extract': extract,
        'inject': inject,
      };

  factory WorkflowStep.fromJson(Map<String, dynamic> json) => WorkflowStep(
        stepId: json['stepId'] as String,
        requestId: json['requestId'] as String,
        name: json['name'] as String,
        extract: Map<String, String>.from(json['extract'] as Map? ?? {}),
        inject: Map<String, String>.from(json['inject'] as Map? ?? {}),
      );
}
