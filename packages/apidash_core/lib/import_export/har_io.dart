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

    final postData = request.postData;
    final bodyMediaType = getMediaTypeFromContentType(postData?.mimeType);

    if (bodyMediaType != null) {
      if (bodyMediaType.subtype.contains('json')) {
        bodyContentType = ContentType.json;
        body = postData?.text;
      } else if (bodyMediaType.mimeType ==
          'application/x-www-form-urlencoded') {
        bodyContentType = ContentType.formdata;
        parseFormData(postData?.text).forEach((key, value) {
          formData.add(
            FormDataModel(name: key, value: value, type: FormDataType.text),
          );
        });
      } else if (bodyMediaType.type == 'multipart' &&
          bodyMediaType.subtype == 'form-data') {
        bodyContentType = ContentType.formdata;
        for (var fd in postData?.params ?? <har.Param>[]) {
          final isText =
              getMediaTypeFromContentType(fd.contentType)?.mimeType ==
              'text/plain';
          formData.add(
            FormDataModel(
              name: fd.name ?? "",
              value: (isText ? fd.value : fd.fileName) ?? "",
              type: isText ? FormDataType.text : FormDataType.file,
            ),
          );
        }
      } else {
        bodyContentType = ContentType.text;
        body = postData?.text;
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
      formData: formData,
    );
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
      var separatorIndex = pair.indexOf('=');

      // Ensure the pair contains both key and value
      if (separatorIndex != -1) {
        var key = Uri.decodeComponent(
          pair.substring(0, separatorIndex).replaceAll('+', ' '),
        );
        var value = Uri.decodeComponent(
          pair.substring(separatorIndex + 1).replaceAll('+', ' '),
        );

        result[key] = value;
      }
    }

    return result;
  }
}
