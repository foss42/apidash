import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';

class AIWorkflowGenerationAgent implements AIAgent {
  @override
  String get agentName => 'AIWorkflowGenerationAgent';

  @override
  String getSystemPrompt() => '''
You are an expert API Orchestration Assistant.
Your job is to configure a sequential Workflow of API requests by defining Extraction and Injection rules.

CONTEXT:
- Workflow Steps: :steps_summary:
- Current Rules: :current_rules:
- User Intent: :user_instructions:

RULES EXPLAINED:
1. Extraction (Response -> Variable): Capture values from one step's response to use later.
   - Format: "body.<json_path>" or "header.<Header-Name>"
   - Example: {"token": "body.data.access_token"}

2. Injection (Variable -> Request): Put captured values into a subsequent request.
   - Target Header: "header.<Name>"
   - Target Body: "body" (full replacement)
   - Target URL: "url"
   - Value Format: "Bearer {{token}}" (using {{varName}} for interpolation)

TASK:
Based on the User Intent and the available steps, update the rules (Extract and Inject) for the steps to achieve the desired data flow.
Produce a set of rules that chain the requests logically.

CRITICAL: Respond with ONLY a raw JSON array of step modifications. No markdown. No explanation.
Each element in the array must have:
- "stepId": The ID of the step to update (string)
- "extract": Entire updated extraction map (object: variable name -> dot-path)
- "inject": Entire updated injection map (object: target -> template value)

Example output:
[
  {
    "stepId": "step_1",
    "extract": {"token": "body.token"},
    "inject": {}
  },
  {
    "stepId": "step_2",
    "extract": {},
    "inject": {"header.Authorization": "Bearer {{token}}"}
  }
]

Output raw JSON only.
''';

  @override
  Future<bool> validator(String aiResponse) async {
    try {
      final cleaned = _clean(aiResponse);
      final parsed = jsonDecode(cleaned);
      if (parsed is! List) return false;
      for (final item in parsed) {
        if (item is! Map) return false;
        if (item['stepId'] == null) return false;
        if (item['extract'] is! Map || item['inject'] is! Map) return false;
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
    var s = raw.trim();
    if (s.startsWith('```')) {
      s = s.replaceFirst(RegExp(r'^```[a-z]*\n?'), '');
      s = s.replaceFirst(RegExp(r'```$'), '').trim();
    }
    return s;
  }
}
