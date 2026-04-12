class PromptBuilder {
  // ─── Unit Test System Prompt ─────────────────────────────────────────────

  static String get unitTestSystemPrompt => '''
You are an expert API testing engineer. Generate test cases for an API endpoint.

OUTPUT RULES (CRITICAL — follow exactly):
- Respond ONLY with a raw JSON array. No markdown fences, no explanation, no extra text.
- Generate EXACTLY 6 test cases maximum. No more.
- Keep all string values SHORT (under 60 characters each).
- The "body" field must be null OR a compact single-line JSON string (no newlines, no tabs).
- Do NOT copy the request body verbatim. Write minimal body variants per test scenario.
- Every "expected" for status_code must be an INTEGER (not a string).
- Every "expected" for response_time_under must be an INTEGER (milliseconds, e.g. 2000).

CATEGORIES:
- happy_path   : valid request, expect success response
- edge_case    : boundary values or missing optional fields
- security     : missing auth or injection attempt
- performance  : response time threshold

EXACT SCHEMA for each object in the array:
{
  "description": "short description under 60 chars",
  "category": "happy_path",
  "method": "POST",
  "url": "https://example.com/endpoint",
  "headers": {},
  "body": null,
  "assertions": [
    { "type": "status_code", "expected": 200 }
  ]
}

Allowed assertion types: status_code, body_contains, response_time_under
''';

  // ─── Unit Test User Prompt ───────────────────────────────────────────────

  static String unitTestUserPrompt({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) {
    // Sanitize body — collapse to single line, strip excess whitespace
    final sanitizedBody = _sanitizeBody(body);

    return '''Generate 6 test cases for:
Method: $method
URL: $url
Headers: ${_formatHeaders(headers)}
Body: $sanitizedBody

Return only the JSON array. No markdown. No extra text.
''';
  }

  // ─── Workflow System Prompt ──────────────────────────────────────────────

static String get workflowSystemPrompt => r'''
You are an expert API workflow architect. Analyze a list of API requests and
generate an intelligent execution plan with data dependencies between steps.

═══ OUTPUT RULES (CRITICAL) ═══
- Respond ONLY with a raw JSON object. No markdown, no explanation.
- Maximum 2 assertions per step.
- Maximum 1 dataExtraction per step.

═══ BODY RULES ═══
- GET and DELETE requests MUST always have "body": null.
- Never add body to GET requests, even if the previous step had a body.
- Only POST, PUT, PATCH may have a non-null body.
- Copy the body from the original request exactly as-is. Do NOT modify it.

═══ HEADER RULES ═══
- If a step extracts an auth token (access_token, token, jwt, id_token),
  the NEXT step that needs auth MUST include:
  "Authorization": "Bearer {{variableName}}"
  in its headers — not in its body.
- Copy all original headers from the request. Add Authorization on top.

═══ ASSERTION RULES ═══
- For LIST endpoints (GET returning an array): ONLY assert statusCode.
- For CREATE endpoints (POST/PUT): ONLY assert statusCode.
- For GET with Authorization: ONLY assert statusCode.
- NEVER assert bodyContains with user-specific data (emails, names, IDs, passwords).
- ONLY use bodyContains for structural keys guaranteed to exist (e.g. "id", "token").
- responseTimeUnder: use 2000 as a safe default limit in milliseconds.

═══ DATA EXTRACTION RULES ═══
- Only extract from POST/PUT responses or single-resource GET responses.
- Do NOT extract from list endpoints (arrays).
- Common patterns to extract:
    auth token  → jsonPath: "$.access_token" or "$.token"
    created id  → jsonPath: "$.id"
    nested data → jsonPath: "$.data.id"
- Use the extracted variable in the NEXT step via {{variableName}} in:
    URL path    → /resource/{{id}}
    Header      → "Authorization": "Bearer {{authToken}}"

═══ STEP ORDERING RULES ═══
- If a GET request depends on a POST response (e.g. uses created id or token),
  always put the POST BEFORE the GET in the steps array.
- Identify dependencies by looking at URL patterns and header requirements.

═══ EXACT OUTPUT FORMAT ═══
{
  "steps": [
    {
      "name": "descriptive step name",
      "method": "POST",
      "url": "original url from request",
      "headers": {"Content-Type": "application/json"},
      "body": "original body from request exactly as-is",
      "assertions": [
        { "id": "step1-status", "type": "statusCode", "expected": 200, "isSelected": true }
      ],
      "dataExtractions": [
        { "variableName": "authToken", "jsonPath": "$.access_token" }
      ]
    }
  ]
}
''';

static String workflowUserPrompt(List<Map<String, dynamic>> requests) {
  final buffer = StringBuffer();
  buffer.writeln('Generate a workflow execution plan for these API requests:\n');

  for (var i = 0; i < requests.length; i++) {
    final r = requests[i];
    buffer.writeln('Request ${i + 1}:');
    buffer.writeln('  Method:  ${r['method'] ?? 'GET'}');
    buffer.writeln('  URL:     ${r['url'] ?? ''}');

    final headers = r['headers'];
    if (headers != null && (headers as Map).isNotEmpty) {
      buffer.writeln('  Headers: $headers');
    }

    final body = r['body'];
    if (body != null && body.toString().trim().isNotEmpty) {
      // Sanitize body — collapse to single line
      final collapsed = body.toString()
          .replaceAll('\r\n', ' ')
          .replaceAll('\n', ' ')
          .replaceAll('\t', ' ')
          .replaceAll(RegExp(r'\s{2,}'), ' ')
          .trim();
      buffer.writeln('  Body:    $collapsed');
    }
    buffer.writeln();
  }

  buffer.writeln('Return only the JSON object. No markdown. No extra text.');
  return buffer.toString();
}
  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// Collapses body to single line, strips internal newlines/tabs.
  /// Prevents the model from echoing a multiline body and blowing token budget.
  static String _sanitizeBody(String? body) {
    if (body == null || body.trim().isEmpty) return 'none';
    // Collapse whitespace in JSON body to a compact single-line string
    final collapsed = body
        .replaceAll('\r\n', ' ')
        .replaceAll('\n', ' ')
        .replaceAll('\t', ' ')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
    // Truncate if still long — model doesn't need full body to write tests
    if (collapsed.length > 200) {
      return '${collapsed.substring(0, 200)}...';
    }
    return collapsed;
  }

  static String _formatHeaders(Map<String, String> headers) {
    if (headers.isEmpty) return 'none';
    // Only send first 3 headers — prevents token blowout
    final trimmed = headers.entries.take(3);
    final entries = trimmed.map((e) => '"${e.key}": "${e.value}"');
    return '{ ${entries.join(', ')} }';
  }
}