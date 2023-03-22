import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show mapToRows, rowsToMap;
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
  final String? requestBody;
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
    String? requestBody,
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

  factory RequestModel.fromJson(Map<String, dynamic> data) {
    HTTPVerb method;
    ContentType requestBodyContentType;
    ResponseModel? responseModel;

    final id = data["id"] as String;
    try {
      method = HTTPVerb.values.byName(data["method"] as String);
    } catch (e) {
      method = kDefaultHttpMethod;
    }
    final url = data["url"] as String;
    final requestHeaders =
        mapToRows(data["requestHeaders"] as Map<String, String>?);
    final requestParams =
        mapToRows(data["requestParams"] as Map<String, String>?);
    try {
      requestBodyContentType =
          ContentType.values.byName(data["requestBodyContentType"] as String);
    } catch (e) {
      requestBodyContentType = kDefaultContentType;
    }
    final requestBody = data["requestBody"] as String?;
    final responseStatus = data["responseStatus"] as int?;
    final message = data["message"] as String?;
    final responseModelJson = data["responseModel"] as Map<String, dynamic>?;
    if (responseModelJson != null) {
      responseModel = ResponseModel.fromJson(responseModelJson);
    } else {
      responseModel = null;
    }

    return RequestModel(
      id: id,
      method: method,
      url: url,
      requestTabIndex: 0,
      requestHeaders: requestHeaders,
      requestParams: requestParams,
      requestBodyContentType: requestBodyContentType,
      requestBody: requestBody,
      responseStatus: responseStatus,
      message: message,
      responseModel: responseModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "method": method.name,
      "url": url,
      "requestHeaders": rowsToMap(requestHeaders),
      "requestParams": rowsToMap(requestParams),
      "requestBodyContentType": requestBodyContentType.name,
      "requestBody": requestBody,
      "responseStatus": responseStatus,
      "message": message,
      "responseModel": responseModel?.toJson(),
    };
  }

  @override
  String toString() {
    return [
      "Request Id: $id",
      "Request Method: ${method.name}",
      "Request URL: $url",
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
