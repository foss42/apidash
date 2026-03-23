import 'dart:convert';

import 'package:apidash/utils/utils.dart';
import 'package:apidash_core/apidash_core.dart';

import '../models/test_case_model.dart';

class AgenticTestGenerator {
  AgenticTestGenerator({
    required this.readDefaultModel,
  });

  final Map<String, dynamic>? Function() readDefaultModel;

  Future<List<AgenticTestCase>> generateTests({
    required String endpoint,
    String? method,
    Map<String, String>? headers,
    String? requestBody,
  }) async {
    final aiModelJson = readDefaultModel();
    if (aiModelJson == null) {
      throw StateError(
        'No default AI model is configured. Select one in DashBot before generating tests.',
      );
    }

    final baseRequest = AIRequestModel.fromJson(aiModelJson);
    final resolvedMethod = (method?.trim().isNotEmpty == true)
        ? method!.trim().toUpperCase()
        : 'GET';

    final response = await executeGenAIRequest(
      baseRequest.copyWith(
        systemPrompt: _buildSystemPrompt(
          endpoint: endpoint,
          method: resolvedMethod,
          headers: headers ?? const <String, String>{},
          requestBody: requestBody,
        ),
        userPrompt: 'Generate API tests for this endpoint.',
        stream: false,
      ),
    );

    if (response == null || response.trim().isEmpty) {
      throw Exception('LLM returned an empty response.');
    }

    final parsed = _parseResponse(
      response,
      endpoint: endpoint,
      method: resolvedMethod,
    );
    if (parsed.isNotEmpty) {
      return parsed;
    }

    return _buildFallbackTests(
      endpoint: endpoint,
      method: resolvedMethod,
    );
  }

  List<AgenticTestCase> _parseResponse(
    String rawResponse, {
    required String endpoint,
    required String method,
  }) {
    final decoded = _tryDecodeJson(rawResponse);
    if (decoded == null) {
      return _buildFallbackTests(
        endpoint: endpoint,
        method: method,
      );
    }

    final rawTests =
        decoded['tests'] ?? decoded['test_cases'] ?? decoded['cases'];
    if (rawTests is! List || rawTests.isEmpty) {
      return _buildFallbackTests(
        endpoint: endpoint,
        method: method,
      );
    }

    final generated = <AgenticTestCase>[];
    for (final item in rawTests) {
      if (item is! Map) {
        continue;
      }
      generated.add(
        AgenticTestCase.fromJson(
          Map<String, dynamic>.from(item),
          fallbackId: getNewUuid(),
          fallbackEndpoint: endpoint,
          fallbackMethod: method,
        ),
      );
    }

    if (generated.isEmpty) {
      return _buildFallbackTests(
        endpoint: endpoint,
        method: method,
      );
    }
    return generated;
  }

  Map<String, dynamic>? _tryDecodeJson(String rawResponse) {
    final sanitized = _sanitizeResponse(rawResponse);
    try {
      final decoded = jsonDecode(sanitized);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}

    final firstBrace = sanitized.indexOf('{');
    final lastBrace = sanitized.lastIndexOf('}');
    if (firstBrace == -1 || lastBrace == -1 || firstBrace >= lastBrace) {
      return null;
    }

    try {
      final sliced = sanitized.substring(firstBrace, lastBrace + 1);
      final decoded = jsonDecode(sliced);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}

    return null;
  }

  String _sanitizeResponse(String input) {
    final trimmed = input.trim();
    final codeFence = RegExp(r'^```(?:json)?\s*([\s\S]*?)\s*```$');
    final match = codeFence.firstMatch(trimmed);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)?.trim() ?? trimmed;
    }
    return trimmed;
  }

  String _buildSystemPrompt({
    required String endpoint,
    required String method,
    required Map<String, String> headers,
    required String? requestBody,
  }) {
    return '''
You are an API testing assistant for API Dash.

Generate 3 to 5 focused API test cases for this endpoint:
- Endpoint: $endpoint
- Method: $method
- Headers: ${jsonEncode(headers)}
- Request Body: ${requestBody ?? ''}

Return ONLY valid JSON in this exact shape:
{
  "tests": [
    {
      "title": "Short test title",
      "description": "What this test validates",
      "method": "$method",
      "endpoint": "$endpoint",
      "expected_outcome": "Expected result",
      "assertions": ["assertion 1", "assertion 2"],
      "confidence": 0.0
    }
  ]
}

Rules:
- Keep each test actionable and realistic.
- Cover positive, negative, and edge conditions.
- confidence must be a number between 0 and 1.
- No markdown, no explanation, JSON only.
''';
  }

  List<AgenticTestCase> _buildFallbackTests({
    required String endpoint,
    required String method,
  }) {
    return [
      AgenticTestCase(
        id: getNewUuid(),
        title: 'Happy path returns success',
        description: 'Validate that a valid request is handled successfully.',
        method: method,
        endpoint: endpoint,
        expectedOutcome: 'Status code is 2xx and response body contains data.',
        assertions: const [
          'Response status is between 200 and 299',
          'Response body is not empty',
        ],
        confidence: 0.72,
      ),
      AgenticTestCase(
        id: getNewUuid(),
        title: 'Unauthorized request is rejected',
        description:
            'Validate access control by sending request without required auth.',
        method: method,
        endpoint: endpoint,
        expectedOutcome: 'Status code is 401 or 403.',
        assertions: const [
          'Response status is 401 or 403',
          'Error response explains authentication/authorization issue',
        ],
        confidence: 0.66,
      ),
      AgenticTestCase(
        id: getNewUuid(),
        title: 'Validation error for malformed input',
        description:
            'Send invalid payload/params and verify server-side validation.',
        method: method,
        endpoint: endpoint,
        expectedOutcome: 'Status code is 400 or 422 with validation details.',
        assertions: const [
          'Response status is 400 or 422',
          'Validation error details are present in response body',
        ],
        confidence: 0.61,
      ),
    ];
  }
}
