import 'dart:io';
import 'dart:convert';
import 'package:genai/genai.dart';
import '../models/assertion.dart';
import '../models/test_case.dart';
import '../models/test_result.dart';
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
    // Remove opening fence (```json or ```)
    s = s.replaceAll(RegExp(r'^```[a-z]*\s*', multiLine: false), '');
    // Remove closing fence
    s = s.replaceAll(RegExp(r'```\s*$', multiLine: false), '').trim();
    // Extract only the JSON object portion
    final start = s.indexOf('{');
    final end = s.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      s = s.substring(start, end + 1);
    }
    return s;
  }
}

class WorkflowAgent {
  final AIRequestModel aiRequestModel;

  WorkflowAgent({required this.aiRequestModel});

  // ─── Stage 3A: Plan ──────────────────────────────────────────────────────
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

  // ─── Stage 3B: Execute ───────────────────────────────────────────────────
  Stream<WorkflowStepResult> execute(List<WorkflowStep> steps) async* {
    // Context accumulates extracted values across steps
    final Map<String, dynamic> context = {};

    for (final step in steps) {
      final startTime = DateTime.now();

      // 1. Resolve {{placeholders}} in url, body, headers using current context
      final resolvedUrl = _resolvePlaceholders(step.url, context);
      final resolvedBody =
          step.body != null ? _resolvePlaceholders(step.body!, context) : null;
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
          overallStatus: TestStatus.failed,
          extractedValues: {},
          errorMessage: 'HTTP error: $e',
        );
        continue;
      }

      final durationMs = DateTime.now().difference(startTime).inMilliseconds;

      // 3. Run assertions — resolve {{placeholders}} in expected values too
      final assertionResults = <AssertionResult>[];
      for (final assertion in step.assertions) {
        // ← KEY FIX: resolve placeholders inside expected string values
        final resolvedExpected = _resolveExpected(assertion.expected, context);

        final passed = _evaluate(
          assertion.type,
          resolvedExpected,
          statusCode,
          responseBody,
          durationMs,
        );

        // Build a human-readable message showing resolved values
        final expectedDisplay = resolvedExpected.toString();
        assertionResults.add(
          AssertionResult(
            assertionId: assertion.id,
            passed: passed,
            message: passed
                ? '✓ ${assertion.type.name} = $expectedDisplay'
                : '✗ ${assertion.type.name}: expected $expectedDisplay',
          ),
        );
      }

      // 4. Extract data into context for NEXT steps
      final extractedValues = <String, dynamic>{};
      for (final binding in step.dataExtractions) {
        final value =
            JsonPathExtractor.extract(binding.jsonPath, responseBody);
        if (value != null) {
          context[binding.variableName] = value;
          extractedValues[binding.variableName] = value;
        }
      }

      final allPassed = assertionResults.isEmpty ||
          assertionResults.every((a) => a.passed);

      yield WorkflowStepResult(
        step: step,
        actualStatusCode: statusCode,
        actualBody: responseBody,
        durationMs: durationMs,
        assertionResults: assertionResults,
        overallStatus: allPassed ? TestStatus.passed : TestStatus.failed,
        extractedValues: extractedValues,
        errorMessage: null,
      );
    }
  }

  // ─── Resolve {{placeholders}} in any value ───────────────────────────────
  String _resolvePlaceholders(String template, Map<String, dynamic> context) {
    var result = template;
    for (final entry in context.entries) {
      result = result.replaceAll('{{${entry.key}}}', entry.value.toString());
    }
    return result;
  }

  /// Resolves {{placeholders}} inside expected values.
  /// Works for String, int, double — returns original type if no substitution needed.
  dynamic _resolveExpected(dynamic expected, Map<String, dynamic> context) {
    if (expected == null) return expected;
    if (context.isEmpty) return expected;

    final raw = expected.toString();
    final resolved = _resolvePlaceholders(raw, context);

    // If unchanged, return original (preserves int type for statusCode checks)
    if (resolved == raw) return expected;

    // Try to re-parse as int (e.g. statusCode assertions)
    final asInt = int.tryParse(resolved);
    if (asInt != null) return asInt;

    // Try double
    final asDouble = double.tryParse(resolved);
    if (asDouble != null) return asDouble;

    // Return as resolved string
    return resolved;
  }

  // ─── Evaluate assertion ──────────────────────────────────────────────────
  bool _evaluate(
    AssertionType type,
    dynamic expected,
    int statusCode,
    String responseBody,
    int durationMs,
  ) {
    switch (type) {
      case AssertionType.statusCode:
        final expectedCode = expected is int
            ? expected
            : int.tryParse(expected.toString()) ?? -1;
        return statusCode == expectedCode;

      case AssertionType.bodyContains:
        return responseBody.contains(expected.toString());

      case AssertionType.responseTimeUnder:
        final limit = expected is int
            ? expected
            : int.tryParse(expected.toString()) ?? 2000;
        return durationMs < limit;
    }
  }

  // ─── HTTP executor ───────────────────────────────────────────────────────
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
}