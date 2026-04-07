import 'dart:io';
import 'dart:convert';
import 'package:genai/genai.dart';
import '../models/assertion.dart';
import '../models/test_case.dart'; // ← ADD: TestStatus lives here
import '../models/test_result.dart'; // ← AssertionResult lives here
import '../models/workflow_step.dart';
import '../models/workflow_result.dart';
import '../utils/prompt_builder.dart';
import '../utils/json_path_extractor.dart';

class _WorkflowPlannerAgent extends AIAgent {
  final String _systemPrompt;
  _WorkflowPlannerAgent(this._systemPrompt);

  @override
  String get agentName => 'WorkflowPlannerAgent';

  @override
  String getSystemPrompt() => _systemPrompt;

  @override
  Future<bool> validator(String aiResponse) async {
    try {
      final cleaned = _stripMarkdown(aiResponse);
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return json.containsKey('steps') && (json['steps'] as List).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // ✅ Correct signature: Future<dynamic>
  @override
  Future<dynamic> outputFormatter(String validatedResponse) async {
    final cleaned = _stripMarkdown(validatedResponse);
    final json = jsonDecode(cleaned) as Map<String, dynamic>;
    final steps = json['steps'] as List;
    return steps
        .map((s) => WorkflowStep.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  String _stripMarkdown(String raw) {
    var s = raw.trim();
    if (s.startsWith('```')) {
      s = s.replaceFirst(RegExp(r'^```[a-z]*\n?'), '');
      s = s.replaceFirst(RegExp(r'```$'), '').trim();
    }
    return s;
  }
}

class WorkflowAgent {
  final AIRequestModel aiRequestModel;

  WorkflowAgent({required this.aiRequestModel});

  // ─── Stage 3A: Ask LLM to plan the workflow ─────────────────────────────
  Future<List<WorkflowStep>> generatePlan(
    List<Map<String, dynamic>> requests,
  ) async {
    final agent = _WorkflowPlannerAgent(PromptBuilder.workflowSystemPrompt);
    final userInput = jsonEncode({'requests': requests});

    final result = await AIAgentService.callAgent(
      agent,
      aiRequestModel,
      query: userInput,
    );

    if (result == null) return [];
    return result as List<WorkflowStep>;
  }

  // ─── Stage 3B: Execute steps, passing context between them ──────────────
  Stream<WorkflowStepResult> execute(List<WorkflowStep> steps) async* {
    // Shared context: extracted variables flow from step N to step N+1
    final Map<String, dynamic> context = {};

    for (final step in steps) {
      final startTime = DateTime.now();

      // 1. Resolve {{placeholders}} in url, body, headers
      final resolvedUrl = _resolvePlaceholders(step.url, context);
      final resolvedBody = step.body != null
          ? _resolvePlaceholders(step.body!, context)
          : null;
      final resolvedHeaders = {
        for (final e in step.headers.entries)
          e.key: _resolvePlaceholders(e.value, context),
      };

      // 2. Execute HTTP
      late int statusCode;
      late String responseBody;

      try {
        final httpResult = await _executeHttp(
          method: step.method,
          url: resolvedUrl,
          headers: resolvedHeaders,
          body: resolvedBody,
        );
        statusCode = httpResult['statusCode'] as int;
        responseBody = httpResult['body'] as String;
      } catch (e) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        yield WorkflowStepResult(
          step: step,
          actualStatusCode: 0,
          actualBody: '',
          durationMs: duration,
          assertionResults: [],
          overallStatus: TestStatus.failed, // ✅ correct field name
          extractedValues: {}, // ✅ correct field name
          errorMessage: 'HTTP error: $e',
        );
        continue;
      }

      // 3. Run assertions
      final assertionResults = <AssertionResult>[];
      for (final assertion in step.assertions) {
        final passed = _evaluate(assertion, statusCode, responseBody);
        assertionResults.add(
          AssertionResult(
            assertionId: assertion.id,
            passed: passed,
            message: passed
                ? '✓ ${assertion.type.name} = ${assertion.expected}'
                : '✗ ${assertion.type.name}: expected ${assertion.expected}',
          ),
        );
      }

      // 4. Extract data into context for next steps
      final extractedValues = <String, dynamic>{};
      for (final binding in step.dataExtractions) {
        final value = JsonPathExtractor.extract(binding.jsonPath, responseBody);
        if (value != null) {
          context[binding.variableName] = value;
          extractedValues[binding.variableName] = value;
        }
      }

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      final allPassed =
          assertionResults.isEmpty ||
          assertionResults.every((AssertionResult a) => a.passed);

      yield WorkflowStepResult(
        step: step,
        actualStatusCode: statusCode, // ✅ correct field name
        actualBody: responseBody, // ✅ correct field name
        durationMs: duration,
        assertionResults: assertionResults,
        overallStatus:
            allPassed // ✅ correct field name
            ? TestStatus.passed
            : TestStatus.failed,
        extractedValues: extractedValues, // ✅ correct field name
        errorMessage: null,
      );
    }
  }

  // ─── Resolve {{variableName}} placeholders ───────────────────────────────
  String _resolvePlaceholders(String template, Map<String, dynamic> context) {
    var result = template;
    for (final entry in context.entries) {
      result = result.replaceAll('{{${entry.key}}}', entry.value.toString());
    }
    return result;
  }

  // ─── HTTP executor using dart:io ─────────────────────────────────────────
  Future<Map<String, dynamic>> _executeHttp({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) async {
    final uri = Uri.parse(url);
    final client = HttpClient();

    try {
      final request = await _openRequest(client, method, uri);
      headers.forEach((key, value) => request.headers.set(key, value));
      if (body != null && body.isNotEmpty) request.write(body);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      return {'statusCode': response.statusCode, 'body': responseBody};
    } finally {
      client.close();
    }
  }

  Future<HttpClientRequest> _openRequest(
    HttpClient client,
    String method,
    Uri uri,
  ) async {
    switch (method.toUpperCase()) {
      case 'GET':
        return client.getUrl(uri);
      case 'POST':
        return client.postUrl(uri);
      case 'PUT':
        return client.putUrl(uri);
      case 'PATCH':
        return client.patchUrl(uri);
      case 'DELETE':
        return client.deleteUrl(uri);
      default:
        return client.openUrl(method, uri);
    }
  }

  // ─── Evaluate a single assertion ─────────────────────────────────────────
  bool _evaluate(Assertion assertion, int statusCode, String responseBody) {
    switch (assertion.type) {
      case AssertionType.statusCode:
        return statusCode == (assertion.expected as int);
      case AssertionType.bodyContains:
        return responseBody.contains(assertion.expected.toString());
      case AssertionType.responseTimeUnder:
        // Cannot evaluate response time here — handled at caller level
        return true;
    }
  }
}
