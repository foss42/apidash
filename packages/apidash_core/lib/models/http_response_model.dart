import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart' show mergeMaps;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import '../utils/utils.dart';
import '../consts.dart';

part 'http_response_model.freezed.dart';

part 'http_response_model.g.dart';

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
class HttpResponseModel with _$HttpResponseModel {
  const HttpResponseModel._();

  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory HttpResponseModel({
    int? statusCode,
    Map<String, String>? headers,
    Map<String, String>? requestHeaders,
    String? body,
    String? formattedBody,
    @Uint8ListConverter() Uint8List? bodyBytes,
    @DurationConverter() Duration? time,
  }) = _HttpResponseModel;

  factory HttpResponseModel.fromJson(Map<String, Object?> json) =>
      _$HttpResponseModelFromJson(json);

  String? get contentType => getContentTypeFromHeaders(headers);
  MediaType? get mediaType => getMediaTypeFromHeaders(headers);

  HttpResponseModel fromResponse({
    required Response response,
    Duration? time,
  }) {
    final responseHeaders = mergeMaps(
        {HttpHeaders.contentLengthHeader: response.contentLength.toString()},
        response.headers);
    MediaType? mediaType = getMediaTypeFromHeaders(responseHeaders);
    final body = (mediaType?.subtype == kSubTypeJson)
        ? utf8.decode(response.bodyBytes)
        : response.body;
    return HttpResponseModel(
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
