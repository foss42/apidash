// DashAssert – AI Assertion Suggester
// Part of the AI-Powered Response Assertion Engine for API Dash
// Relates to GSoC 2026 Idea #4: Agentic API Testing

import 'dart:convert';
import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import '../models/assertion_model.dart';

/// Suggests meaningful [AssertionRule]s from an [HttpResponseModel].
///
/// In this MVP the suggester uses **response heuristics** to generate rules
/// deterministically (no API key required). The method [_buildSuggestionPrompt]
/// and the TODO below show exactly where a live LLM call (DashBot / any AI
/// provider already integrated in API Dash) would be inserted for the full
/// GSoC implementation.
class AiAssertionSuggester {
  const AiAssertionSuggester();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Generate a list of meaningful assertions for [response].
  ///
  /// [requestUrl] is optional — included for future LLM prompt context.
  Future<List<AssertionRule>> suggestAssertions(
    HttpResponseModel response, {
    String? requestUrl,
  }) async {
    // TODO (GSoC full implementation): replace the heuristic block below with
    // an actual LLM call via the DashBot / AI provider already integrated in
    // API Dash:
    //
    //   final prompt = _buildSuggestionPrompt(response, requestUrl: requestUrl);
    //   final llmResponse = await aiService.sendMessage(prompt);
    //   return _parseAssertionsFromLlmResponse(llmResponse);
    //
    // The prompt is already built — see [_buildSuggestionPrompt] below.

    return _heuristicSuggest(response);
  }

  // ---------------------------------------------------------------------------
  // Heuristic suggester (LLM-free MVP)
  // ---------------------------------------------------------------------------

  List<AssertionRule> _heuristicSuggest(HttpResponseModel response) {
    final rules = <AssertionRule>[];
    int counter = 0;

    String nextId() => 'suggested_${counter++}';

    // 1. Status code assertion
    final statusCode = response.statusCode;
    if (statusCode != null) {
      rules.add(
        AssertionRule(
          id: nextId(),
          type: AssertionType.statusCode,
          description: 'Status code is $statusCode',
          expectedValue: statusCode,
        ),
      );
    }

    // 2. Response time assertion (suggest 2× whatever we just observed, or
    //    2000 ms as a sensible default)
    final timeMs = response.time?.inMilliseconds;
    final suggestedThreshold = timeMs != null
        ? (timeMs * 2).clamp(500, 10000)
        : 2000;
    rules.add(
      AssertionRule(
        id: nextId(),
        type: AssertionType.responseTimeUnder,
        description: 'Response time under ${suggestedThreshold}ms',
        expectedValue: suggestedThreshold,
      ),
    );

    // 3. Content-Type header exists
    rules.add(
      AssertionRule(
        id: nextId(),
        type: AssertionType.headerExists,
        description: 'Response has content-type header',
        expectedValue: 'content-type',
      ),
    );

    // 4. Parse JSON body and suggest field-level checks + JSON Schema
    final body = response.body ?? '';
    if (body.isNotEmpty) {
      try {
        final decoded = json.decode(body);
        if (decoded is Map<String, dynamic>) {
          // Suggest up to 3 top-level field existence checks
          final topKeys = decoded.keys.take(3).toList();
          for (final key in topKeys) {
            rules.add(
              AssertionRule(
                id: nextId(),
                type: AssertionType.jsonFieldExists,
                description: 'Response JSON contains "$key" field',
                jsonPath: key,
              ),
            );
          }

          // If there's a "id" or "status" field, also suggest value check
          if (decoded.containsKey('id') && decoded['id'] != null) {
            rules.add(
              AssertionRule(
                id: nextId(),
                type: AssertionType.jsonFieldValue,
                description: 'Response JSON "id" field value check',
                jsonPath: 'id',
                expectedValue: decoded['id'].toString(),
              ),
            );
          }

          // Suggest a JSON Schema assertion automatically derived from response
          final schemaRule = _suggestSchemaAssertion(decoded, nextId());
          rules.add(schemaRule);
        } else if (decoded is List && decoded.isNotEmpty) {
          // Array response — check that it contains at least one item
          rules.add(
            AssertionRule(
              id: nextId(),
              type: AssertionType.bodyContains,
              description: 'Response body is a non-empty JSON array',
              expectedValue: '[',
            ),
          );

          // If first element is a map, suggest its top field
          if (decoded.first is Map<String, dynamic>) {
            final firstKeys =
                (decoded.first as Map<String, dynamic>).keys.take(1).toList();
            for (final key in firstKeys) {
              rules.add(
                AssertionRule(
                  id: nextId(),
                  type: AssertionType.jsonFieldExists,
                  description: 'First array item contains "$key" field',
                  jsonPath: '0.$key',
                ),
              );
            }
          }
        }
      } catch (_) {
        // Non-JSON body
        final preview = body.substring(0, min(40, body.length)).trim();
        if (preview.isNotEmpty) {
          rules.add(
            AssertionRule(
              id: nextId(),
              type: AssertionType.bodyContains,
              description: 'Response body contains expected text',
              expectedValue: preview,
            ),
          );
        }
      }
    }

    return rules;
  }

