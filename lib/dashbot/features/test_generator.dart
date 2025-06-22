import 'dart:convert';
import '../services/services.dart';
import '../../models/models.dart';

class TestGeneratorFeature {
  final DashBotService _service;

  TestGeneratorFeature(this._service);

  Future<String> generateApiTests({
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
    final rawResponse = responseModel.body;
    final responseBody =
        rawResponse is String ? rawResponse : jsonEncode(rawResponse);
    final statusCode = responseModel.statusCode ?? 0;

    Uri uri = Uri.parse(endpoint);
    final baseUrl = "${uri.scheme}://${uri.host}";
    final path = uri.path;

    final parameterAnalysis = _analyzeParameters(uri.queryParameters);

    final prompt = """
EXECUTABLE API TEST CASES GENERATOR

**API Analysis:**
- Base URL: $baseUrl
- Endpoint: $path
- Method: $method
- Current Parameters: ${uri.queryParameters}
- Current Response: $responseBody (Status: $statusCode)
- Parameter Types: $parameterAnalysis

**Test Generation Task:**
Generate practical, ready-to-use test cases for this API in cURL format. Each test should be executable immediately.

Include these test categories:
1. **Valid Cases**: Different valid parameter values (use real-world examples like other country codes if this is a country API)
2. **Invalid Parameter Tests**: Missing parameters, empty values, incorrect formats
3. **Edge Cases**: Special characters, long values, unexpected inputs
4. **Validation Tests**: Test input validation and error handling

For each test case:
1. Provide a brief description of what the test verifies
2. Include a complete, executable cURL command
3. Show the expected outcome (status code and sample response)
4. Organize tests in a way that's easy to copy and run

Focus on creating realistic test values based on the API context (e.g., for a country flag API, use real country codes, invalid codes, etc.)
""";

    final testCases = await _service.generateResponse(prompt);
    return "TEST_CASES_HIDDEN\n$testCases";
  }

  String _analyzeParameters(Map<String, String> parameters) {
    if (parameters.isEmpty) {
      return "No parameters detected";
    }

    Map<String, String> analysis = {};

    parameters.forEach((key, value) {
      if (RegExp(r'^[A-Z]{3}$').hasMatch(value)) {
        analysis[key] =
            "Appears to be a 3-letter country code (ISO 3166-1 alpha-3)";
      } else if (RegExp(r'^[A-Z]{2}$').hasMatch(value)) {
        analysis[key] =
            "Appears to be a 2-letter country code (ISO 3166-1 alpha-2)";
      } else if (RegExp(r'^\d+$').hasMatch(value)) {
        analysis[key] = "Numeric value";
      } else if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
        analysis[key] = "Alphabetic string";
      } else {
        analysis[key] = "Unknown format: $value";
      }
    });

    return jsonEncode(analysis);
  }
}
