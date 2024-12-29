// lib/src/models/request_option.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_option.freezed.dart';
part 'request_option.g.dart';

@freezed
class RequestOption with _$RequestOption {
  @JsonSerializable(explicitToJson: true)
  const factory RequestOption({
    required String name,
    required dynamic value,
  }) = _RequestOption;

  factory RequestOption.fromJson(Map<String, dynamic> json) =>
      _$RequestOptionFromJson(json);
}
