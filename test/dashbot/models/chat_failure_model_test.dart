import 'package:apidash/dashbot/error/chat_failure.dart';
import 'package:test/test.dart';

void main() {
  group('ChatFailure basics', () {
    test('toString format', () {
      const f = ChatFailure('network down', code: '503');
      expect(f.toString(), 'ChatFailure: network down');
    });
  });
}
