import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart' as dio;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart' show mergeMaps;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import '../extensions/extensions.dart';
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

  String? get contentType => headers?.getValueContentType();
  MediaType? get mediaType => getMediaTypeFromHeaders(headers);

  /// For http.Response
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

/// For Dio Response (patched to handle content-type fallback)

factory HttpResponseModel.fromDioResponse({
  required dio.Response response,
  required Duration time,
}) {
  // Normalize header keys to lowercase
  final headersMap = <String, String>{};
  response.headers.forEach((name, values) {
    headersMap[name.toLowerCase()] = values.join(', ');
  });

  // Normalize request headers too
  final requestHeaders = <String, String>{};
  response.requestOptions.headers.forEach((key, value) {
    requestHeaders[key] = value.toString();
  });

  final rawBody = response.data;

  String bodyText;
  Uint8List? bodyBytes;

  if (rawBody is Uint8List) {
    bodyBytes = rawBody;
    bodyText = utf8.decode(bodyBytes, allowMalformed: true);
  } else if (rawBody is String) {
    bodyText = rawBody;
  } else {
    try {
      bodyText = const JsonEncoder.withIndent('  ').convert(rawBody);
    } catch (_) {
      bodyText = rawBody.toString();
    }
  }

  final mediaType = _determineMediaType(headersMap, rawBody);

  return HttpResponseModel(
    statusCode: response.statusCode,
    headers: headersMap,
    requestHeaders: requestHeaders,
    body: bodyText,
    formattedBody: formatBody(bodyText, mediaType),
    bodyBytes: bodyBytes,
    time: time,
  );
}
}
MediaType? _determineMediaType(Map<String, String> headers, dynamic body) {
  final contentType = headers['content-type'];
  if (contentType != null) {
    try {
      return MediaType.parse(contentType);
    } catch (_) {
      // Invalid content-type format
    }
  }

  if (body is String) {
    final trimmed = body.trimLeft().toLowerCase();
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
      return MediaType.parse('application/json');
    }
    if (trimmed.startsWith('<!doctype html') || trimmed.startsWith('<html')) {
      return MediaType.parse('text/html');
    }
  }

  return null;
}