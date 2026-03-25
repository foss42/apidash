import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/agentic_testing/engine/rules_evaluator.dart';
import 'package:apidash/agentic_testing/models/test_expectation.dart';
import 'package:apidash/agentic_testing/execution/execution_response.dart';

void main() {
  group('RulesEvaluator', () {
    test('passes when all expectations are met (Security Check)', () {
      final List<TestExpectation> expectations = [
        const TestExpectation(expectedStatus: 401),
      ];

      final response = ExecutionResponse(
        statusCode: 401,
        time: const Duration(milliseconds: 150),
      );

      final result = RulesEvaluator.evaluate(response, expectations);
      expect(result, isTrue);
    });

    test('fails when endpoint insecurely accepts bad request', () {
      final List<TestExpectation> expectations = [
        const TestExpectation(expectedStatus: 401),
      ];

      final response = ExecutionResponse(
        statusCode: 200, // Danger!
        time: const Duration(milliseconds: 150),
      );

      final result = RulesEvaluator.evaluate(response, expectations);
      expect(result, isFalse);
    });

    test('validates performance latency accurately', () {
      final List<TestExpectation> expectations = [
        const TestExpectation(maxLatencyMs: 200),
      ];

      // Passes
      final fastResponse = ExecutionResponse(
        statusCode: 200,
        time: const Duration(milliseconds: 150),
      );
      expect(RulesEvaluator.evaluate(fastResponse, expectations), isTrue);

      // Fails
      final slowResponse = ExecutionResponse(
        statusCode: 200,
        time: const Duration(milliseconds: 300),
      );
      expect(RulesEvaluator.evaluate(slowResponse, expectations), isFalse);
    });

    test('validates multiple complex expectations simultaneously', () {
      final List<TestExpectation> expectations = [
        const TestExpectation(
          expectedStatus: 400,
          mustContainBodyTexts: ['validation error'],
          requiredHeaders: ['X-Error-Code'],
        ),
      ];

      final perfectResponse = ExecutionResponse(
        statusCode: 400,
        headers: {'x-error-code': '1001'},
        body: '{"message": "validation error in payload"}',
      );
      expect(RulesEvaluator.evaluate(perfectResponse, expectations), isTrue);

      final missingSubstring = ExecutionResponse(
        statusCode: 400,
        headers: {'x-error-code': '1001'},
        body: '{"message": "unknown error"}',
      );
      expect(RulesEvaluator.evaluate(missingSubstring, expectations), isFalse);
    });
  });
}