// lib/src/models/query.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'query.freezed.dart';
part 'query.g.dart';

@freezed
class Query with _$Query {
  const factory Query({
    required String type,
    String? expr, // For jsonpath, xpath, regex queries
    String? name, // For header, cookie queries
  }) = _Query;

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);
}
