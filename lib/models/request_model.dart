import 'package:flutter/foundation.dart';
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
    this.name = "",
    this.description = "",
    this.requestTabIndex = 0,
    this.requestHeaders,
    this.requestParams,
    this.requestBodyContentType = kDefaultContentType,
    this.codegenLanguage,
    this.requestBody,
    this.responseStatus,
    this.message,
    this.responseModel,
  });

  final String id;
  final HTTPVerb method;
  final String url;
  final String name;
  final String description;
  final int requestTabIndex;
  final List<KVRow>? requestHeaders;
  final List<KVRow>? requestParams;
  final ContentType requestBodyContentType;
  final CodegenLanguage? codegenLanguage;
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
      name: name,
      description: description,
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
    String? name,
    String? description,
    int? requestTabIndex,
    List<KVRow>? requestHeaders,
    List<KVRow>? requestParams,
    ContentType? requestBodyContentType,
    String? requestBody,
    int? responseStatus,
    String? message,
    ResponseModel? responseModel,
    CodegenLanguage? codegenLanguage,
  }) {
    return RequestModel(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
      name: name ?? this.name,
      description: description ?? this.description,
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
    final name = data["name"] as String?;
    final description = data["description"] as String?;
    final requestHeaders = data["requestHeaders"];
    final requestParams = data["requestParams"];
    try {
      requestBodyContentType =
          ContentType.values.byName(data["requestBodyContentType"] as String);
    } catch (e) {
      requestBodyContentType = kDefaultContentType;
    }
    final requestBody = data["requestBody"] as String?;
    final responseStatus = data["responseStatus"] as int?;
    final message = data["message"] as String?;
    final responseModelJson = data["responseModel"];
    final codegenLanguage = data["codegenLanguage"];
    if (responseModelJson != null) {
      responseModel =
          ResponseModel.fromJson(Map<String, dynamic>.from(responseModelJson));
    } else {
      responseModel = null;
    }

    return RequestModel(
      id: id,
      method: method,
      url: url,
      name: name ?? "",
      description: description ?? "",
      requestTabIndex: 0,
      requestHeaders: requestHeaders != null
          ? mapToRows(Map<String, String>.from(requestHeaders))
          : null,
      requestParams: requestParams != null
          ? mapToRows(Map<String, String>.from(requestParams))
          : null,
      requestBodyContentType: requestBodyContentType,
      requestBody: requestBody,
      responseStatus: responseStatus,
      message: message,
      responseModel: responseModel,
      codegenLanguage: codegenLanguage,
    );
  }

  Map<String, dynamic> toJson({bool includeResponse = true}) {
    return {
      "id": id,
      "method": method.name,
      "url": url,
      "name": name,
      "description": description,
      "requestHeaders": rowsToMap(requestHeaders),
      "requestParams": rowsToMap(requestParams),
      "requestBodyContentType": requestBodyContentType.name,
      "requestBody": requestBody,
      "responseStatus": includeResponse ? responseStatus : null,
      "message": includeResponse ? message : null,
      "responseModel": includeResponse ? responseModel?.toJson() : null,
    };
  }

  @override
  String toString() {
    return [
      "Request Id: $id",
      "Request Method: ${method.name}",
      "Request URL: $url",
      "Request Name: $name",
      "Request Description: $description",
      "Request Tab Index: ${requestTabIndex.toString()}",
      "Request Headers: ${requestHeaders.toString()}",
      "Request Params: ${requestParams.toString()}",
      "Request Body Content Type: ${requestBodyContentType.toString()}",
      "Request Body: ${requestBody.toString()}",
      "Response Status: $responseStatus",
      "Response Message: $message",
      "Response: ${responseModel.toString()}",
      "Codegen Language: ${codegenLanguage?.label.toString()}"
    ].join("\n");
  }

  @override
  bool operator ==(Object other) {
    return other is RequestModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.method == method &&
        other.url == url &&
        other.name == name &&
        other.description == description &&
        other.requestTabIndex == requestTabIndex &&
        listEquals(other.requestHeaders, requestHeaders) &&
        listEquals(other.requestParams, requestParams) &&
        other.requestBodyContentType == requestBodyContentType &&
        other.requestBody == requestBody &&
        other.responseStatus == responseStatus &&
        other.message == message &&
        other.responseModel == responseModel;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      method,
      url,
      name,
      description,
      requestTabIndex,
      requestHeaders,
      requestParams,
      requestBodyContentType,
      requestBody,
      responseStatus,
      message,
      responseModel,
    );
  }
}
