import 'dart:convert';
import '../services/services.dart';
import '../../models/models.dart';

class DocumentationFeature {
  final DashBotService _service;

  DocumentationFeature(this._service);

  Future<String> generateApiDocumentation({
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
API DOCUMENTATION GENERATION

**API Details:**
- Endpoint: $endpoint
- Method: $method
- Status Code: $statusCode

**Request Components:**
- Headers: ${headers.isNotEmpty ? jsonEncode(headers) : "None"}
- Query Parameters: ${parameters.isNotEmpty ? jsonEncode(parameters) : "None"}
- Request Body: ${body != null && body.isNotEmpty ? body : "None"}

**Response Example:**
```
$responseBody
```

**Documentation Instructions:**
Create comprehensive API documentation that includes:

1. **Overview**: A clear, concise description of what this API endpoint does
2. **Authentication**: Required authentication method based on headers
3. **Request Details**: All required and optional parameters with descriptions
4. **Response Structure**: Breakdown of response fields and their meanings
5. **Error Handling**: Possible error codes and troubleshooting
6. **Example Usage**: A complete code example showing how to call this API

Format in clean markdown with proper sections and code blocks where appropriate.
""";

    return _service.generateResponse(prompt);
  }
}
