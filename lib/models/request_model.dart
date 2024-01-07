import 'dart:io';
import 'package:flutter/foundation.dart';
import '../utils/utils.dart'
    show
        mapListToFormDataModelRows,
        rowsToFormDataMapList,
        mapToRows,
        rowsToMap,
        getEnabledRows;
import '../consts.dart';
import 'models.dart';

@immutable
class RequestModel {
  const RequestModel({
    required this.id,
    this.method = HTTPVerb.get,
    this.url = "",
    this.name = "",
    this.description = "",
    this.requestTabIndex = 0,
    this.requestHeaders,
    this.requestParams,
    this.isHeaderEnabledList,
    this.isParamEnabledList,
    this.requestBodyContentType = ContentType.json,
    this.requestBody,
    this.requestFormDataList,
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
  final List<NameValueModel>? requestHeaders;
  final List<NameValueModel>? requestParams;
  final List<bool>? isHeaderEnabledList;
  final List<bool>? isParamEnabledList;
  final ContentType requestBodyContentType;
  final String? requestBody;
  final List<FormDataModel>? requestFormDataList;
  final int? responseStatus;
  final String? message;
  final ResponseModel? responseModel;

  List<NameValueModel>? get enabledRequestHeaders =>
      getEnabledRows(requestHeaders, isHeaderEnabledList);
  List<NameValueModel>? get enabledRequestParams =>
      getEnabledRows(requestParams, isParamEnabledList);

  Map<String, String> get enabledHeadersMap =>
      rowsToMap(enabledRequestHeaders) ?? {};
  Map<String, String> get enabledParamsMap =>
      rowsToMap(enabledRequestParams) ?? {};
  Map<String, String> get headersMap => rowsToMap(requestHeaders) ?? {};
  Map<String, String> get paramsMap => rowsToMap(requestParams) ?? {};

  List<Map<String, dynamic>> get formDataMapList =>
      rowsToFormDataMapList(requestFormDataList) ?? [];
  bool get isFormDataRequest => requestBodyContentType == ContentType.formdata;

  bool get hasContentTypeHeader => enabledHeadersMap.keys
      .any((k) => k.toLowerCase() == HttpHeaders.contentTypeHeader);

  RequestModel duplicate({
    required String id,
  }) {
    return RequestModel(
      id: id,
      method: method,
      url: url,
      name: "$name (copy)",
      description: description,
      requestHeaders: requestHeaders != null ? [...requestHeaders!] : null,
      requestParams: requestParams != null ? [...requestParams!] : null,
      isHeaderEnabledList:
          isHeaderEnabledList != null ? [...isHeaderEnabledList!] : null,
      isParamEnabledList:
          isParamEnabledList != null ? [...isParamEnabledList!] : null,
      requestBodyContentType: requestBodyContentType,
      requestBody: requestBody,
      requestFormDataList:
          requestFormDataList != null ? [...requestFormDataList!] : null,
    );
  }

  RequestModel copyWith({
    String? id,
    HTTPVerb? method,
    String? url,
    String? name,
    String? description,
    int? requestTabIndex,
    List<NameValueModel>? requestHeaders,
    List<NameValueModel>? requestParams,
    List<bool>? isHeaderEnabledList,
    List<bool>? isParamEnabledList,
    ContentType? requestBodyContentType,
    String? requestBody,
    List<FormDataModel>? requestFormDataList,
    int? responseStatus,
    String? message,
    ResponseModel? responseModel,
  }) {
    var headers = requestHeaders ?? this.requestHeaders;
    var params = requestParams ?? this.requestParams;
    var enabledHeaders = isHeaderEnabledList ?? this.isHeaderEnabledList;
    var enabledParams = isParamEnabledList ?? this.isParamEnabledList;
    return RequestModel(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
      name: name ?? this.name,
      description: description ?? this.description,
      requestTabIndex: requestTabIndex ?? this.requestTabIndex,
      requestHeaders: headers != null ? [...headers] : null,
      requestParams: params != null ? [...params] : null,
      isHeaderEnabledList: enabledHeaders != null ? [...enabledHeaders] : null,
      isParamEnabledList: enabledParams != null ? [...enabledParams] : null,
      requestBodyContentType:
          requestBodyContentType ?? this.requestBodyContentType,
      requestBody: requestBody ?? this.requestBody,
      requestFormDataList: requestFormDataList ?? this.requestFormDataList,
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
    final isHeaderEnabledList = data["isHeaderEnabledList"] as List<bool>?;
    final isParamEnabledList = data["isParamEnabledList"] as List<bool>?;
    try {
      requestBodyContentType =
          ContentType.values.byName(data["requestBodyContentType"] as String);
    } catch (e) {
      requestBodyContentType = kDefaultContentType;
    }
    final requestBody = data["requestBody"] as String?;
    final requestFormDataList = data["requestFormDataList"];
    final responseStatus = data["responseStatus"] as int?;
    final message = data["message"] as String?;
    final responseModelJson = data["responseModel"];

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
      isHeaderEnabledList: isHeaderEnabledList,
      isParamEnabledList: isParamEnabledList,
      requestBodyContentType: requestBodyContentType,
      requestBody: requestBody,
      requestFormDataList: requestFormDataList != null
          ? mapListToFormDataModelRows(List<Map>.from(requestFormDataList))
          : null,
      responseStatus: responseStatus,
      message: message,
      responseModel: responseModel,
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
      "isHeaderEnabledList": isHeaderEnabledList,
      "isParamEnabledList": isParamEnabledList,
      "requestBodyContentType": requestBodyContentType.name,
      "requestBody": requestBody,
      "requestFormDataList": rowsToFormDataMapList(requestFormDataList),
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
      "Enabled Headers: ${isHeaderEnabledList.toString()}",
      "Request Params: ${requestParams.toString()}",
      "Enabled Params: ${isParamEnabledList.toString()}",
      "Request Body Content Type: ${requestBodyContentType.toString()}",
      "Request Body: ${requestBody.toString()}",
      "Request FormData: ${requestFormDataList.toString()}",
      "Response Status: $responseStatus",
      "Response Message: $message",
      "Response: ${responseModel.toString()}"
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
        listEquals(other.isHeaderEnabledList, isHeaderEnabledList) &&
        listEquals(other.isParamEnabledList, isParamEnabledList) &&
        other.requestBodyContentType == requestBodyContentType &&
        other.requestBody == requestBody &&
        other.requestFormDataList == requestFormDataList &&
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
      isHeaderEnabledList,
      isParamEnabledList,
      requestBodyContentType,
      requestBody,
      requestFormDataList,
      responseStatus,
      message,
      responseModel,
    );
  }
}
