import 'package:apidash/dashbot/error/chat_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatFailure', () {
    test('should store message correctly', () {
      const failure = ChatFailure('An error occurred');
      expect(failure.message, 'An error occurred');
      expect(failure.code, isNull);
    });

    test('should store message and code correctly', () {
      const failure = ChatFailure('An error occurred', code: '404');
      expect(failure.message, 'An error occurred');
      expect(failure.code, '404');
    });

    test('toString should return correct format', () {
      const failure = ChatFailure('An error occurred');
      expect(failure.toString(), 'ChatFailure: An error occurred');
    });
  });
}
