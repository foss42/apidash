import 'dart:io';
import 'dart:convert';
import 'package:genai/agentic_engine/agentic_engine.dart';
import 'package:genai/models/models.dart';
import 'package:uuid/uuid.dart';
import '../models/assertion.dart';
import '../models/test_case.dart';
import '../models/test_result.dart';
import '../utils/prompt_builder.dart';

// ─── Agent Definition ───────────────────────────────────────────────────────

// Implements AIAgent blueprint from genai package.
// AIAgentService handles retry, backoff, and provider abstraction for us.
class _TestGeneratorAgent extends AIAgent {
  final String method;
  final String url;
  final Map<String, String> headers;
  final String? body;

  _TestGeneratorAgent({
    required this.method,
    required this.url,
    required this.headers,
    this.body,
  });

  @override
  String get agentName => 'UnitTestGeneratorAgent';

  @override
  String getSystemPrompt() => PromptBuilder.unitTestSystemPrompt;

  // Validates that the LLM returned parseable JSON array
  @override
  Future<bool> validator(String aiResponse) async {
    try {
      final cleaned = _stripMarkdown(aiResponse);
      final parsed = jsonDecode(cleaned);
      return parsed is List && parsed.isNotEmpty;
    } catch (_) {
      return false; // triggers retry in AIAgentService governor
    }
  }

  // Parses validated JSON into List<TestCase>
  @override
  Future<List<TestCase>> outputFormatter(String validatedResponse) async {
    final cleaned = _stripMarkdown(validatedResponse);
    final List<dynamic> rawList = jsonDecode(cleaned) as List;
    const uuid = Uuid();

    return rawList.map((raw) {
      final map = raw as Map<String, dynamic>;

      final assertions = (map['assertions'] as List? ?? []).map((a) {
        final aMap = a as Map<String, dynamic>;
        return Assertion(
          id: uuid.v4(),
          type: _parseAssertionType(aMap['type'] as String),
          expected: aMap['expected'],
        );
      }).toList();

      return TestCase(
        id: uuid.v4(),
        description: map['description'] as String,
        category: _parseCategory(map['category'] as String),
        method: map['method'] as String? ?? method,
        url: map['url'] as String? ?? url,
        headers: Map<String, String>.from(
          (map['headers'] as Map?) ?? headers,
        ),
        body: map['body'] as String?,
        assertions: assertions,
      );
    }).toList();
  }

  // Strips ```json ... ``` markdown wrapping that LLMs sometimes add
  String _stripMarkdown(String raw) {
    final stripped = raw
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();
    return stripped;
  }

  AssertionType _parseAssertionType(String raw) {
    switch (raw) {
      case 'status_code':
        return AssertionType.statusCode;
      case 'body_contains':
        return AssertionType.bodyContains;
      case 'response_time_under':
        return AssertionType.responseTimeUnder;
      default:
        return AssertionType.statusCode;
    }
  }

  TestCategory _parseCategory(String raw) {
    switch (raw) {
      case 'happy_path':
        return TestCategory.happyPath;
      case 'edge_case':
        return TestCategory.edgeCase;
      case 'security':
        return TestCategory.security;
      case 'performance':
        return TestCategory.performance;
      default:
        return TestCategory.happyPath;
    }
  }
}

// ─── Public UnitTestAgent ────────────────────────────────────────────────────

class UnitTestAgent {
  final AIRequestModel aiRequestModel;

  UnitTestAgent({required this.aiRequestModel});

