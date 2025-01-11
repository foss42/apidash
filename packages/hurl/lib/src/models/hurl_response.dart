import 'package:freezed_annotation/freezed_annotation.dart';

import 'capture.dart';
import 'header.dart';
import 'hurl_assert.dart';

part 'hurl_response.freezed.dart';
part 'hurl_response.g.dart';

@freezed
class HurlResponse with _$HurlResponse {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory HurlResponse({
    /// HTTP status code
    required int status,

    /// HTTP version (e.g., "HTTP/1.1", "HTTP/2")
    required String version,

    /// Response headers
    List<Header>? headers,

    /// Captures to extract values from the response
    List<Capture>? captures,

    /// Assertions to validate the response
    List<HurlAssert>? asserts,

    /// Response body (can be JSON object, string, byte data, etc.)
    @JsonKey(includeIfNull: false)
    dynamic body, // Changed from String to dynamic

    /// Type of the body content (json, xml, text, etc.)
    @JsonKey(name: 'body_type') String? bodyType,
  }) = _HurlResponse;

  factory HurlResponse.fromJson(Map<String, dynamic> json) =>
      _$HurlResponseFromJson(json);
}