  // ---------------------------------------------------------------------------
  // JSON Schema suggestion (NEW — Upgrade 1C)
  // ---------------------------------------------------------------------------

  /// Auto-generate a [jsonSchemaValid] assertion derived from a JSON object body.
  ///
  /// Captures the top-level keys (capped at 8) and their inferred types as a
  /// minimal JSON Schema with a `required` array and `properties` map.
  AssertionRule _suggestSchemaAssertion(
    Map<String, dynamic> body,
    String id,
  ) {
    final properties = <String, dynamic>{};
    final required = <String>[];
    for (final entry in body.entries.take(8)) {
      required.add(entry.key);
      properties[entry.key] = {'type': _dartTypeToJsonSchemaType(entry.value)};
    }
    final schema = jsonEncode({
      'type': 'object',
      'required': required,
      'properties': properties,
    });
    return AssertionRule(
      id: id,
      type: AssertionType.jsonSchemaValid,
      description: 'Response body matches expected JSON schema',
      expectedValue: schema,
    );
  }

  /// Map a Dart runtime value to its JSON Schema type string.
  String _dartTypeToJsonSchemaType(dynamic value) {
    if (value is int) return 'integer';
    if (value is double) return 'number';
    if (value is String) return 'string';
    if (value is bool) return 'boolean';
    if (value is List) return 'array';
    if (value is Map) return 'object';
    return 'string';
  }

  // ---------------------------------------------------------------------------
  // LLM prompt builder (ready for integration)
  // ---------------------------------------------------------------------------

  /// Build a structured prompt for an LLM to suggest assertions.
  ///
  /// This method is here to demonstrate the full GSoC design intent.
  /// In production, pass the prompt to DashBot or any AI provider.
  // ignore: unused_element
  String _buildSuggestionPrompt(
    HttpResponseModel response, {
    String? requestUrl,
  }) {
    final body = response.body ?? '';
    final truncatedBody = body.length > 500 ? body.substring(0, 500) + '…' : body;
    final headers = response.headers ?? {};
    final contentType = headers['content-type'] ?? 'unknown';
    final timeMs = response.time?.inMilliseconds ?? 0;

    return '''
You are an API testing expert. Given the API response below, suggest 3-5 meaningful assertion rules.

${requestUrl != null ? 'Request URL: $requestUrl\n' : ''}\
Status Code: ${response.statusCode ?? 'unknown'}
Content-Type: $contentType
Response Time: ${timeMs}ms
Response Body (first 500 chars):
$truncatedBody

Return ONLY a valid JSON array in this exact format (no extra text):
[
  {
    "type": "STATUS_CODE|JSON_FIELD_EXISTS|JSON_FIELD_VALUE|RESPONSE_TIME_UNDER|HEADER_EXISTS|HEADER_VALUE|BODY_CONTAINS|JSON_SCHEMA_VALID",
    "description": "Human readable assertion label",
    "expectedValue": "<expected value or number or schema JSON string>",
    "jsonPath": "<dot.notation.path or null>"
  }
]

Focus on: status codes, important JSON fields that must exist, response time limits, and schema validation.
''';
  }

  // ---------------------------------------------------------------------------
  // LLM response parser (ready for integration)
  // ---------------------------------------------------------------------------

  /// Parse the raw LLM text response into [AssertionRule]s.
  ///
  /// Used when wiring up the actual DashBot call in the full GSoC version.
  // ignore: unused_element
  List<AssertionRule> _parseAssertionsFromLlmResponse(String llmResponse) {
    try {
      // Strip any markdown code fences the LLM may have added
      final cleaned = llmResponse
          .replaceAll(RegExp(r'```json?', caseSensitive: false), '')
          .replaceAll('```', '')
          .trim();
      final decoded = json.decode(cleaned) as List;
      return decoded.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value as Map<String, dynamic>;
        final typeStr = (item['type'] as String? ?? '')
            .toLowerCase()
            .replaceAll('_', '');
        AssertionType type = AssertionType.values.firstWhere(
          (t) => t.name.toLowerCase() == typeStr,
          orElse: () => AssertionType.bodyContains,
        );
        return AssertionRule(
          id: 'ai_$i',
          type: type,
          description: item['description'] as String? ?? '',
          expectedValue: item['expectedValue'],
          jsonPath: item['jsonPath'] as String?,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
