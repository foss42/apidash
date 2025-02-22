import 'dart:convert';
import 'package:ollama_dart/ollama_dart.dart';

class OllamaService {
final OllamaClient _client;

OllamaService() : _client = OllamaClient(baseUrl: 'http://127.0.0.1:11434/api');

// Generate response
Future<String> generateResponse(String prompt) async {
final response = await _client.generateCompletion(
request: GenerateCompletionRequest(
model: 'llama3.2:1b',
prompt: prompt
),
);
return response.response.toString();
}

// Explain latest API request & response
Future<String> explainLatestApi({required dynamic requestModel, required dynamic responseModel}) async {
if (requestModel == null || responseModel == null) {
return "No recent API requests found";
}

// Extract request details
final method = requestModel.httpRequestModel?.method
    .toString()
    .split('.')
    .last
    .toUpperCase()
    ?? "GET";
final endpoint = requestModel.httpRequestModel?.url ?? "Unknown endpoint";
final headers = requestModel.httpRequestModel?.enabledHeadersMap ?? {};
final parameters = requestModel.httpRequestModel?.enabledParamsMap ?? {};
final body = requestModel.httpRequestModel?.body;

// Process response
final rawResponse = responseModel.body;
final responseBody = rawResponse is String
    ? jsonDecode(rawResponse)
    : rawResponse as Map<String, dynamic>?;
final statusCode = responseModel.statusCode ?? 0;


    
  final prompt = '''
    Analyze this API interaction 
Current API Request:
- Endpoint: $endpoint
- Method: $method
- Headers: ${headers.isNotEmpty ? jsonEncode(headers) : "None"}
- Parameters: ${parameters.isNotEmpty ? jsonEncode(parameters) : "None"}
- Body: ${body ?? "None"}

Current Response:
- Status Code: $statusCode
- Response Body: ${responseBody != null ? jsonEncode(responseBody) : rawResponse}


Required Analysis Format:

1. Start with overall status assessment
2. List validation/security issues
3. Highlight request/response mismatches
4. Suggest concrete improvements
5. Use plain text formatting with clear section headers

Response Structure:
API Request: [request details]
Response: [response details]
Analysis: [structured analysis]''';


return generateResponse(prompt);
}

Future<String> debugApi({required dynamic requestModel, required dynamic responseModel}) async {
if (requestModel == null || responseModel == null) {
return "There are no recent API Requests to debug.";
}

final requestJson = jsonEncode(requestModel.toJson());
final responseJson = jsonEncode(responseModel.toJson());
final statusCode = responseModel.statusCode;

final prompt = '''
Provide detailed debugging steps for this failed API request:

**Status Code:** $statusCode
**Request Details:**
$requestJson

**Response Details:**
$responseJson

Provide a step-by-step debugging guide including:
1. Common causes for this status code
2. Specific issues in the request
3. Potential fixes
4. Recommended next steps

Format the response with clear headings and bullet points.
''';

return generateResponse(prompt);



}


Future<String> generateTestCases({required dynamic requestModel, required dynamic responseModel}) async {

final endpoint = requestModel.httpRequestModel?.url ?? "Unknown endpoint";
final headers = requestModel.httpRequestModel?.enabledHeadersMap ?? {};
final parameters = requestModel.httpRequestModel?.enabledParamsMap ?? {};
final body = requestModel.httpRequestModel?.body;
final method = requestModel.httpRequestModel?.method.toString().split('.').last.toUpperCase() ?? "GET";
// Process response
// final rawResponse = responseModel.body;
// final responseBody = rawResponse is String
//     ? jsonDecode(rawResponse)
//     : rawResponse as Map<String, dynamic>?;
  final statusCode = responseModel.statusCode ?? 0;
  final exampleParams = await generateExampleParams(
      requestModel: requestModel,
      responseModel: responseModel,
    );
    final prompt = '''
Generate  test cases for the following API:

**API Request:**
- **Endpoint:** `$endpoint`
- **Method:** `$method`
- **Headers:** ${headers.isNotEmpty ? jsonEncode(headers) : "None"}
- **Parameters:** ${parameters.isNotEmpty ? jsonEncode(parameters) : "None"}

**Test Case Requirements:**
1. Normal case (valid input, expected success)
2. Edge case (unexpected or boundary values)
3. Missing required parameters
4. Invalid authentication (if applicable)
5. Error handling for different status codes

**Example Test Case Format:**
@Test
void testValidRequest() {
  final response = sendRequest("$endpoint", method: "$method", params: $exampleParams);
  assert(response.status == 200);
}
\`\`\`

Generate test cases covering all scenarios.
''';

    return generateResponse(prompt);
  }

  /// Generate example parameter values based on parameter names
  Future<Map<String, dynamic>> generateExampleParams({
  required dynamic requestModel,
  required dynamic responseModel,
}) async {
  final ollamaService = OllamaService();
  final String apiEndpoint = requestModel.httpRequestModel?.url ?? "Unknown Endpoint";
  final String apiMethod = requestModel.httpRequestModel?.method.name ?? "GET";
  final Map<String, String> apiHeaders = requestModel.httpRequestModel?.enabledHeadersMap ?? {};
  final Map<String, String> apiParams = requestModel.httpRequestModel?.enabledParamsMap ?? {};
  final String? apiBody = requestModel.httpRequestModel?.body;

  final dynamic rawResponse = responseModel?.body;
  final Map<String, dynamic>? apiResponse =
      (rawResponse is String) ? jsonDecode(rawResponse) : rawResponse is Map<String, dynamic> ? rawResponse : null;

  // Construct LLM prompt to analyze and extract meaningful test cases
  final String prompt = '''
Analyze the following API request and generate structured example parameters.

**API Request:**
- **Endpoint:** `$apiEndpoint`
- **Method:** `$apiMethod`
- **Headers:** ${apiHeaders.isNotEmpty ? jsonEncode(apiHeaders) : "None"}
- **Parameters:** ${apiParams.isNotEmpty ? jsonEncode(apiParams) : "None"}
- **Body:** ${apiBody ?? "None"}

**Response:**
- **Status Code:** ${responseModel?.statusCode ?? "Unknown"}
- **Response Body:** ${apiResponse != null ? jsonEncode(apiResponse) : rawResponse}

### **Required Output Format**
1. **Standard Example Values**: Assign the most appropriate example values for each parameter.
2. **Edge Cases**: Provide at least 2 edge cases per parameter.
3. **Invalid Cases**: Generate invalid inputs for error handling.
4. **Output must be in valid JSON format.**
''';

  // Force LLM to return structured JSON output
  final String response = await ollamaService.generateResponse(prompt);

  try {
    return jsonDecode(response) as Map<String, dynamic>;
  } catch (e) {
    return {"error": "Failed to parse response from LLM."};
  }

}

}