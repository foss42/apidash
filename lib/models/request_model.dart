import 'dart:io';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'kvrow_model.dart';
import '../consts.dart';

@immutable
class RequestModel {
  const RequestModel({
    required this.id,
    this.method = DEFAULT_METHOD,
    this.url = "",
    this.requestTabIndex = 0,
    this.requestHeaders,
    this.requestParams,
    this.requestBodyContentType = DEFAULT_BODY_CONTENT_TYPE,
    this.requestBody,
    this.responseStatus,
    this.message,
    this.responseModel,
  });

  final String id;
  final HTTPVerb method;
  final String url;
  final int requestTabIndex;
  final List<KVRow>? requestHeaders;
  final List<KVRow>? requestParams;
  final ContentType requestBodyContentType;
  final dynamic requestBody;
  final int? responseStatus;
  final String? message;
  final ResponseModel? responseModel;

  RequestModel duplicate({
    required String id,
  }) {
    return RequestModel(
      id: id,
      method: method,
      url: url,
      requestHeaders: requestHeaders,
      requestParams: requestParams,
      requestBodyContentType: requestBodyContentType,
      requestBody: requestBody,
    );
  }

  RequestModel copyWith({
    String? id,
    HTTPVerb? method,
    String? url,
    int? requestTabIndex,
    List<KVRow>? requestHeaders,
    List<KVRow>? requestParams,
    ContentType? requestBodyContentType,
    dynamic requestBody,
    int? responseStatus,
    String? message,
    ResponseModel? responseModel,
  }) {
    return RequestModel(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
      requestTabIndex: requestTabIndex ?? this.requestTabIndex,
      requestHeaders: requestHeaders ?? this.requestHeaders,
      requestParams: requestParams ?? this.requestParams,
      requestBodyContentType:
          requestBodyContentType ?? this.requestBodyContentType,
      requestBody: requestBody ?? this.requestBody,
      responseStatus: responseStatus ?? this.responseStatus,
      message: message ?? this.message,
      responseModel: responseModel ?? this.responseModel,
    );
  }

  @override
  String toString() {
    return [
      id,
      method.name,
      "URL: $url",
      "Request Tab Index: ${requestTabIndex.toString()}",
      "Request Headers: ${requestHeaders.toString()}",
      "Request Params: ${requestParams.toString()}",
      "Request Body Content Type: ${requestBodyContentType.toString()}",
      "Request Body: ${requestBody.toString()}",
      "Response Status: $responseStatus",
      "Response Message: $message",
      "Response: ${responseModel.toString()}"
    ].join("\n");
  }
}

@immutable
class ResponseModel {
  const ResponseModel({
    this.statusCode,
    this.headers,
    this.requestHeaders,
    this.contentType,
    this.body,
    this.time,
  });

  final int? statusCode;
  final Map<String, String>? headers;
  final Map<String, String>? requestHeaders;
  final String? contentType;
  final String? body;
  final Duration? time;

  ResponseModel fromResponse({
    required Response response,
    Duration? time,
  }) {
    var contentType = response.headers[HttpHeaders.contentTypeHeader];
    final responseHeaders = mergeMaps(
        {HttpHeaders.contentLengthHeader: response.contentLength.toString()},
        response.headers);
    return ResponseModel(
      statusCode: response.statusCode,
      headers: responseHeaders,
      requestHeaders: response.request?.headers,
      contentType: contentType,
      body: contentType == JSON_MIMETYPE
          ? utf8.decode(response.bodyBytes)
          : response.body,
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
