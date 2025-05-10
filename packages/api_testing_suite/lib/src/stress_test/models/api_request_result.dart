import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_request_result.freezed.dart';
part 'api_request_result.g.dart';

@freezed
class ApiRequestResult with _$ApiRequestResult {
  const factory ApiRequestResult({
    required int statusCode,
    required String body,
    required Duration duration,
    String? error,
  }) = _ApiRequestResult;

  factory ApiRequestResult.fromJson(Map<String, Object?> json) => _$ApiRequestResultFromJson(json);
}
