class PromptBuilder {
  // Builds the system prompt for unit test generation
  // Uses :variable: syntax matching genai's substitutePromptVariable()
  static String get unitTestSystemPrompt => '''
You are an expert API testing engineer. Your job is to generate comprehensive
test cases for a given API endpoint.

You will be given:
- HTTP Method
- URL
- Headers (as JSON)
- Request Body (if any)

Generate test cases covering these categories:
1. happy_path     - valid request, expect success
2. edge_case      - boundary values, empty fields, large inputs
3. security       - missing auth, invalid tokens, injection attempts
4. performance    - note expected response time threshold

Respond ONLY with a valid JSON array. No markdown, no explanation, no code blocks.
Each object must have exactly these fields:
{
  "description": "string",
  "category": "happy_path" | "edge_case" | "security" | "performance",
  "method": "GET" | "POST" | "PUT" | "DELETE" | "PATCH",
  "url": "string",
  "headers": { "key": "value" },
  "body": "string or null",
  "assertions": [
    {
      "type": "status_code" | "body_contains" | "response_time_under",
      "expected": number | string
    }
  ]
}
''';

  // Builds the user prompt — injects actual request data
  static String unitTestUserPrompt({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) {
    return '''
Generate test cases for this API endpoint:

Method: $method
URL: $url
Headers: ${_formatHeaders(headers)}
Body: ${body ?? 'none'}

Return a JSON array of test cases only.
''';
  }

  // Builds workflow planning system prompt
static String get workflowSystemPrompt => '''
You are an expert API workflow architect. Given a list of API requests,
identify the correct execution order and data dependencies between them.

For each step, identify:
1. What data needs to be extracted from the response (e.g. id, token)
2. Where that data is used in subsequent requests (via {{variableName}} placeholders)
3. What assertions to verify at each step

Respond ONLY with a valid JSON object. No markdown, no explanation.
Format:
{
  "steps": [
    {
      "name": "string",
      "method": "string",
      "url": "string (use {{variableName}} for dynamic values)",
      "headers": { "key": "value" },
      "body": "string or null",
      "assertions": [
        { "type": "status_code" | "body_contains", "expected": value }
      ],
      "dataExtractions": [
        { "variableName": "string", "jsonPath": "\$.path.to.value" }
      ]
    }
  ]
}
''';

  static String _formatHeaders(Map<String, String> headers) {
    if (headers.isEmpty) return '{}';
    final entries = headers.entries.map((e) => '"${e.key}": "${e.value}"');
    return '{ ${entries.join(', ')} }';
  }
}