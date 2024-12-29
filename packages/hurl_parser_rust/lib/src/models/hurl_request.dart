// lib/src/models/hurl_request.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'header.dart';
import 'request_body.dart';
import 'request_option.dart';

part 'hurl_request.freezed.dart';
part 'hurl_request.g.dart';

@freezed
class HurlRequest with _$HurlRequest {
  @JsonSerializable(explicitToJson: true)
  const factory HurlRequest({
    required String method,
    required String url,
    List<Header>? headers,
    List<String>? comments,
    List<RequestOption>? options,
    RequestBody? body,
  }) = _HurlRequest;

  factory HurlRequest.fromJson(Map<String, dynamic> json) =>
      _$HurlRequestFromJson(json);
}
