import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show mergeMaps;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

@immutable
class ResponseModel {
  const ResponseModel({
    this.statusCode,
    this.headers,
    this.requestHeaders,
    this.contentType,
    this.mediaType,
    this.body,
    this.formattedBody,
    this.bodyBytes,
    this.time,
  });

  final int? statusCode;
  final Map<String, String>? headers;
  final Map<String, String>? requestHeaders;
  final String? contentType;
  final MediaType? mediaType;
  final String? body;
  final String? formattedBody;
  final Uint8List? bodyBytes;
  final Duration? time;

  ResponseModel fromResponse({
    required Response response,
    Duration? time,
  }) {
    MediaType? mediaType;
    var contentType = response.headers[HttpHeaders.contentTypeHeader];
    try {
      mediaType = MediaType.parse(contentType!);
    } catch (e) {
      mediaType = null;
    }
    final responseHeaders = mergeMaps(
        {HttpHeaders.contentLengthHeader: response.contentLength.toString()},
        response.headers);
    final body = (mediaType?.subtype == kSubTypeJson)
        ? utf8.decode(response.bodyBytes)
        : response.body;
    return ResponseModel(
      statusCode: response.statusCode,
      headers: responseHeaders,
      requestHeaders: response.request?.headers,
      contentType: contentType,
      mediaType: mediaType,
      body: body,
      formattedBody: formatBody(body, mediaType),
      bodyBytes: response.bodyBytes,
      time: time,
    );
  }

  factory ResponseModel.fromJson(Map<String, dynamic> data) {
    MediaType? mediaType;
    Duration? timeElapsed;
    final statusCode = data["statusCode"] as int?;
    final headers = data["headers"] as Map<String, String>?;
    final requestHeaders = data["requestHeaders"] as Map<String, String>?;
    final contentType = headers?[HttpHeaders.contentTypeHeader];
    try {
      mediaType = MediaType.parse(contentType!);
    } catch (e) {
      mediaType = null;
    }
    final body = data["body"] as String?;
    final bodyBytes = data["bodyBytes"] as Uint8List?;
    final time = data["time"] as int?;
    if (time != null) {
      timeElapsed = Duration(microseconds: time);
    }
    return ResponseModel(
      statusCode: statusCode,
      headers: headers,
      requestHeaders: requestHeaders,
      contentType: contentType,
      mediaType: mediaType,
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
      "Response Content-Type: $contentType",
      "Response Body: $body",
    ].join("\n");
  }
}
