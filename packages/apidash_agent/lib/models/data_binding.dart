// Represents a data extraction rule between workflow steps
// e.g. extract {{userId}} from response body using JSONPath $.data.id
class DataBinding {
  final String variableName; // "userId"
  final String jsonPath;     // "$.data.id"

  DataBinding({
    required this.variableName,
    required this.jsonPath,
  });

  Map<String, dynamic> toJson() => {
        'variableName': variableName,
        'jsonPath': jsonPath,
      };

  factory DataBinding.fromJson(Map<String, dynamic> json) => DataBinding(
        variableName: json['variableName'] as String,
        jsonPath: json['jsonPath'] as String,
      );
}