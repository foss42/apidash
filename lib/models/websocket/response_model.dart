import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart' show mergeMaps;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

@immutable
class WebsocketResponseModel {
  const WebsocketResponseModel({
    this.statusCode,
    this.headers,
    this.requestHeaders,
    this.body,
    this.formattedBody,
    this.bodyBytes,
    this.time,
  });

  final int? statusCode;
  final Map<String, String>? headers;
  final Map<String, String>? requestHeaders;
  final String? body;
  final String? formattedBody;
  final Uint8List? bodyBytes;
  final Duration? time;

  String? get contentType => getContentTypeFromHeaders(headers);
  MediaType? get mediaType => getMediaTypeFromHeaders(headers);

  WebsocketResponseModel fromResponse({
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
    return WebsocketResponseModel(
      statusCode: response.statusCode,
      headers: responseHeaders,
      requestHeaders: response.request?.headers,
      body: body,
      formattedBody: formatBody(body, mediaType),
      bodyBytes: response.bodyBytes,
      time: time,
    );
  }

  factory WebsocketResponseModel.fromJson(Map<String, dynamic> data) {
    Duration? timeElapsed;
    final statusCode = data["statusCode"] as int?;
    final headers = data["headers"] != null
        ? Map<String, String>.from(data["headers"])
        : null;
    MediaType? mediaType = getMediaTypeFromHeaders(headers);
    final requestHeaders = data["requestHeaders"] != null
        ? Map<String, String>.from(data["requestHeaders"])
        : null;
    final body = data["body"] as String?;
    final bodyBytes = data["bodyBytes"] as Uint8List?;
    final time = data["time"] as int?;
    if (time != null) {
      timeElapsed = Duration(microseconds: time);
    }
    return WebsocketResponseModel(
      statusCode: statusCode,
      headers: headers,
      requestHeaders: requestHeaders,
      body: body,
      formattedBody: formatBody(body, mediaType),
      bodyBytes: bodyBytes,
      time: timeElapsed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "statusCode": statusCode,
      "headers": headers,
      "requestHeaders": requestHeaders,
      "body": body,
      "bodyBytes": bodyBytes,
      "time": time?.inMicroseconds,
    };
  }

  @override
  String toString() {
    return [
      "Response Status: $statusCode",
      "Response Time: $time",
      "Response Headers: $headers",
      "Response Request Headers: $requestHeaders",
      "Response Body: $body",
    ].join("\n");
  }

  @override
  bool operator ==(Object other) {
    return other is WebsocketResponseModel &&
        other.runtimeType == runtimeType &&
        other.statusCode == statusCode &&
        mapEquals(other.headers, headers) &&
        mapEquals(other.requestHeaders, requestHeaders) &&
        other.body == body &&
        other.formattedBody == formattedBody &&
        other.bodyBytes == bodyBytes &&
        other.time == time;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      statusCode,
      headers,
      requestHeaders,
      body,
      formattedBody,
      bodyBytes,
      time,
    );
  }
}
