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

    final method = requestModel.httpRequestModel?.method.toString().split('.').last.toUpperCase() ?? "GET";
    final endpoint = requestModel.httpRequestModel!.url!;
    final headers = requestModel.httpRequestModel?.enabledHeadersMap ?? {};
    final parameters = requestModel.httpRequestModel?.enabledParamsMap ?? {};
    final body = requestModel.httpRequestModel?.body;
    final rawResponse = responseModel.body;
    final responseBody = rawResponse is String ? rawResponse : jsonEncode(rawResponse);
    final statusCode = responseModel.statusCode ?? 0;

    final prompt = '''
Analyze this API interaction and **identify discrepancies**:

**API Request:**
- Endpoint: `$endpoint`
- Method: `$method`
- Headers: ${headers.isNotEmpty ? jsonEncode(headers) : "None"}
- Parameters: ${parameters.isNotEmpty ? jsonEncode(parameters) : "None"}
- Body: ${body ?? "None"}

**API Response:**
- Status Code: $statusCode
- Body: 
\`\`\`json
$responseBody
\`\`\`

**Instructions:**
1. Start with a **summary** of the API interaction.
2. List **validation issues** (e.g., missing headers, invalid parameters).
3. Highlight **request/response mismatches** (e.g., unexpected data types, missing fields).
4. Suggest **concrete improvements** (e.g., fix parameters, add error handling).

**Format:**
- Use Markdown with headings (`##`, `###`).
- Include bullet points for clarity.
''';

    return _service.generateResponse(prompt);
  }
}
