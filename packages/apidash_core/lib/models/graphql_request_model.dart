import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'graphql_request_model.freezed.dart';
part 'graphql_request_model.g.dart';

@freezed
class GraphqlRequestModel with _$GraphqlRequestModel {
  factory GraphqlRequestModel({
    required String query,
    Map<String, dynamic>? variables,
  }) = _GraphqlRequestModel;

  factory GraphqlRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GraphqlRequestModelFromJson(json);
}


// class GraphqlRequestModelConverter implements JsonConverter<GraphqlRequestModel, Map<String, dynamic>> {
//   const GraphqlRequestModelConverter();

//   @override
//   GraphqlRequestModel fromJson(Map<String, dynamic> json) {
//     // Implement conversion from JSON to GraphqlRequestModel
//     return GraphqlRequestModel.fromJson(json);
//   }

//   @override
//   Map<String, dynamic> toJson(GraphqlRequestModel object) {
//     // Implement conversion from GraphqlRequestModel to JSON
//     return object.toJson();
//   }
// }
// class GraphqlRequestModel {
//   final String query;
//   final Map<String, dynamic>? variables;

//   GraphqlRequestModel({
//     required this.query,
//     this.variables,
//   });

//   // Factory constructor for JSON deserialization
//   factory GraphqlRequestModel.fromJson(Map<String, dynamic> json) {
//     return GraphqlRequestModel(
//       query: json['query'] as String,
//       variables: json['variables'] != null
//           ? Map<String, dynamic>.from(json['variables'] as Map)
//           : null,
//     );
//   }

//   // Method for JSON serialization
//   Map<String, dynamic> toJson() {
//     return {
//       'query': query,
//       if (variables != null) 'variables': variables,
//     };
//   }

//   // CopyWith method
//   GraphqlRequestModel copyWith({
//     String? query,
//     Map<String, dynamic>? variables,
//   }) {
//     return GraphqlRequestModel(
//       query: query ?? this.query,
//       variables: variables ?? this.variables,
//     );
//   }

//   @override
//   String toString() {
//     return 'GraphqlRequestModel(query: $query, variables: $variables)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     if (other is! GraphqlRequestModel) return false;
//     return query == other.query && 
//            variables == other.variables;
//   }

//   @override
//   int get hashCode => Object.hash(query, variables);
// }
