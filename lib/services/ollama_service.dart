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
    final statusCode = responseModel.statusCode ?? 200;

    // Extract example values from successful response
    final responseBody = responseModel.body is String
        ? jsonDecode(responseModel.body)
        : responseModel.body;
    final exampleValues = _extractExampleValues(parameters, responseBody);

    final prompt = '''
Generate comprehensive test cases in JSON format for this API endpoint:

API Details:
- Endpoint: $endpoint
- Method: $method
- Headers: ${headers.isNotEmpty ? jsonEncode(headers) : "None"}
- Parameters: ${parameters.isNotEmpty ? jsonEncode(parameters) : "None"}
- Successful Response Example (${statusCode}): ${jsonEncode(responseBody)}

Test Case Requirements:
1. Structure tests in JSON format with arrays for different categories
2. Include valid parameter combinations from the actual request
3. Create edge cases using min/max values and boundary conditions
4. Generate invalid parameter combinations that trigger error responses
5. Include authentication failure scenarios if applicable
6. Mirror successful response structure in test expectations

JSON Template:
{
  "test_cases": {
    "valid": [
      {
        "name": "Test valid request with typical parameters",
        "parameters": { /* mirror actual parameter structure */ },
        "expected": {
          "status_code": ${statusCode},
          "body_patterns": { /* key fields to validate */ }
        }
      }
    ],
    "edge_cases": [
      {
        "name": "Test maximum limit boundary",
        "parameters": { /* edge values */ },
        "expected": { /* status and response patterns */ }
      }
    ],
    "invalid": [
      {
        "name": "Test missing required parameter",
        "parameters": { /* incomplete params */ },
        "expected": {
          "status_code": 400,
          "error_patterns": [ "missing field", "required" ]
        }
      }
    ]
  }
}

Example Values from Current Implementation:
${jsonEncode(exampleValues)}

Generation Guidelines:
- Use parameter names and structure from the actual request
- Base valid values on successful response patterns
- Derive edge cases from parameter types (e.g., string length, number ranges)
- Match error responses to observed API behavior
- Include authentication headers if present in original request
- Prioritize testing critical business logic endpoints

Generate the JSON test suite following this structure and guidelines.
''';

    return generateResponse(prompt);
  }

  Map<String, dynamic> _extractExampleValues( Map<String, String> parameters, dynamic responseBody) {
    final examples = <String, dynamic>{};

    // Extract parameter examples
    examples['parameters'] = parameters.map((k, v) =>
        MapEntry(k, _deriveValuePattern(v)));

    // Extract response body patterns
    if (responseBody is Map) {
      examples['response_patterns'] = responseBody.map((k, v) =>
          MapEntry(k, _deriveValuePattern(v)));
    }

    return examples;
  }

  String _deriveValuePattern(dynamic value) {
    if (value is num) return "{number}";
    if (value is String) {
      if (DateTime.tryParse(value) != null) return "{datetime}";
      if (value.contains('@')) return "{email}";
      return "{string}";
    }
    return "{value}";
  }
}
