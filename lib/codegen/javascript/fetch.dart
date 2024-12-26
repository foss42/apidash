import 'dart:convert';

import 'package:apidash_core/models/http_request_model.dart';

class JavaScriptFetchCodeGen {
  String getCode(HttpRequestModel requestModel) {
    final url = requestModel.url;
    final method = requestModel.method.name.toLowerCase();
    
    // Prepare headers
    String headersCode = '';
    final headers = requestModel.enabledHeaders ?? [];
    if (headers.isNotEmpty) {
      headersCode = 'const headers = {\n';
      for (final header in headers) {
        // Properly escape header values
        final escapedValue = header.value.replaceAll("'", "\\'");
        headersCode += "  '${header.name}': '$escapedValue',\n";
      }
      headersCode += '};\n\n';
    }

    // Prepare request options
    String requestOptions = '';
    if (headersCode.isNotEmpty) {
      requestOptions += 'headers,\n';
    }

    // Add body if exists
    if (requestModel.hasJsonData) {
      requestOptions += 'body: JSON.stringify(${_convertJsonBody(requestModel.body)}),\n';
    } else if (requestModel.hasTextData) {
      requestOptions += 'body: `${requestModel.body}`,\n';
    }

    // Generate code
    String code = '''
$headersCode
fetch('$url', {
  method: '$method',
  $requestOptions
})
  .then(response => response.text())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
''';

    return code;
  }

  // Helper method to convert JSON to JavaScript object
  String _convertJsonBody(String? jsonBody) {
    if (jsonBody == null || jsonBody.isEmpty) return '{}';
    
    try {
      // Parse and re-stringify to ensure valid JSON
      final parsedJson = json.decode(jsonBody);
      return json.encode(parsedJson);
    } catch (e) {
      // If parsing fails, return an empty object
      return '{}';
    }
  }
}
