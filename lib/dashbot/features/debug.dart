import '../../models/request_model.dart';
import '../services/dashbot_service.dart';

class DebugFeature {
  final DashBotService _service;

  DebugFeature(this._service);

  Future<String> debugApi({
    required RequestModel? requestModel,
    required dynamic responseModel,
  }) async {
    // Handle case where no request or response is available
    if (requestModel == null || responseModel == null) {
      return "No recent API requests found.";
    }

    // Extract status code and error message from the response
    final statusCode = responseModel.statusCode ?? 0;
    final errorMessage = responseModel.body ?? "No error message available.";

    // Create a prompt for the AI to analyze the request and response
    final prompt = '''
Debug this API request based on the status code and error message:

**API Request:**
- Endpoint: `${requestModel.httpRequestModel?.url ?? "unknown"}`
- Method: `${requestModel.httpRequestModel?.method.toString().split('.').last.toUpperCase() ?? "GET"}`

**API Response:**
- Status Code: $statusCode
- Error Message: $errorMessage

**Instructions:**
- Explain what the status code $statusCode typically means.
- Suggest possible reasons for the error based on the status code and error message.
- Provide actionable steps to resolve the issue.
- Use Markdown for formatting with headings and bullet points.
''';

    // Use DashBotService to generate the AI response
    return _service.generateResponse(prompt);
  }
}
