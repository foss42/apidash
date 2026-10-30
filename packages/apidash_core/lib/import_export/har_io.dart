import 'package:genai/genai.dart';
import 'package:har/har.dart' as har;

class HarParserIO {
  List<(String?, HttpRequestModel)>? getHttpRequestModelList(String content) {
    content = content.trim();
    try {
      final hl = har.harLogFromJsonStr(content);
      final requests = har.getRequestsFromHarLog(hl);
      return requests
          .map((req) => (req.$2.url, harRequestToHttpRequestModel(req.$2)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  HttpRequestModel harRequestToHttpRequestModel(har.Request request) {
    HTTPVerb method;

    try {
      method = HTTPVerb.values.byName((request.method ?? "").toLowerCase());
    } catch (e) {
      method = kDefaultHttpMethod;
    }
    String url = stripUrlParams(request.url ?? "");
    List<NameValueModel> headers = [];
    List<bool> isHeaderEnabledList = [];

    List<NameValueModel> params = [];
    List<bool> isParamEnabledList = [];

    for (var header in request.headers ?? <har.Header>[]) {
      var name = header.name ?? "";
      var value = header.value;
      var activeHeader = header.disabled ?? false;
      headers.add(NameValueModel(name: name, value: value));
      isHeaderEnabledList.add(!activeHeader);
    }

    for (var query in request.queryString ?? <har.Query>[]) {
      var name = query.name ?? "";
      var value = query.value;
      var activeQuery = query.disabled ?? false;
      params.add(NameValueModel(name: name, value: value));
      isParamEnabledList.add(!activeQuery);
    }

    ContentType bodyContentType = kDefaultContentType;
    String? body;
    List<FormDataModel>? formData = [];

    if (request.postData?.mimeType == "application/json") {
      bodyContentType = ContentType.json;
      body = request.postData?.text;
    }
    FormDataType formDataType = FormDataType.text;
    if (request.postData?.mimeType == "application/x-www-form-urlencoded") {
      bodyContentType = ContentType.formdata;
      for (final (name, value) in parseFormData(request.postData?.text)) {
        formData.add(FormDataModel(
          name: name,
          value: value,
          type: FormDataType.text,
        ));
      }
    }

    if (request.postData?.mimeType == "multipart/form-data") {
      bodyContentType = ContentType.formdata;
      String? name, val;
      for (var fd in request.postData?.params ?? <har.Param>[]) {
        name = fd.name;
        if (fd.contentType == "text/plain") {
          formDataType = FormDataType.text;
          val = fd.value;
        } else {
          formDataType = FormDataType.file;
          val = fd.fileName;
        }
        formData.add(FormDataModel(
          name: name ?? "",
          value: val ?? "",
          type: formDataType,
        ));
      }
    }

    return HttpRequestModel(
        method: method,
        url: url,
        headers: headers,
        params: params,
        isHeaderEnabledList: isHeaderEnabledList,
        isParamEnabledList: isParamEnabledList,
        body: body,
        bodyContentType: bodyContentType,
        formData: formData);
  }

  /// A URL-encoded form body split into its fields, in the order they appear.
  ///
  /// A repeated name keeps one entry per occurrence, so `tag=red&tag=blue`
  /// imports as two fields instead of the last value overwriting the first.
  List<(String, String)> parseFormData(String? data) {
    if (data == null || data.isEmpty) {
      return [];
    }

    final result = <(String, String)>[];
    for (final pair in data.split('&')) {
      final separatorIndex = pair.indexOf('=');
      if (separatorIndex == -1) {
        continue;
      }
      final key = Uri.decodeComponent(
        pair.substring(0, separatorIndex).replaceAll('+', ' '),
      );
      final value = Uri.decodeComponent(
        pair.substring(separatorIndex + 1).replaceAll('+', ' '),
      );
      result.add((key, value));
    }

    return result;
  }
}
