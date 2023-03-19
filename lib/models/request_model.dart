import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'kvrow_model.dart';
import 'response_model.dart';

@immutable
class RequestModel {
  const RequestModel({
    required this.id,
    this.method = kDefaultHttpMethod,
    this.url = "",
    this.requestTabIndex = 0,
    this.requestHeaders,
    this.requestParams,
    this.requestBodyContentType = kDefaultContentType,
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
