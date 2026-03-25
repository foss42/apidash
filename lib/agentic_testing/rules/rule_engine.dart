import 'package:apidash/agentic_testing/models/models.dart';
import 'rule_input.dart';

class RuleEngine {
  const RuleEngine();

  List<TestCase> generate(RuleInput input) {
    final cases = <TestCase>[];

    cases.add(
      TestCase(
        id: _id(input, 'valid_request'),
        name: 'Valid Request',
        description: 'Baseline request should succeed for expected API behavior.',
        source: TestSource.rule,
        expectation: const TestExpectation(expectedStatus: 200),
      ),
    );

    if (input.endpointLikelyProtected || input.hasAuthHeader) {
      cases.add(
        TestCase(
          id: _id(input, 'missing_auth'),
          name: 'Missing Auth',
          description: 'Remove authorization and verify protected endpoint rejects request.',
          source: TestSource.rule,
          requestPatch: const {
            'removeHeaders': ['Authorization'],
          },
          expectation: const TestExpectation(expectedStatus: 401),
        ),
      );
    }

    if (input.methodSupportsBody && input.hasBody) {
      cases.add(
        TestCase(
          id: _id(input, 'empty_body'),
          name: 'Empty Body',
          description: 'Send empty body where payload is required.',
          source: TestSource.rule,
          requestPatch: const {
            'body': '',
          },
          expectation: const TestExpectation(expectedStatus: 400),
        ),
      );
    }

    if (input.methodSupportsBody && (input.isJsonRequest || input.hasBody)) {
      cases.add(
        TestCase(
          id: _id(input, 'malformed_json'),
          name: 'Malformed JSON',
          description: 'Send malformed JSON payload and verify validation error.',
          source: TestSource.rule,
          requestPatch: const {
            'body': '{"broken":',
            'upsertHeaders': {'Content-Type': 'application/json'},
          },
          expectation: const TestExpectation(expectedStatus: 400),
        ),
      );
    }

    return cases;
    }

  String _id(RuleInput input, String suffix) {
    final method = input.method.toUpperCase();
    final urlHash = input.url.hashCode.abs();
    return 'rule_${method}_${urlHash}_$suffix';
  }
}