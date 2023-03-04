import 'package:flutter/material.dart';
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
  });

  final String id;
  final HTTPVerb method;
  final String url;
  final int requestTabIndex;
  final List<KVRow>? requestHeaders;
  final List<KVRow>? requestParams;
  final ContentType requestBodyContentType;
  final dynamic requestBody;

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
    ].join("\n");
  }
}
