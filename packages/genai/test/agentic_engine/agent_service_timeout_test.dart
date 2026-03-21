import 'dart:async';
import 'package:genai/agentic_engine/agent_service.dart';
import 'package:genai/agentic_engine/blueprint.dart';
import 'package:genai/models/models.dart';
import 'package:test/test.dart';

/// A test agent that always validates and returns a fixed output.
class _SuccessAgent extends AIAgent {
  @override
  String get agentName => 'SuccessAgent';

  @override
  String getSystemPrompt() => 'Test prompt';

  @override
  Future<bool> validator(String aiResponse) async => true;

  @override
  Future<dynamic> outputFormatter(String validatedResponse) async =>
      {'result': validatedResponse};
}

/// A test agent whose validator always fails, forcing retries.
class _AlwaysFailsValidationAgent extends AIAgent {
  int callCount = 0;

  @override
  String get agentName => 'AlwaysFailsValidation';

  @override
  String getSystemPrompt() => 'Test prompt';

  @override
  Future<bool> validator(String aiResponse) async {
    callCount++;
    return false;
  }

  @override
  Future<dynamic> outputFormatter(String validatedResponse) async =>
      validatedResponse;
}

void main() {
  group('AIAgentService timeout constants', () {
    test('kDefaultAgentCallTimeout is 30 seconds', () {
      expect(kDefaultAgentCallTimeout, equals(const Duration(seconds: 30)));
    });

    test('kDefaultAgentTotalTimeout is 120 seconds', () {
      expect(kDefaultAgentTotalTimeout, equals(const Duration(seconds: 120)));
    });

    test('perCallTimeout defaults are positive durations', () {
      expect(kDefaultAgentCallTimeout.inSeconds, greaterThan(0));
      expect(kDefaultAgentTotalTimeout.inSeconds, greaterThan(0));
    });

    test('total timeout is greater than per-call timeout', () {
      expect(
        kDefaultAgentTotalTimeout.inSeconds,
        greaterThan(kDefaultAgentCallTimeout.inSeconds),
      );
    });
  });

  group('AIAgentService.callAgent timeout parameters', () {
    test('callAgent accepts custom perCallTimeout parameter', () async {
      // This test verifies the API accepts the parameter without error.
      // The actual LLM call will fail (no real provider), but the parameter
      // should be accepted by the method signature.
      final agent = _SuccessAgent();
      final model = AIRequestModel();

      // Should not throw a compilation/signature error
      final result = await AIAgentService.callAgent(
        agent,
        model,
        query: 'test',
        perCallTimeout: const Duration(seconds: 5),
      );

      // Result will be null since there's no real LLM provider,
      // but the important thing is the parameter was accepted.
      expect(result, isNull);
    });

    test('callAgent accepts custom totalTimeout parameter', () async {
      final agent = _SuccessAgent();
      final model = AIRequestModel();

      final result = await AIAgentService.callAgent(
        agent,
        model,
        query: 'test',
        totalTimeout: const Duration(seconds: 10),
      );

      expect(result, isNull);
    });

    test('callAgent accepts both timeout parameters together', () async {
      final agent = _SuccessAgent();
      final model = AIRequestModel();

      final result = await AIAgentService.callAgent(
        agent,
        model,
        query: 'test',
        perCallTimeout: const Duration(seconds: 5),
        totalTimeout: const Duration(seconds: 15),
      );

      expect(result, isNull);
    });
  });

  group('AIAgentService total timeout behavior', () {
    test(
      'governor respects totalTimeout and stops retrying',
      () async {
        final agent = _AlwaysFailsValidationAgent();
        final model = AIRequestModel();

        final stopwatch = Stopwatch()..start();
        final result = await AIAgentService.callAgent(
          agent,
          model,
          query: 'test',
          // Very short total timeout to force early exit
          totalTimeout: const Duration(milliseconds: 100),
          perCallTimeout: const Duration(seconds: 1),
        );
        stopwatch.stop();

        expect(result, isNull);
        // Should have stopped well before the full 5 retries would take
        // (5 retries with backoff would take > 6 seconds)
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      },
    );
  });

  group('TimeoutException handling', () {
    test('TimeoutException is a proper Dart exception type', () {
      final exception = TimeoutException(
        'Test timeout',
        const Duration(seconds: 30),
      );
      expect(exception, isA<TimeoutException>());
      expect(exception.message, equals('Test timeout'));
      expect(exception.duration, equals(const Duration(seconds: 30)));
    });

    test('TimeoutException toString includes message', () {
      final exception = TimeoutException(
        'LLM call timed out after 30s',
        const Duration(seconds: 30),
      );
      expect(exception.toString(), contains('LLM call timed out'));
    });
  });
}
