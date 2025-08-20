import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:seed/seed.dart';
import '../extensions/extensions.dart';
import '../utils/utils.dart'
    show rowsToFormDataMapList, rowsToMap, getEnabledRows;
import '../consts.dart';
import 'auth/api_auth_model.dart';

part 'http_request_model.freezed.dart';
part 'http_request_model.g.dart';

@freezed
class HttpRequestModel with _$HttpRequestModel {
  const HttpRequestModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory HttpRequestModel({
    @Default(HTTPVerb.get) HTTPVerb method,
    @Default("") String url,
    List<NameValueModel>? headers,
    List<NameValueModel>? params,
    @Default(AuthModel(type: APIAuthType.none)) AuthModel? authModel,
    List<bool>? isHeaderEnabledList,
    List<bool>? isParamEnabledList,
    @Default(ContentType.json) ContentType bodyContentType,
    String? body,
    String? query,
    List<FormDataModel>? formData,
  }) = _HttpRequestModel;

  factory HttpRequestModel.fromJson(Map<String, Object?> json) =>
      _$HttpRequestModelFromJson(json);

  Map<String, String> get headersMap => rowsToMap(headers) ?? {};
  Map<String, String> get paramsMap => rowsToMap(params) ?? {};
  List<NameValueModel>? get enabledHeaders =>
      getEnabledRows(headers, isHeaderEnabledList);
  List<NameValueModel>? get enabledParams =>
      getEnabledRows(params, isParamEnabledList);

  Map<String, String> get enabledHeadersMap => rowsToMap(enabledHeaders) ?? {};
  Map<String, String> get enabledParamsMap => rowsToMap(enabledParams) ?? {};

  bool get hasContentTypeHeader => enabledHeadersMap.hasKeyContentType();
  bool get hasFormDataContentType => bodyContentType == ContentType.formdata;
  bool get hasJsonContentType => bodyContentType == ContentType.json;
  bool get hasTextContentType => bodyContentType == ContentType.text;
  int get contentLength => utf8.encode(body ?? "").length;
  bool get hasBody => hasJsonData || hasTextData || hasFormData;
  bool get hasJsonData =>
      kMethodsWithBody.contains(method) &&
      hasJsonContentType &&
      contentLength > 0;
  bool get hasTextData =>
      kMethodsWithBody.contains(method) &&
      hasTextContentType &&
      contentLength > 0;
  bool get hasFormData =>
      kMethodsWithBody.contains(method) &&
      hasFormDataContentType &&
      formDataMapList.isNotEmpty;
  bool get hasQuery => query?.isNotEmpty ?? false;
  List<FormDataModel> get formDataList => formData ?? <FormDataModel>[];
  List<Map<String, String>> get formDataMapList =>
      rowsToFormDataMapList(formDataList) ?? [];
  bool get hasFileInFormData => formDataList
      .map((e) => e.type == FormDataType.file)
      .any((element) => element);
}
