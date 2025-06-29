import 'package:better_networking/better_networking.dart';
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
      var formDataStr = request.postData?.text;
      Map<String, String> parsedData = parseFormData(formDataStr);
      parsedData.forEach((key, value) {
        formDataType = FormDataType.text;
        var name = key;
        var val = value;
        formData.add(FormDataModel(
          name: name,
          value: val,
          type: formDataType,
        ));
      });
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

  Map<String, String> parseFormData(String? data) {
    // Return an empty map if the input is null or empty
    if (data == null || data.isEmpty) {
      return {};
    }
    // Split the input string into individual key-value pairs
    var pairs = data.split('&');

    // Create a Map to store key-value pairs
    Map<String, String> result = {};

    // Loop through the pairs and split them into keys and values
    for (var pair in pairs) {
      var keyValue = pair.split('=');

      // Ensure the pair contains both key and value
      if (keyValue.length == 2) {
        var key = Uri.decodeComponent(keyValue[0]);
        var value = Uri.decodeComponent(keyValue[1]);

        result[key] = value;
      }
    }

    return result;
  }
}
