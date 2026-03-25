import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';

class AITestGenerationAgent implements AIAgent {
  @override
  String get agentName => 'AITestGenerationAgent';

  @override
  String getSystemPrompt() => '''
You are an expert API security and quality tester.
Your job is to generate additional HTTP API test cases that go BEYOND basic rule-based tests.

API CONTEXT:
- Method: :method:
- URL: :url:
- Headers present: :headers_summary:
- Body schema: :body_schema:
- Already covered by rules: :existing_tests:

WORKFLOW CONTEXT (optional, JSON): :workflow_context:
WORKFLOW MEMORY (optional, JSON): :workflow_memory:
LATEST WORKFLOW RUN (optional, JSON): :latest_workflow_run:

USER INSTRUCTIONS: :user_instructions:

Generate creative, targeted edge-case test cases NOT already listed above.
Focus on: security vulnerabilities, boundary values, unexpected inputs, missing fields, type mismatches, large payloads, encoding issues.
If workflow context is present, generate chain-aware tests too (cross-step token flow, stale/invalid extracted values, incorrect inject rules, sequence dependencies).

CRITICAL: Respond with ONLY a raw JSON array. No markdown. No explanation. No code fences.

Each element must have exactly these fields:
- "name": short, descriptive test name (string)
- "description": one sentence explaining what this tests (string)
- "requestPatch": object with any of: "body" (string), "upsertHeaders" (object), "removeHeaders" (array of strings)
- "expectedStatus": HTTP status code you expect (integer)

Example output:
[
  {
    "name": "SQL Injection in Body",
    "description": "Send SQL injection payload to verify the API sanitizes input.",
    "requestPatch": {"body": "{\\"username\\": \\"' OR 1=1 --\\"}"},
    "expectedStatus": 400
  }
]

Generate between 2 and 6 test cases. Output raw JSON only.
''';

  @override
  Future<bool> validator(String aiResponse) async {
    try {
      final cleaned = _clean(aiResponse);
      final parsed = jsonDecode(cleaned);
      if (parsed is! List || parsed.isEmpty) return false;
      for (final item in parsed) {
        if (item is! Map) return false;
        if (item['name'] == null || item['description'] == null) return false;
        if (item['expectedStatus'] == null) return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<dynamic> outputFormatter(String validatedResponse) async {
    final cleaned = _clean(validatedResponse);
    return jsonDecode(cleaned) as List<dynamic>;
  }

  String _clean(String raw) {
    // Strip markdown code fences if present
    var s = raw.trim();
    if (s.startsWith('```')) {
      s = s.replaceFirst(RegExp(r'^```[a-z]*\n?'), '');
      s = s.replaceFirst(RegExp(r'```$'), '').trim();
    }
    return s;
  }
}
