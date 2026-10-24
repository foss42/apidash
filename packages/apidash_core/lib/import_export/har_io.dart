import 'dart:convert';
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
    if (postData != null) {
      final rawMime = postData.mimeType?.trim();
      final mediaType = getMediaTypeFromContentType(rawMime);
      final normalizedMime =
          mediaType?.mimeType ?? rawMime?.split(';').first.trim().toLowerCase();

      final hasExplicitMime =
          normalizedMime != null && normalizedMime.isNotEmpty;

      final isJson =
          hasExplicitMime &&
          (mediaType != null
              ? (mediaType.mimeType == "application/json" ||
                    mediaType.mimeType == "text/json" ||
                    mediaType.subtype == "json" ||
                    mediaType.subtype.endsWith("+json"))
              : (normalizedMime == "application/json" ||
                    normalizedMime == "text/json" ||
                    normalizedMime.endsWith("+json")));

      final isUrlEncoded =
          hasExplicitMime &&
          (mediaType != null
              ? (mediaType.type == kTypeApplication &&
                    mediaType.subtype == kSubTypeXWwwFormUrlencoded)
              : normalizedMime == "application/x-www-form-urlencoded");

      final isMultipart =
          hasExplicitMime &&
          (mediaType != null
              ? (mediaType.type == kTypeMultipart &&
                    mediaType.subtype == kSubTypeFormData)
              : normalizedMime == "multipart/form-data");

      if (isJson) {
        bodyContentType = ContentType.json;
        body = postData.text;
      } else if (isUrlEncoded) {
        bodyContentType = ContentType.formdata;
        var formDataStr = postData.text;
        Map<String, String> parsedData = parseFormData(formDataStr);
        parsedData.forEach((key, value) {
          formData.add(
            FormDataModel(name: key, value: value, type: FormDataType.text),
          );
        });
        if (formData.isEmpty && (postData.params?.isNotEmpty ?? false)) {
          for (var param in postData.params!) {
            formData.add(
              FormDataModel(
                name: param.name ?? "",
                value: param.value ?? "",
                type: FormDataType.text,
              ),
            );
          }
        }
      } else if (isMultipart) {
        bodyContentType = ContentType.formdata;
        for (var fd in postData.params ?? <har.Param>[]) {
          final FormDataType formDataType;
          final String? val;
          final hasFileName = fd.fileName != null && fd.fileName!.isNotEmpty;
          if (hasFileName) {
            formDataType = FormDataType.file;
            val = fd.fileName;
          } else if (fd.contentType != null &&
              fd.contentType!.trim().isNotEmpty) {
            final paramMediaType = getMediaTypeFromContentType(fd.contentType);
            final isTextParam = paramMediaType != null
                ? (paramMediaType.type == kTypeText ||
                      paramMediaType.mimeType == 'text/plain')
                : (fd.contentType!.trim().toLowerCase().startsWith('text/') ||
                      fd.contentType!.trim().toLowerCase() == 'text/plain');
            if (isTextParam) {
              formDataType = FormDataType.text;
              val = fd.value;
            } else {
              formDataType = FormDataType.file;
              val = hasFileName ? fd.fileName : fd.value;
            }
          } else {
            formDataType = FormDataType.text;
            val = fd.value;
          }
          formData.add(
            FormDataModel(
              name: fd.name ?? "",
              value: val ?? "",
              type: formDataType,
            ),
          );
        }
        if (formData.isEmpty && (postData.text?.isNotEmpty ?? false)) {
          bodyContentType = ContentType.text;
          body = postData.text;
        }
      } else if (hasExplicitMime) {
        // Any other explicit MIME type (text/plain, application/xml, text/csv,
        // application/octet-stream, application/yaml, etc.) is retained as text.
        bodyContentType = ContentType.text;
        body = postData.text;
      } else {
        // No MIME type provided: fallback to sniffing or raw text.
        if (postData.text != null && postData.text!.isNotEmpty) {
          body = postData.text;
          try {
            jsonDecode(body!);
            bodyContentType = ContentType.json;
          } catch (_) {
            bodyContentType = ContentType.text;
          }
        } else if (postData.text != null) {
          body = postData.text;
          bodyContentType = ContentType.text;
        } else if (postData.params != null && postData.params!.isNotEmpty) {
          bodyContentType = ContentType.formdata;
          for (var param in postData.params!) {
            formData.add(
              FormDataModel(
                name: param.name ?? "",
                value: param.value ?? "",
                type: FormDataType.text,
              ),
            );
          }
        }
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
