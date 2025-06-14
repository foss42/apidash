import 'dart:convert';
import '../services/dashbot_service.dart';
import 'package:apidash/models/request_model.dart';

class DebugFeature {
  final DashBotService _service;

  DebugFeature(this._service);

  Future<String> debugApi({
    required RequestModel? requestModel,
    required dynamic responseModel,
  }) async {
    if (requestModel == null || responseModel == null) {
      return "No recent API requests found.";
    }

    final method = requestModel.httpRequestModel?.method
            .toString()
            .split('.')
            .last
            .toUpperCase() ??
        "GET";
    final endpoint = requestModel.httpRequestModel?.url ?? "Unknown Endpoint";
    final headers = requestModel.httpRequestModel?.enabledHeadersMap ?? {};
    final parameters = requestModel.httpRequestModel?.enabledParamsMap ?? {};
    final body = requestModel.httpRequestModel?.body;
    final rawResponse = responseModel.body;
    final responseBody =
        rawResponse is String ? rawResponse : jsonEncode(rawResponse);
    final statusCode = responseModel.statusCode ?? 0;

    final prompt = """
URGENT API DEBUG ANALYSIS

**Request Overview:**
- Endpoint: $endpoint
- Method: $method
- Status Code: $statusCode

**Debugging Instructions:**
Provide a PRECISE, TEXT-ONLY explanation that:
1. Identifies the EXACT problem
2. Explains WHY the request failed
3. Describes SPECIFIC steps to resolve the issue
4. NO CODE SNIPPETS ALLOWED

**Request Details:**
- Headers: ${headers.isNotEmpty ? jsonEncode(headers) : "No headers"}
- Parameters: ${parameters.isNotEmpty ? jsonEncode(parameters) : "No parameters"}
- Request Body: ${body ?? "Empty body"}

**Response Context:**
```
$responseBody
```

Provide a CLEAR, ACTIONABLE solution in the SIMPLEST possible language.
""";

    return _service.generateResponse(prompt);
  }
}
