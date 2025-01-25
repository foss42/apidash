// lib/src/models/hurl_request.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hurl/hurl.dart';

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
    @JsonKey(name: "multipart_form_data")
    List<MultipartFormData>? multiPartFormData,
  }) = _HurlRequest;

  factory HurlRequest.fromJson(Map<String, dynamic> json) =>
      _$HurlRequestFromJson(json);
}