  // Calls LLM via AIAgentService (handles retry + backoff automatically)
  // Returns list of test cases — all isSelected=true by default
  Future<List<TestCase>> generateTestCases({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) async {
    final agent = _TestGeneratorAgent(
      method: method,
      url: url,
      headers: headers,
      body: body,
    );

    final userPrompt = PromptBuilder.unitTestUserPrompt(
      method: method,
      url: url,
      headers: headers,
      body: body,
    );

    final result = await AIAgentService.callAgent(
      agent,
      aiRequestModel,
      query: userPrompt,
    );

    if (result == null) return [];
    return result as List<TestCase>;
  }

  // Runs only test cases where isSelected == true
  // Skipped cases recorded with status=skipped, no HTTP call made
  Future<List<TestResult>> runSelectedTests(List<TestCase> cases) async {
    final results = <TestResult>[];

    for (final testCase in cases) {
      if (!testCase.isSelected) {
        results.add(_skippedResult(testCase));
        continue;
      }
      results.add(await _executeTestCase(testCase));
    }

    return results;
  }

  // Executes a single test case and validates all selected assertions
  Future<TestResult> _executeTestCase(TestCase testCase) async {
    final stopwatch = Stopwatch()..start();

    try {
      final client = _HttpClient();
      final response = await client.send(
        method: testCase.method,
        url: testCase.url,
        headers: testCase.headers,
        body: testCase.body,
      );
      stopwatch.stop();

      final assertionResults = _validateAssertions(
        testCase.assertions,
        statusCode: response.statusCode,
        body: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
      );

      final allPassed = assertionResults
          .where((r) => !r.skipped)
          .every((r) => r.passed);

      return TestResult(
        testCase: testCase,
        actualStatusCode: response.statusCode,
        actualBody: response.body,
        durationMs: stopwatch.elapsedMilliseconds,
        assertionResults: assertionResults,
        overallStatus: allPassed ? TestStatus.passed : TestStatus.failed,
      );
    } catch (e) {
      stopwatch.stop();
      return TestResult(
        testCase: testCase,
        durationMs: stopwatch.elapsedMilliseconds,
        assertionResults: [],
        overallStatus: TestStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  List<AssertionResult> _validateAssertions(
    List<Assertion> assertions, {
    required int statusCode,
    required String body,
    required int durationMs,
  }) {
    return assertions.map((assertion) {
      // Skipped assertions are not checked
      if (!assertion.isSelected) {
        return AssertionResult(
          assertionId: assertion.id,
          passed: false,
          message: 'Skipped',
          skipped: true,
        );
      }

      switch (assertion.type) {
        case AssertionType.statusCode:
          final expected = assertion.expected as int;
          final passed = statusCode == expected;
          return AssertionResult(
            assertionId: assertion.id,
            passed: passed,
            message: passed
                ? 'Status $statusCode ✓'
                : 'Expected $expected, got $statusCode',
          );

        case AssertionType.bodyContains:
          final expected = assertion.expected as String;
          final passed = body.contains(expected);
          return AssertionResult(
            assertionId: assertion.id,
            passed: passed,
            message: passed
                ? 'Body contains "$expected" ✓'
                : 'Body does not contain "$expected"',
          );

        case AssertionType.responseTimeUnder:
          final expected = assertion.expected as int;
          final passed = durationMs < expected;
          return AssertionResult(
            assertionId: assertion.id,
            passed: passed,
            message: passed
                ? '${durationMs}ms < ${expected}ms ✓'
                : '${durationMs}ms exceeded limit of ${expected}ms',
          );
      }
    }).toList();
  }

  TestResult _skippedResult(TestCase testCase) => TestResult(
        testCase: testCase,
        durationMs: 0,
        assertionResults: testCase.assertions
            .map((a) => AssertionResult(
                  assertionId: a.id,
                  passed: false,
                  message: 'Skipped',
                  skipped: true,
                ))
            .toList(),
        overallStatus: TestStatus.skipped,
      );
}

// ─── Minimal HTTP Client (pure Dart, no flutter dependency) ─────────────────

class _HttpResponse {
  final int statusCode;
  final String body;
  _HttpResponse(this.statusCode, this.body);
}

class _HttpClient {
  Future<_HttpResponse> send({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) async {
    // Uses dart:io HttpClient — pure Dart, works in both Flutter and CLI
    final uri = Uri.parse(url);
    final httpClient = HttpClient();

    HttpClientRequest request;
    switch (method.toUpperCase()) {
      case 'POST':
        request = await httpClient.postUrl(uri);
        break;
      case 'PUT':
        request = await httpClient.putUrl(uri);
        break;
      case 'DELETE':
        request = await httpClient.deleteUrl(uri);
        break;
      case 'PATCH':
        request = await httpClient.patchUrl(uri);
        break;
      default:
        request = await httpClient.getUrl(uri);
    }

    headers.forEach((key, value) => request.headers.set(key, value));

    if (body != null && body.isNotEmpty) {
      request.write(body);
    }

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    httpClient.close();
    return _HttpResponse(response.statusCode, responseBody);
  }
}