import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('ChatResponse equality & copyWith', () {
    test('equality & hashCode', () {
      const r1 =
          ChatResponse(content: 'Hi', messageType: ChatMessageType.general);
      const r2 =
          ChatResponse(content: 'Hi', messageType: ChatMessageType.general);
      expect(r1, r2);
      expect(r1.hashCode, r2.hashCode);
      expect(r1.toString(), contains('ChatResponse'));
    });

    test('copyWith modifies only provided fields', () {
      const r1 = ChatResponse(content: 'One');
      final r2 = r1.copyWith(content: 'Two');
      expect(r2.content, 'Two');
      expect(r2.messageType, isNull);
      final r3 = r2.copyWith(messageType: ChatMessageType.generateCode);
      expect(r3.messageType, ChatMessageType.generateCode);
      expect(r3.content, 'Two');
    });
  });
}
