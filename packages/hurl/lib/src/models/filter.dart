// lib/src/models/filter.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter.freezed.dart';
part 'filter.g.dart';

@freezed
class Filter with _$Filter {
  const factory Filter({
    required String type,
    String? expr, // For regex, jsonpath, xpath
    String? encoding, // For decode filter
    String? fmt, // For format filter
    int? n, // For nth filter
    String? oldValue, // For replace filter
    String? newValue, // For replace filter
    String? sep, // For split filter
  }) = _Filter;

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);
}
