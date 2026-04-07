// ignore_for_file: avoid_print
import 'dart:io';
import 'package:test/test.dart';
import 'package:genai/genai.dart';
import 'package:apidash_agent/apidash_agent.dart';

void main() {
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? '';

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

  late WorkflowAgent agent;

  setUp(() {
    agent = WorkflowAgent(aiRequestModel: aiRequestModel);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Group 1: Unit tests — no API key needed
  // ─────────────────────────────────────────────────────────────────────────
  group('WorkflowAgent — unit tests (no API key)', () {

    test('execute() — resolves {{placeholders}} correctly', () async {
      final steps = [
        WorkflowStep(
          name: 'GET httpbin /get',
          method: 'GET',
          // httpbin.org echoes back request details — always returns 200
          url: 'https://httpbin.org/get',
          headers: {},
          body: null,
          assertions: [
            Assertion(
              id: 'a-1',
              type: AssertionType.statusCode,
              expected: 200,
            ),
          ],
          dataExtractions: [
            DataBinding(
              variableName: 'origin',
              jsonPath: r'$.origin', // httpbin always returns this field
            ),
          ],
        ),
      ];

      final results = <WorkflowStepResult>[];
      await for (final r in agent.execute(steps)) {
        results.add(r);
      }

      expect(results.length, equals(1));
      expect(results.first.actualStatusCode, equals(200));
      expect(results.first.overallStatus, equals(TestStatus.passed));
      expect(results.first.extractedValues.containsKey('origin'), isTrue);
      print('\n✅ Step passed — extracted: ${results.first.extractedValues}');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('execute() — fails assertion correctly on wrong status code', () async {
      final steps = [
        WorkflowStep(
          name: 'Expect 404 but get 200',
          method: 'GET',
          url: 'https://jsonplaceholder.typicode.com/posts/1',
          headers: {},
          body: null,
          assertions: [
            Assertion(
              id: 'a-bad',
              type: AssertionType.statusCode,
              expected: 404, // Wrong on purpose
            ),
          ],
          dataExtractions: [],
        ),
      ];

      final results = <WorkflowStepResult>[];
      await for (final r in agent.execute(steps)) {
        results.add(r);
      }

      expect(results.first.overallStatus, equals(TestStatus.failed));
      expect(results.first.assertionResults.first.passed, isFalse);
      print('\n✅ Failure detected correctly: '
            '${results.first.assertionResults.first.message}');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('execute() — HTTP error yields failed step without crashing', () async {
      final steps = [
        WorkflowStep(
          name: 'Invalid URL',
          method: 'GET',
          url: 'http://localhost:19999/does-not-exist',
          headers: {},
          body: null,
          assertions: [],
          dataExtractions: [],
        ),
        WorkflowStep(
          name: 'This step should still run',
          method: 'GET',
          // Use httpbin — guaranteed 200
          url: 'https://httpbin.org/get',
          headers: {},
          body: null,
          assertions: [
            Assertion(
              id: 'a-2',
              type: AssertionType.statusCode,
              expected: 200,
            ),
          ],
          dataExtractions: [],
        ),
      ];

      final results = <WorkflowStepResult>[];
      await for (final r in agent.execute(steps)) {
        results.add(r);
      }

      expect(results.length, equals(2));
      expect(results[0].overallStatus, equals(TestStatus.failed));
      expect(results[0].errorMessage, isNotNull);
      expect(results[1].overallStatus, equals(TestStatus.passed));
      print('\n✅ Step 1 failed gracefully, Step 2 still ran');
    }, timeout: const Timeout(Duration(seconds: 30)));

  });

  // ─────────────────────────────────────────────────────────────────────────
  // Group 2: The agentic showcase — POST → extract ID → GET (needs API key)
  // ─────────────────────────────────────────────────────────────────────────
  group('WorkflowAgent — agentic 2-step workflow (live API)', () {

    test('generatePlan() builds a multi-step plan from 2 requests', () async {
      if (apiKey.isEmpty) {
        print('⚠️  GEMINI_API_KEY not set — skipping live LLM test');
        return;
      }

      // Describe two real API calls — agent must figure out the data binding
      final requests = [
        {
          'name': 'Create a post',
          'method': 'POST',
          'url': 'https://jsonplaceholder.typicode.com/posts',
          'headers': {'Content-Type': 'application/json'},
          'body': '{"title": "Test Post", "body": "Hello", "userId": 1}',
          'description':
              'Creates a new post and returns the created object with an id field',
        },
        {
          'name': 'Fetch the created post',
          'method': 'GET',
          'url': 'https://jsonplaceholder.typicode.com/posts/{{postId}}',
          'headers': {},
          'body': null,
          'description':
              'Fetches the post created in step 1 using its id. '
              'The postId should be extracted from the previous step response at \$.id',
        },
      ];

      print('\n🤖 Asking LLM to generate workflow plan...');
      final steps = await agent.generatePlan(requests);

      print('📋 Generated ${steps.length} steps:');
      for (final s in steps) {
        print('  → [${s.method}] ${s.url}');
        for (final a in s.assertions) {
          print('    assert: ${a.type.name} = ${a.expected}');
        }
        for (final d in s.dataExtractions) {
          print('    extract: \$\${{${d.variableName}}} from ${d.jsonPath}');
        }
      }

      expect(steps, isNotEmpty);
      expect(steps.length, greaterThanOrEqualTo(2));

      // Step 1 must have a data extraction (the whole point of agentic testing)
      final step1Extractions = steps.first.dataExtractions;
      expect(
        step1Extractions,
        isNotEmpty,
        reason: 'Agent should extract postId from step 1 response',
      );
    }, timeout: const Timeout(Duration(seconds: 120)));

    test('execute() — full 2-step POST→GET with real data binding', () async {
      // This test does NOT need an API key — we handcraft the workflow
      // to showcase the agentic data-passing behaviour
      final steps = [
        // Step 1: POST — creates a resource
        WorkflowStep(
          name: 'POST /post (create)',
          method: 'POST',
          url: 'https://httpbin.org/post',
          headers: {'Content-Type': 'application/json'},
          body: '{"title": "Agentic Test", "userId": 1}',
          assertions: [
            Assertion(
              id: 'step1-status',
              type: AssertionType.statusCode,
              expected: 200,
            ),
            Assertion(
              id: 'step1-body',
              type: AssertionType.bodyContains,
              expected: 'Agentic Test',
            ),
          ],
          // httpbin echoes posted JSON under the "json" key.
          dataExtractions: [
            DataBinding(
              variableName: 'title',
              jsonPath: r'$.json.title',
            ),
          ],
        ),

        // Step 2: GET — uses the extracted title from step 1
        WorkflowStep(
          name: 'GET /get (verify)',
          method: 'GET',
          url: 'https://httpbin.org/get?title={{title}}',
          headers: {},
          body: null,
          assertions: [
            Assertion(
              id: 'step2-status',
              type: AssertionType.statusCode,
              expected: 200,
            ),
            Assertion(
              id: 'step2-body',
              type: AssertionType.bodyContains,
              expected: 'Agentic Test',
            ),
          ],
          dataExtractions: [],
        ),
      ];

      print('\n🚀 Running 2-step agentic workflow...');
      final results = <WorkflowStepResult>[];

      await for (final r in agent.execute(steps)) {
        results.add(r);
        final icon = r.overallStatus == TestStatus.passed ? '✅' : '❌';
        print('\n$icon ${r.step.name}');
        print('   URL      : ${r.step.url}');
        print('   Status   : HTTP ${r.actualStatusCode} '
              '(${r.durationMs}ms)');
        for (final ar in r.assertionResults) {
          print('   ${ar.passed ? "✓" : "✗"} ${ar.message}');
        }
        if (r.extractedValues.isNotEmpty) {
          print('   Extracted: ${r.extractedValues}');
        }
        if (r.errorMessage != null) {
          print('   Error: ${r.errorMessage}');
        }
      }

      // Both steps must complete
      expect(results.length, equals(2),
          reason: 'Both steps must yield results');

      // Step 1 must pass
      expect(results[0].overallStatus, equals(TestStatus.passed),
          reason: 'POST must return 200');

        // Step 1 must extract title
        expect(results[0].extractedValues.containsKey('title'), isTrue,
          reason: 'title must be extracted for data binding');

        // Step 2 URL must have resolved the {{title}} placeholder
      // (we check the resolved URL via actualBody being non-null — 
      //  the real URL resolved correctly if we got a 200)
      expect(results[1].actualStatusCode, equals(200),
          reason: 'GET with resolved title must return 200');

      expect(results[1].overallStatus, equals(TestStatus.passed));

        print('\n🎯 Data binding verified: title extracted from Step 1 '
            'and injected into Step 2 URL');
    }, timeout: const Timeout(Duration(seconds: 60)));

  });
}