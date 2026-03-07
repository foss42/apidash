import 'dart:convert';

import 'package:curl_parser/curl_parser.dart';
import 'package:genai/genai.dart';

/// Converts a [Curl] model to an [HttpRequestModel].
///
/// Extracts URL, method, headers, query parameters, body, and form data
/// from the provided [Curl] object and creates an [HttpRequestModel].
///
/// Returns the converted [HttpRequestModel].
HttpRequestModel convertCurlToHttpRequestModel(Curl curl) {
  final url = stripUriParams(curl.uri);
  final method = HTTPVerb.values.byName(curl.method.toLowerCase());

  // Create mutable headers map
  final headersMap = Map<String, String>.from(curl.headers ?? {});

  // Helper functions
  bool hasHeader(String key) =>
      headersMap.keys.any((k) => k.toLowerCase() == key.toLowerCase());
  void setIfMissing(String key, String? value) {
    if (value == null || value.isEmpty) return;
    if (!hasHeader(key)) headersMap[key] = value;
  }

  // Map cookie to Cookie header if not present
  setIfMissing('Cookie', curl.cookie);
  // Map user agent and referer to headers if not present
  setIfMissing('User-Agent', curl.userAgent);
  setIfMissing('Referer', curl.referer);
  // Map -u user:password to Authorization: Basic ... if not already present
  if (!hasHeader('Authorization') && (curl.user?.isNotEmpty ?? false)) {
    final basic = base64.encode(utf8.encode(curl.user!));
    headersMap['Authorization'] = 'Basic $basic';
  }

  final headers = mapToRows(headersMap) ?? <NameValueModel>[];
  final params = mapToRows(curl.uri.queryParameters) ?? <NameValueModel>[];
  final body = curl.data ?? '';
  // Clear file paths in form data to avoid permission issues
  // when accessing files from different systems
  final formData = curl.formData?.map((field) {
        return field.type == FormDataType.file
            ? FormDataModel(
                name: field.name,
                value: '',
                type: FormDataType.file,
              )
            : field;
      }).toList() ??
      <FormDataModel>[];
  // Determine content type based on form data and headers
  final ContentType contentType = curl.form
      ? ContentType.formdata
      : (getContentTypeFromHeadersMap(curl.headers) ?? ContentType.text);

  return HttpRequestModel(
    method: method,
    url: url,
    headers: headers,
    params: params,
    body: body,
    bodyContentType: contentType,
    formData: formData,
  );
}

/// Splits content into individual curl commands.
///
/// Handles both single and multiple curl commands by splitting on 'curl '
/// while preserving the delimiter for proper parsing.
///
/// Returns a list of curl command strings.
List<String> splitCurlCommands(String content) {
  final commands = <String>[];

  // Split on lines or use regex to find curl command patterns
  final lines = content.split('\n');
  final buffer = StringBuffer();

  for (final line in lines) {
    final trimmedLine = line.trim();

    // Start of a new curl command
    if (trimmedLine.startsWith('curl ')) {
      // Save previous command if exists
      if (buffer.isNotEmpty) {
        commands.add(buffer.toString().trim());
        buffer.clear();
      }
      buffer.writeln(line);
    } else if (buffer.isNotEmpty) {
      // Continuation of current curl command
      buffer.writeln(line);
    }
    // else: skip lines that are not part of a curl command
  }

  // Add last command if exists
  if (buffer.isNotEmpty) {
    commands.add(buffer.toString().trim());
  }

  // If no commands were found, try treating the whole content as one command
  // only if it starts with 'curl '
  if (commands.isEmpty && content.trim().startsWith('curl ')) {
    return [content];
  }

  return commands;
}
