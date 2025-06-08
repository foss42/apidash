import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:apidash_core/apidash_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'ai_response_model.freezed.dart';
part 'ai_response_model.g.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, List<int>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<int>? json) {
    return json == null ? null : Uint8List.fromList(json);
  }

  @override
  List<int>? toJson(Uint8List? object) {
    return object?.toList();
  }
}

class DurationConverter implements JsonConverter<Duration?, int?> {
  const DurationConverter();

  @override
  Duration? fromJson(int? json) {
    return json == null ? null : Duration(microseconds: json);
  }

  @override
  int? toJson(Duration? object) {
    return object?.inMicroseconds;
  }
}

@freezed
class AIResponseModel with _$AIResponseModel {
  const AIResponseModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true, createToJson: true)
  const factory AIResponseModel({
    int? statusCode,
    Map<String, String>? headers,
    Map<String, String>? requestHeaders,
    String? body,
    String? formattedBody,
    @Uint8ListConverter() Uint8List? bodyBytes,
    @DurationConverter() Duration? time,
  }) = _AIResponseModel;

  factory AIResponseModel.fromJson(Map<String, Object?> json) =>
      _$AIResponseModelFromJson(json);

  AIResponseModel fromResponse({required Response response, Duration? time}) {
    final responseHeaders = mergeMaps({
      HttpHeaders.contentLengthHeader: response.contentLength.toString(),
    }, response.headers);
    MediaType? mediaType = getMediaTypeFromHeaders(responseHeaders);
    final body = (mediaType?.subtype == kSubTypeJson)
        ? utf8.decode(response.bodyBytes)
        : response.body;

    return AIResponseModel(
      statusCode: response.statusCode,
      headers: responseHeaders,
      requestHeaders: response.request?.headers,
      body: body,
      formattedBody: formatBody(body, mediaType),
      bodyBytes: response.bodyBytes,
      time: time,
    );
  }
}
