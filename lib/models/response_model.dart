import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
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
    final formattedBody = formatBody(body, mediaType);
    return ResponseModel(
      statusCode: response.statusCode,
      headers: responseHeaders,
      requestHeaders: response.request?.headers,
      contentType: contentType,
      mediaType: mediaType,
      body: body,
      formattedBody: formattedBody,
      bodyBytes: response.bodyBytes,
      time: time,
    );
  }

  @override
  String toString() {
    return [
      "Response Status: $statusCode",
      "Response Time: $time",
      "Response Headers: ${headers.toString()}",
      "Response Request Headers: ${requestHeaders.toString()}",
      "Response Body: $body",
    ].join("\n");
  }
}
