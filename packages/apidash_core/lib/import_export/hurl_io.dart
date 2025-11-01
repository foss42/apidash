import 'dart:convert';
import 'package:genai/genai.dart';
import 'package:hurl/hurl.dart';

class HurlIO {
  /// Parses a Hurl file and returns a list of HttpRequestModel objects
  /// Returns null if parsing fails
  List<(String?, HttpRequestModel)>? getHttpRequestModelList(String content) {
    content = content.trim();
    try {
      // Parse Hurl file using Rust parser
      final jsonStr = parseHurlToJson(content: content);
      final jsonData = jsonDecode(jsonStr) as Map<String, dynamic>;
      final entries = jsonData['entries'] as List<dynamic>;

      return entries.map((entry) {
        final entryMap = entry as Map<String, dynamic>;
        return _hurlEntryToHttpRequestModel(entryMap);
      }).toList();
    } catch (e) {
      // Return null if parsing fails
      return null;
    }
  }

  /// Converts a single Hurl entry to HttpRequestModel
  (String?, HttpRequestModel) _hurlEntryToHttpRequestModel(
      Map<String, dynamic> entry) {
    // Extract method
    HTTPVerb method;
    try {
      final methodStr = entry['method'] as String? ?? 'GET';
      method = HTTPVerb.values.byName(methodStr.toLowerCase());
    } catch (e) {
      method = kDefaultHttpMethod;
    }

    // Extract URL
    final url = entry['url'] as String? ?? '';
    final urlWithoutParams = stripUrlParams(url);

    // Extract headers
    final headersList = entry['headers'] as List<dynamic>? ?? [];
    final headers = headersList.map((h) {
      final headerMap = h as Map<String, dynamic>;
      return NameValueModel(
        name: headerMap['name'] as String? ?? '',
        value: headerMap['value'] as String? ?? '',
      );
    }).toList();

    // Extract query parameters from URL
    final uri = Uri.tryParse(url);
    var params = uri?.queryParameters.entries.map((e) {
          return NameValueModel(name: e.key, value: e.value);
        }).toList() ??
        [];

    // Add query parameters from [QueryStringParams] section if present
    final queryParamsList = entry['queryParams'] as List<dynamic>?;
    if (queryParamsList != null && queryParamsList.isNotEmpty) {
      final sectionParams = queryParamsList.map((p) {
        final paramMap = p as Map<String, dynamic>;
        return NameValueModel(
          name: paramMap['name'] as String? ?? '',
          value: paramMap['value'] as String? ?? '',
        );
      }).toList();
      params = [...params, ...sectionParams];
    }

    // Handle Basic Auth - convert to Authorization header
    final basicAuthMap = entry['basicAuth'] as Map<String, dynamic>?;
    if (basicAuthMap != null) {
      final username = basicAuthMap['username'] as String? ?? '';
      final password = basicAuthMap['password'] as String? ?? '';
      final credentials = base64Encode(utf8.encode('$username:$password'));
      headers.add(NameValueModel(
        name: 'Authorization',
        value: 'Basic $credentials',
      ));
    }

    // Extract request body
    ContentType bodyContentType = kDefaultContentType;
    String? body;
    List<FormDataModel>? formData;

    // Check for JSON/text body
    final bodyStr = entry['body'] as String?;
    if (bodyStr != null && bodyStr.isNotEmpty) {
      // Try to detect if it's JSON
      try {
        jsonDecode(bodyStr);
        bodyContentType = ContentType.json;
        body = bodyStr;
      } catch (e) {
        // Not JSON, treat as text
        bodyContentType = ContentType.text;
        body = bodyStr;
      }
    }

    // Check for form data from [FormParams] section
    final formParamsList = entry['formParams'] as List<dynamic>?;
    if (formParamsList != null && formParamsList.isNotEmpty) {
      bodyContentType = ContentType.formdata;
      formData = formParamsList.map((p) {
        final paramMap = p as Map<String, dynamic>;
        return FormDataModel(
          name: paramMap['name'] as String? ?? '',
          value: paramMap['value'] as String? ?? '',
          type: FormDataType.text,
        );
      }).toList();
      body = null; // Clear body when using form data
    }

    final requestModel = HttpRequestModel(
      method: method,
      url: urlWithoutParams,
      headers: headers,
      params: params,
      body: body,
      bodyContentType: bodyContentType,
      formData: formData,
    );

    return (url, requestModel);
  }
}
