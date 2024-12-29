// lib/src/models/assert.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'query.dart';
import 'filter.dart';
import 'predicate.dart';

part 'hurl_assert.freezed.dart';
part 'hurl_assert.g.dart';

@freezed
class HurlAssert with _$HurlAssert {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory HurlAssert({
    required Query query,
    List<Filter>? filters,
    required Predicate predicate,
  }) = _HurlAssert;

  factory HurlAssert.fromJson(Map<String, dynamic> json) =>
      _$HurlAssertFromJson(json);
}
