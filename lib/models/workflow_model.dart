class WorkflowModel {
  const WorkflowModel({
    required this.id,
    this.name = 'Untitled Workflow',
    this.description = '',
    this.schemaVersion = 1,
    required this.createdAt,
    required this.modifiedAt,
    this.graphData = const {},
  });

  final String id;
  final String name;
  final String description;
  final int schemaVersion;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final Map<String, dynamic> graphData;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'schemaVersion': schemaVersion,
        'createdAt': createdAt.toIso8601String(),
        'modifiedAt': modifiedAt.toIso8601String(),
        'graphData': graphData,
      };

  factory WorkflowModel.fromJson(Map<String, dynamic> json) => WorkflowModel(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'Untitled Workflow',
        description: json['description'] as String? ?? '',
        schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
        createdAt: DateTime.parse(json['createdAt'] as String),
        modifiedAt: DateTime.parse(json['modifiedAt'] as String),
        graphData: _coerceGraphData(json['graphData']),
      );

  WorkflowModel copyWith({
    String? id,
    String? name,
    String? description,
    int? schemaVersion,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Map<String, dynamic>? graphData,
  }) =>
      WorkflowModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        schemaVersion: schemaVersion ?? this.schemaVersion,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
        graphData: graphData ?? this.graphData,
      );
}

Map<String, dynamic> _coerceGraphData(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v));
  }
  return const <String, dynamic>{};
}
