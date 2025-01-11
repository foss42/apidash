// lib/src/models/predicate.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'predicate.freezed.dart';
part 'predicate.g.dart';

@freezed
class Predicate with _$Predicate {
  const factory Predicate({
    required String type,
    @Default(false) bool not,
    dynamic value,
    String? encoding, // For base64, regex values
  }) = _Predicate;

  factory Predicate.fromJson(Map<String, dynamic> json) =>
      _$PredicateFromJson(json);
}
