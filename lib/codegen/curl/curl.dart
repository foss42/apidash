import 'package:apidash_core/models/http_request_model.dart';

class CurlCodeGen {
  String getCode(HttpRequestModel requestModel) {
    final url = requestModel.url;
    final method = requestModel.method.name.toLowerCase();
    
    // Start building curl command
    String curlCommand = 'curl';

    // Add method
    if (method != 'get') {
      curlCommand += ' -X ${method.toUpperCase()}';
    }

    // Add headers
    final headers = requestModel.enabledHeaders ?? [];
    for (final header in headers) {
      // Escape special characters in header values
      final escapedValue = header.value.replaceAll('"', '\\"');
      curlCommand += ' -H "${header.name}: $escapedValue"';
    }

    // Add body for POST, PUT, PATCH methods
    if (requestModel.hasJsonData) {
      curlCommand += ' -d \'${requestModel.body}\'';
      curlCommand += ' -H "Content-Type: application/json"';
    } else if (requestModel.hasTextData) {
      curlCommand += ' -d "${requestModel.body}"';
    }

    // Add URL at the end
    curlCommand += ' "$url"';

    return curlCommand;
  }
}
