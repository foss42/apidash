import 'dart:convert';
import 'package:genai/agentic_engine/agentic_engine.dart';
import 'package:genai/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/assertion.dart';
import '../models/test_case.dart';
import '../models/test_result.dart';
import '../utils/prompt_builder.dart';


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

  @override
  Future<bool> validator(String aiResponse) async {
    try {
      final cleaned = _stripMarkdown(aiResponse);
      if (cleaned.isEmpty) return false;

      // Quick structural check before full parse — avoid token-truncated JSON
      if (!cleaned.startsWith('[') || !cleaned.endsWith(']')) return false;

      final parsed = jsonDecode(cleaned);
      if (parsed is! List || parsed.isEmpty) return false;

      // Validate each item has minimum required fields
      for (final item in parsed) {
        if (item is! Map) return false;
        if (item['description'] == null) return false;
        if (item['category'] == null) return false;
        if (item['assertions'] == null) return false;
      }
      return true;
    } catch (e) {
      debugLog('[UnitTestAgent] Validator error: $e');
      return false;
    }
  }

  @override
  Future<List<TestCase>> outputFormatter(String validatedResponse) async {
    final cleaned = _stripMarkdown(validatedResponse);
    final List<dynamic> rawList = jsonDecode(cleaned) as List;
    const uuid = Uuid();

    return rawList.map((raw) {
      final map = raw as Map<String, dynamic>;

      final assertions = (map['assertions'] as List? ?? []).map((a) {
        final aMap = a as Map<String, dynamic>;

        // Safely coerce expected — LLM sometimes sends string instead of int
        dynamic expected = aMap['expected'];
        final type = _parseAssertionType(aMap['type'] as String? ?? '');
        if (type == AssertionType.statusCode && expected is String) {
          expected = int.tryParse(expected) ?? 200;
        }
        if (type == AssertionType.responseTimeUnder && expected is String) {
          expected = int.tryParse(expected) ?? 2000;
        }

        return Assertion(id: uuid.v4(), type: type, expected: expected);
      }).toList();

      return TestCase(
        id: uuid.v4(),
        description: (map['description'] as String? ?? 'Unnamed test').trim(),
        category: _parseCategory(map['category'] as String? ?? ''),
        method: (map['method'] as String? ?? method).toUpperCase(),
        url: map['url'] as String? ?? url,
        headers: Map<String, String>.from((map['headers'] as Map?) ?? headers),
        body: map['body'] as String?,
        assertions: assertions,
      );
    }).toList();
  }

  String _stripMarkdown(String raw) {
    // Remove ```json ... ``` or ``` ... ``` fences
    var cleaned = raw
        .replaceAll(RegExp(r'```json\s*', caseSensitive: false), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    // Extract only the JSON array portion — handles trailing garbage text
    final start = cleaned.indexOf('[');
    final end = cleaned.lastIndexOf(']');
    if (start != -1 && end != -1 && end > start) {
      cleaned = cleaned.substring(start, end + 1);
    }

    return cleaned;
  }

  // Handles both snake_case (from prompt) and camelCase (what Gemini actually returns)
  AssertionType _parseAssertionType(String raw) {
    switch (raw.toLowerCase().replaceAll('_', '')) {
      case 'statuscode':
        return AssertionType.statusCode;
      case 'bodycontains':
        return AssertionType.bodyContains;
      case 'responsetimeunder':
        return AssertionType.responseTimeUnder;
      default:
        debugLog(
          '[UnitTestAgent] Unknown assertion type: "$raw" — defaulting to statusCode',
        );
        return AssertionType.statusCode;
    }
  }

  TestCategory _parseCategory(String raw) {
    switch (raw.toLowerCase().replaceAll('_', '')) {
      case 'happypath':
        return TestCategory.happyPath;
      case 'edgecase':
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

// ─── Public UnitTestAgent (unchanged) ────────────────────────────────────────

class UnitTestAgent {
  final AIRequestModel aiRequestModel;

  UnitTestAgent({required this.aiRequestModel});

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
        .map(
          (a) => AssertionResult(
            assertionId: a.id,
            passed: false,
            message: 'Skipped',
            skipped: true,
          ),
        )
        .toList(),
    overallStatus: TestStatus.skipped,
  );
}

// ─── Minimal HTTP Client ─────────────────────────────────────────────────────

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
    final uri = Uri.parse(url);
    final client = http.Client();
    try {
      final request = http.Request(method.toUpperCase(), uri)
        ..headers.addAll(headers);
      if (body != null && body.isNotEmpty) {
        request.body = body;
      }
      final streamed = await client.send(request);
      final response = await http.Response.fromStream(streamed);
      return _HttpResponse(response.statusCode, response.body);
    } finally {
      client.close();
    }
  }
}

void debugLog(String msg) => print(msg);
