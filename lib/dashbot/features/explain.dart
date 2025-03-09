import 'dart:convert';
import '../services/dashbot_service.dart';
import 'package:apidash/models/request_model.dart';

class ExplainFeature {
  final DashBotService _service;

  ExplainFeature(this._service);

  Future<String> explainLatestApi({
    required RequestModel? requestModel,
    required dynamic responseModel,
  }) async {
    if (requestModel == null || responseModel == null) {
      return "No recent API requests found.";
    }

    if (requestModel.httpRequestModel?.url == null) {
      return "Error: Invalid API request (missing endpoint).";
    }

    final method = requestModel.httpRequestModel?.method
            .toString()
            .split('.')
            .last
            .toUpperCase() ??
        "GET";
    final endpoint = requestModel.httpRequestModel!.url;
    final headers = requestModel.httpRequestModel?.enabledHeadersMap ?? {};
    final parameters = requestModel.httpRequestModel?.enabledParamsMap ?? {};
    final body = requestModel.httpRequestModel?.body;
    final rawResponse = responseModel.body;
    final responseBody =
        rawResponse is String ? rawResponse : jsonEncode(rawResponse);
    final statusCode = responseModel.statusCode ?? 0;

    final prompt = '''
FOCUSED API INTERACTION BREAKDOWN

**Essential Request Details:**
- Endpoint Purpose: What is this API endpoint designed to do?
- Interaction Type: Describe the core purpose of this specific request

**Request Mechanics:**
- Exact Endpoint: $endpoint
- HTTP Method: $method
- Key Parameters: ${parameters.isNotEmpty ? 'Specific inputs driving the request' : 'No custom parameters'}

**Response CORE Insights:**
- Status: Success or Failure?
- Key Data Extracted: What CRITICAL information does the response contain?

**Precise Analysis Requirements:**
1. Explain the API's PRIMARY function in ONE clear sentence
2. Identify the MOST IMPORTANT piece of information returned
3. Describe the PRACTICAL significance of this API call

AVOID:
- Technical jargon
- Unnecessary details
- Verbose explanations

Deliver a CRYSTAL CLEAR, CONCISE explanation that anyone can understand.
''';

    return _service.generateResponse(prompt);
  }
}
