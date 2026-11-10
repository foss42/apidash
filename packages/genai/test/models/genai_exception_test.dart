import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/models.dart';

void main() {
  group('GenAIException', () {
    test('creates instance with only message', () {
      const exception = GenAIException('An error occurred');
      expect(exception.message, 'An error occurred');
      expect(exception.statusCode, isNull);
      expect(exception.details, isNull);
      expect(exception.toString(), 'GenAIException: An error occurred');
    });

    test('creates instance with message, statusCode, and details', () {
      const exception = GenAIException(
        'Invalid API Key',
        statusCode: 401,
        details: '{"error": {"message": "Invalid API Key"}}',
      );
      expect(exception.message, 'Invalid API Key');
      expect(exception.statusCode, 401);
      expect(exception.details, '{"error": {"message": "Invalid API Key"}}');
      expect(exception.toString(), 'GenAIException (401): Invalid API Key');
    });

    test('supports value equality and hashCode', () {
      const ex1 = GenAIException('Rate limit', statusCode: 429);
      const ex2 = GenAIException('Rate limit', statusCode: 429);
      const ex3 = GenAIException('Rate limit', statusCode: 500);

      expect(ex1, equals(ex2));
      expect(ex1.hashCode, equals(ex2.hashCode));
      expect(ex1, isNot(equals(ex3)));
    });

    test('implements Exception', () {
      const exception = GenAIException('Failed');
      expect(exception, isA<Exception>());
    });
  });
}
