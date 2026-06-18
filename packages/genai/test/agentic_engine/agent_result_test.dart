import 'package:flutter_test/flutter_test.dart';
import 'package:genai/agentic_engine/agent_result.dart';

void main() {
  group('AgentErrorType', () {
    test('has all expected error types', () {
      expect(AgentErrorType.values, containsAll([
        AgentErrorType.authFailure,
        AgentErrorType.rateLimited,
        AgentErrorType.invalidRequest,
        AgentErrorType.validationFailed,
        AgentErrorType.networkError,
        AgentErrorType.unexpected,
      ]));
    });

    test('has exactly 6 error types', () {
      expect(AgentErrorType.values.length, 6);
    });
  });

  group('AgentException', () {
    test('creates with required fields', () {
      const exception = AgentException(
        type: AgentErrorType.authFailure,
        message: 'Auth failed',
        agentName: 'TestAgent',
      );

      expect(exception.type, AgentErrorType.authFailure);
      expect(exception.message, 'Auth failed');
      expect(exception.agentName, 'TestAgent');
      expect(exception.retryAttempts, 0);
      expect(exception.cause, isNull);
    });

    test('creates with all fields', () {
      final cause = Exception('underlying error');
      final exception = AgentException(
        type: AgentErrorType.rateLimited,
        message: 'Rate limited',
        agentName: 'TestAgent',
        retryAttempts: 3,
        cause: cause,
      );

      expect(exception.type, AgentErrorType.rateLimited);
      expect(exception.message, 'Rate limited');
      expect(exception.agentName, 'TestAgent');
      expect(exception.retryAttempts, 3);
      expect(exception.cause, cause);
    });

    test('implements Exception', () {
      const exception = AgentException(
        type: AgentErrorType.unexpected,
        message: 'test',
        agentName: 'TestAgent',
      );
      expect(exception, isA<Exception>());
    });

    test('toString includes type, agent name and message', () {
      const exception = AgentException(
        type: AgentErrorType.networkError,
        message: 'Connection failed',
        agentName: 'MyAgent',
      );
      final str = exception.toString();
      expect(str, contains('networkError'));
      expect(str, contains('MyAgent'));
      expect(str, contains('Connection failed'));
    });

    test('toString includes retry attempts when non-zero', () {
      const exception = AgentException(
        type: AgentErrorType.validationFailed,
        message: 'Failed validation',
        agentName: 'TestAgent',
        retryAttempts: 5,
      );
      final str = exception.toString();
      expect(str, contains('after 5 retries'));
    });

    test('toString does not include retry info when zero', () {
      const exception = AgentException(
        type: AgentErrorType.authFailure,
        message: 'Auth error',
        agentName: 'TestAgent',
        retryAttempts: 0,
      );
      final str = exception.toString();
      expect(str, isNot(contains('retries')));
    });

    test('toString includes cause when present', () {
      final exception = AgentException(
        type: AgentErrorType.unexpected,
        message: 'Error',
        agentName: 'TestAgent',
        cause: Exception('root cause'),
      );
      final str = exception.toString();
      expect(str, contains('Caused by'));
      expect(str, contains('root cause'));
    });

    test('toString excludes cause when null', () {
      const exception = AgentException(
        type: AgentErrorType.unexpected,
        message: 'Error',
        agentName: 'TestAgent',
      );
      final str = exception.toString();
      expect(str, isNot(contains('Caused by')));
    });
  });

  group('AgentResult', () {
    group('AgentSuccess', () {
      test('wraps a value', () {
        const result = AgentSuccess('hello');
        expect(result.value, 'hello');
      });

      test('isSuccess returns true', () {
        const result = AgentSuccess(42);
        expect(result.isSuccess, isTrue);
      });

      test('isFailure returns false', () {
        const result = AgentSuccess(42);
        expect(result.isFailure, isFalse);
      });

      test('valueOrNull returns the value', () {
        const result = AgentSuccess<String>('data');
        expect(result.valueOrNull, 'data');
      });

      test('exceptionOrNull returns null', () {
        const result = AgentSuccess<String>('data');
        expect(result.exceptionOrNull, isNull);
      });

      test('is an AgentResult', () {
        const result = AgentSuccess('test');
        expect(result, isA<AgentResult<String>>());
      });

      test('toString includes value', () {
        const result = AgentSuccess('my_value');
        expect(result.toString(), contains('my_value'));
      });

      test('wraps null value', () {
        const result = AgentSuccess<String?>(null);
        expect(result.value, isNull);
        expect(result.isSuccess, isTrue);
      });

      test('wraps Map value', () {
        const result = AgentSuccess({'key': 'value'});
        expect(result.value, {'key': 'value'});
      });
    });

    group('AgentFailure', () {
      const exception = AgentException(
        type: AgentErrorType.authFailure,
        message: 'Auth failed',
        agentName: 'TestAgent',
      );

      test('wraps an exception', () {
        const result = AgentFailure<String>(exception);
        expect(result.exception, exception);
      });

      test('isSuccess returns false', () {
        const result = AgentFailure<String>(exception);
        expect(result.isSuccess, isFalse);
      });

      test('isFailure returns true', () {
        const result = AgentFailure<String>(exception);
        expect(result.isFailure, isTrue);
      });

      test('valueOrNull returns null', () {
        const result = AgentFailure<String>(exception);
        expect(result.valueOrNull, isNull);
      });

      test('exceptionOrNull returns the exception', () {
        const result = AgentFailure<String>(exception);
        expect(result.exceptionOrNull, exception);
      });

      test('is an AgentResult', () {
        const result = AgentFailure<String>(exception);
        expect(result, isA<AgentResult<String>>());
      });

      test('toString includes exception', () {
        const result = AgentFailure<String>(exception);
        expect(result.toString(), contains('AgentFailure'));
        expect(result.toString(), contains('Auth failed'));
      });
    });

    group('when', () {
      test('calls success callback for AgentSuccess', () {
        const AgentResult<String> result = AgentSuccess('data');
        final output = result.when(
          success: (value) => 'Got: $value',
          failure: (exception) => 'Error: ${exception.message}',
        );
        expect(output, 'Got: data');
      });

      test('calls failure callback for AgentFailure', () {
        const AgentResult<String> result = AgentFailure(AgentException(
          type: AgentErrorType.networkError,
          message: 'No internet',
          agentName: 'TestAgent',
        ));
        final output = result.when(
          success: (value) => 'Got: $value',
          failure: (exception) => 'Error: ${exception.message}',
        );
        expect(output, 'Error: No internet');
      });

      test('supports different return types', () {
        const AgentResult<int> result = AgentSuccess(42);
        final output = result.when(
          success: (value) => value * 2,
          failure: (exception) => -1,
        );
        expect(output, 84);
      });

      test('success callback receives the exact value', () {
        final map = {'STAC': '{"type":"text"}'};
        final AgentResult<Map<String, String>> result = AgentSuccess(map);
        result.when(
          success: (value) {
            expect(value, same(map));
            expect(value['STAC'], '{"type":"text"}');
          },
          failure: (exception) => fail('Should not reach failure'),
        );
      });

      test('failure callback receives the exact exception', () {
        const exception = AgentException(
          type: AgentErrorType.validationFailed,
          message: 'Invalid JSON',
          agentName: 'StacGenBot',
          retryAttempts: 5,
        );
        const AgentResult<String> result = AgentFailure(exception);
        result.when(
          success: (value) => fail('Should not reach success'),
          failure: (e) {
            expect(e.type, AgentErrorType.validationFailed);
            expect(e.agentName, 'StacGenBot');
            expect(e.retryAttempts, 5);
          },
        );
      });
    });

    group('pattern matching', () {
      test('switch expression works with AgentSuccess', () {
        const AgentResult<String> result = AgentSuccess('test');
        final output = switch (result) {
          AgentSuccess(:final value) => 'Success: $value',
          AgentFailure(:final exception) => 'Failure: ${exception.message}',
        };
        expect(output, 'Success: test');
      });

      test('switch expression works with AgentFailure', () {
        const AgentResult<String> result = AgentFailure(AgentException(
          type: AgentErrorType.rateLimited,
          message: 'Too many requests',
          agentName: 'TestAgent',
        ));
        final output = switch (result) {
          AgentSuccess(:final value) => 'Success: $value',
          AgentFailure(:final exception) => 'Failure: ${exception.message}',
        };
        expect(output, 'Failure: Too many requests');
      });
    });

    group('type safety', () {
      test('AgentSuccess with dynamic type', () {
        final AgentResult<dynamic> result =
            AgentSuccess({'FUNC': 'def my_func(): pass'});
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isA<Map>());
      });

      test('AgentFailure preserves type parameter', () {
        const AgentResult<Map<String, dynamic>> result = AgentFailure(
          AgentException(
            type: AgentErrorType.unexpected,
            message: 'Error',
            agentName: 'TestAgent',
          ),
        );
        expect(result.isFailure, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });
  });

  group('AgentErrorType coverage', () {
    test('authFailure for authentication issues', () {
      const exception = AgentException(
        type: AgentErrorType.authFailure,
        message: 'Invalid API key',
        agentName: 'TestAgent',
      );
      expect(exception.type, AgentErrorType.authFailure);
    });

    test('rateLimited for rate limit errors', () {
      const exception = AgentException(
        type: AgentErrorType.rateLimited,
        message: 'Too many requests',
        agentName: 'TestAgent',
      );
      expect(exception.type, AgentErrorType.rateLimited);
    });

    test('invalidRequest for bad configuration', () {
      const exception = AgentException(
        type: AgentErrorType.invalidRequest,
        message: 'No model configured',
        agentName: 'TestAgent',
      );
      expect(exception.type, AgentErrorType.invalidRequest);
    });

    test('validationFailed for invalid LLM output', () {
      const exception = AgentException(
        type: AgentErrorType.validationFailed,
        message: 'Response was not valid JSON',
        agentName: 'StacGenBot',
      );
      expect(exception.type, AgentErrorType.validationFailed);
    });

    test('networkError for connectivity issues', () {
      const exception = AgentException(
        type: AgentErrorType.networkError,
        message: 'No internet connection',
        agentName: 'TestAgent',
      );
      expect(exception.type, AgentErrorType.networkError);
    });

    test('unexpected for unknown errors', () {
      const exception = AgentException(
        type: AgentErrorType.unexpected,
        message: 'Something went wrong',
        agentName: 'TestAgent',
      );
      expect(exception.type, AgentErrorType.unexpected);
    });
  });
}
