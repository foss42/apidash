import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'models/workflow_definition.dart';

class AIWorkflowTestingAgent implements AIAgent {
  @override
  String get agentName => 'AIWorkflowTestingAgent';

  @override
  String getSystemPrompt() => '''
You are an expert E2E Test Engineer for APIs.
Your job is to generate realistic, high-value test scenarios for a sequential API Workflow.

CONTEXT:
- Workflow Steps: :steps_summary: (Includes EXTRACTS/INJECTS rules for data flow)
- User Intent: :user_instructions:
- Existing Scenarios: :existing_scenarios:

A "Workflow Test Case" consists of:
1. Name: Concise name of the scenario.
2. Description: What the test validates.
3. Initial Variables: A map of variables (key -> value) that the workflow starts with. These are used to seed the process (e.g. valid/invalid credentials, specific IDs).

TASK:
Based on the workflow sequence, suggest 3-5 diverse test scenarios.
Include at least:
- One "Happy Path" (everything succeeds).
- One "Edge Case" or "Boundary Condition".
- One "Failure Case" (e.g. invalid inputs that should cause a step to fail).

CRITICAL: Respond with ONLY a raw JSON array of test cases. No markdown. No explanation.
Each element in the array must have:
- "name": string
- "description": string
- "initialVariables": object (string -> string)
- "stepExpectations": object (stepId -> {"expectedStatus": int})

  {
    "name": "Successful Login and Profile Fetch",
    "description": "Uses valid credentials to complete the full flow.",
    "initialVariables": {"username": "admin", "password": "password123"},
    "stepExpectations": {
      "step_1": {"expectedStatus": 200},
      "step_2": {"expectedStatus": 200}
    }
  }
]
''';

  @override
  Future<bool> validator(String aiResponse) async {
    try {
      final cleaned = _clean(aiResponse);
      final parsed = jsonDecode(cleaned);
      if (parsed is! List) return false;
      for (final item in parsed) {
        if (item is! Map) return false;
        if (item['name'] == null || item['description'] == null) return false;
        if (item['initialVariables'] is! Map) return false;
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
