import 'dart:convert';
import 'package:ollama_dart/ollama_dart.dart';

class OllamaService {
  final OllamaClient _client;

  OllamaService() : _client = OllamaClient(baseUrl: 'http://127.0.0.1:11434/api');

  // Generate response
  Future<String> generateResponse(String prompt) async {
    final response = await _client.generateCompletion(
      request: GenerateCompletionRequest(
          model: 'llama3.2:3b',
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
    final responseBody = rawResponse is String;
    final statusCode = responseModel.statusCode ?? 0;

    final prompt = '''
Analyze this API interaction following these examples:

Current API Request:
- Endpoint: $endpoint
- Method: $method
- Headers: ${headers.isNotEmpty ? jsonEncode(headers) : "None"}
- Parameters: ${parameters.isNotEmpty ? jsonEncode(parameters) : "None"}
- Body: ${body ?? "None"}

Current Response:
- Status Code: $statusCode
- Response Body: ${jsonEncode(responseBody)}

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

  // Debugging Failed API Requests
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

  // Generating test cases for API
  Future<String> generateTestCases({required dynamic requestModel, required dynamic responseModel}) async {

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
    final responsebody=responseModel.body;
    final exampleParams = await generateExampleParams(
      requestModel: requestModel,
      responseModel: responseModel,
    );
    final prompt = '''
**API Request:**
- **Endpoint:** `$endpoint`
- **Method:** `$method`
- **Headers:** ${headers.isNotEmpty ? jsonEncode(headers) : "None"}
- **Parameters:** ${parameters.isNotEmpty ? jsonEncode(parameters) : "None"}
-**body:** ${body ?? "None"}

here is an example test case for the given:$exampleParams

**Instructions:**
- Generate example parameter values for the request.
-Generate the url of as i provided in the api reuest 
-generate same to same type of test case url for test purpose 
''';

    return generateResponse(prompt);
  }

  // Generating Example Programming on API for different languages
  Future<Map<String, dynamic>> generateExampleParams({required dynamic requestModel, required dynamic responseModel,}) async {
    final ollamaService = OllamaService();

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


    final dynamic rawResponse = responseModel?.body;
    final Map<String, dynamic>? apiResponse =
    (rawResponse is String) ? jsonDecode(rawResponse) : rawResponse is Map<String, dynamic> ? rawResponse : null;

    // Construct LLM prompt to analyze and extract meaningful test cases
    final String prompt = '''
Analyze the following API request and generate structured example parameters.

**API Request:**
- **Endpoint:** `$endpoint`
- **Method:** `$method`
- **Headers:** ${headers.isNotEmpty ? jsonEncode(headers) : "None"}
- **Parameters:** ${parameters.isNotEmpty ? jsonEncode(parameters) : "None"}
- **Body:** ${body ?? "None"}


**Instructions:**
- Generate example parameter values for the request.
-Generate the url of as i provided in the api reuest 
generate same to same type of test case url for test purpose 

''';

    // Force LLM to return structured JSON output
    final String response = await ollamaService.generateResponse(prompt);

    try {
      return jsonDecode(response) as Map<String, dynamic>;
    } catch (e) {
      return {"error": "Failed to parse response from LLM."};
    }

  }

  Future<String> generateCode({required dynamic requestModel, required dynamic responseModel, required String language}) async {
    final method = requestModel.httpRequestModel?.method
        ?.toString()
        ?.split('.')
        ?.last
        ?.toUpperCase() ?? "GET";
    final endpoint = requestModel.httpRequestModel?.url ?? "Unknown endpoint";
    final headers = requestModel.httpRequestModel?.enabledHeadersMap ?? {};
    final params = requestModel.httpRequestModel?.enabledParamsMap ?? {};
    final body = requestModel.httpRequestModel?.body;
    final responseBody = responseModel.body;

    final prompt = '''
Generate complete $language code for this API integration:

API Request:
- URL: $endpoint
- Method: $method
- Headers: ${headers.isEmpty ? 'None' : jsonEncode(headers)}
- Params: ${params.isEmpty ? 'None' : jsonEncode(params)}
- Body: ${body ?? 'None'}

Response Structure:
${_formatResponse(responseBody)}

Requirements:
1. Single-file solution with no external config
2. Direct API URL implementation
3. Error handling for network/status errors
4. UI components matching response data
5. Ready-to-run code with example data display

Generate complete implementation code only.
''';

    return generateResponse(prompt);
  }

  String _formatResponse(dynamic response) {
    if (response is Map) {
      return response.entries
          .map((e) => '${e.key}: ${_valueType(e.value)}')
          .join('\n');
    }
    return response?.toString() ?? 'No response body';
  }

  String _valueType(dynamic value) {
    if (value is List) return 'List[${value.isNotEmpty ? _valueType(value.first) : '?'}]';
    if (value is Map) return 'Object';
    return value.runtimeType.toString();
  }
}
