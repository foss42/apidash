import 'dart:io';
import 'package:test/test.dart';
import 'package:genai/genai.dart';
import 'package:apidash_agent/apidash_agent.dart';

// ignore_for_file: avoid_print

void main() {
  // ─── Read API key from environment ───────────────────────────────────────
  // Run with: dart test --define=GEMINI_API_KEY=your_key_here
  // OR set env var: $env:GEMINI_API_KEY = "your_key"
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? '';

  // Build the AIRequestModel using the exact pattern from genai package
  final aiRequestModel = AIRequestModel(
    modelApiProvider: ModelAPIProvider.gemini,
    url: kGeminiUrl,
    model: 'gemini-2.5-flash-lite',
    apiKey: apiKey,
    stream: false,
    modelConfigs: [
      kDefaultModelConfigTemperature,
      kDefaultModelConfigTopP,
      kDefaultGeminiModelConfigMaxTokens,
    ],
  );

  late UnitTestAgent agent;

  setUp(() {
    agent = UnitTestAgent(aiRequestModel: aiRequestModel);
  });

  // ─── Test 1: Generation ───────────────────────────────────────────────────
  group('generateTestCases', () {
    test('generates test cases for JSONPlaceholder GET /posts/1', () async {
      if (apiKey.isEmpty) {
        print('⚠️  GEMINI_API_KEY not set — skipping live test');
        return;
      }

      final cases = await agent.generateTestCases(
        method: 'GET',
        url: 'https://jsonplaceholder.typicode.com/posts/1',
        headers: {'Content-Type': 'application/json'},
      );

      print('\n📋 Generated ${cases.length} test cases:');
      for (final tc in cases) {
        print('  [${tc.category.name}] ${tc.description}');
        for (final a in tc.assertions) {
          print('    → ${a.type.name}: ${a.expected}');
        }
      }

      expect(cases, isNotEmpty);
      expect(cases.length, greaterThanOrEqualTo(3));

      // Must have at least one happy path
      expect(
        cases.any((c) => c.category == TestCategory.happyPath),
        isTrue,
        reason: 'Should generate at least one happy path test',
      );

      // All cases start selected
      expect(cases.every((c) => c.isSelected), isTrue);

      // All assertions start selected
      expect(
        cases.every((c) => c.assertions.every((a) => a.isSelected)),
        isTrue,
      );
    }, timeout: const Timeout(Duration(seconds: 120)));
  });

  // ─── Test 2: Execution ────────────────────────────────────────────────────
  group('runSelectedTests', () {
    test('runs only selected test cases against real API', () async {
      if (apiKey.isEmpty) {
        print('⚠️  GEMINI_API_KEY not set — skipping live test');
        return;
      }

      final cases = await agent.generateTestCases(
        method: 'GET',
        url: 'https://jsonplaceholder.typicode.com/posts/1',
        headers: {'Content-Type': 'application/json'},
      );

      // Deselect all except the happy path
      for (var i = 0; i < cases.length; i++) {
        final tc = cases[i];
        cases[i] = tc.copyWith(
          isSelected: tc.category == TestCategory.happyPath,
        );
      }

      final results = await agent.runSelectedTests(cases);

      print('\n🧪 Test Results:');
      for (final r in results) {
        final icon = r.overallStatus == TestStatus.passed
            ? '✅'
            : r.overallStatus == TestStatus.skipped
                ? '⏭️ '
                : '❌';
        print('  $icon [${r.overallStatus.name}] ${r.testCase.description}');
        if (r.actualStatusCode != null) {
          print('     HTTP ${r.actualStatusCode} in ${r.durationMs}ms');
        }
        for (final ar in r.assertionResults) {
          if (!ar.skipped) {
            print('     ${ar.passed ? "✓" : "✗"} ${ar.message}');
          }
        }
      }

      // Skipped cases must exist (we deselected non-happy-path)
      expect(
        results.any((r) => r.overallStatus == TestStatus.skipped),
        isTrue,
      );

      // Happy path must have run and passed
      final happyResults = results
          .where((r) => r.testCase.category == TestCategory.happyPath)
          .toList();
      expect(happyResults, isNotEmpty);
      expect(happyResults.first.overallStatus, equals(TestStatus.passed));
    }, timeout: const Timeout(Duration(seconds: 180)));

    test('marks deselected cases as skipped without HTTP call', () async {
      // This test uses NO API key — purely unit testing the skip logic
      final mockCases = [
        TestCase(
          id: 'test-1',
          description: 'Happy path',
          category: TestCategory.happyPath,
          method: 'GET',
          url: 'https://jsonplaceholder.typicode.com/posts/1',
          headers: {},
          assertions: [
            Assertion(
              id: 'a-1',
              type: AssertionType.statusCode,
              expected: 200,
            ),
          ],
          isSelected: false, // DESELECTED
        ),
      ];

      final results = await agent.runSelectedTests(mockCases);

      expect(results.length, equals(1));
      expect(results.first.overallStatus, equals(TestStatus.skipped));
      expect(results.first.durationMs, equals(0)); // no HTTP call made
    });
  });

  // ─── Test 3: JsonPathExtractor ────────────────────────────────────────────
  group('JsonPathExtractor', () {
    test('extracts top-level field', () {
      final result = JsonPathExtractor.extract(
        r'$.id',
        '{"id": 42, "name": "Alice"}',
      );
      expect(result, equals(42));
    });

    test('extracts nested field', () {
      final result = JsonPathExtractor.extract(
        r'$.data.userId',
        '{"data": {"userId": 7}}',
      );
      expect(result, equals(7));
    });

    test('extracts array index', () {
      final result = JsonPathExtractor.extract(
        r'$.items[0].id',
        '{"items": [{"id": 99}, {"id": 100}]}',
      );
      expect(result, equals(99));
    });

    test('returns null for missing path', () {
      final result = JsonPathExtractor.extract(
        r'$.missing.path',
        '{"id": 1}',
      );
      expect(result, isNull);
    });
  });
}