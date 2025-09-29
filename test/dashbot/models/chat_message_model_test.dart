import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('ChatMessage equality & hashCode', () {
    final ts = DateTime.utc(2025, 1, 2, 3, 4, 5);
    const action = ChatAction(
      action: 'update_field',
      target: 'httpRequestModel',
      field: 'url',
      value: 'https://api.apidash.dev',
      actionType: ChatActionType.updateField,
      targetType: ChatActionTarget.httpRequestModel,
    );

    test('identical field values -> objects equal & same hashCode', () {
      final msg1 = ChatMessage(
        id: 'm1',
        content: 'Hello',
        role: MessageRole.user,
        timestamp: ts,
        messageType: ChatMessageType.general,
        actions: const [action],
      );
      final msg2 = ChatMessage(
        id: 'm1',
        content: 'Hello',
        role: MessageRole.user,
        timestamp: ts,
        messageType: ChatMessageType.general,
        actions: const [action],
      );
      expect(msg1, msg2);
      expect(msg1.hashCode, msg2.hashCode);
      expect(msg1.toString(), contains('ChatMessage'));
      expect(msg1.toString(), contains('m1'));
    });

    test('different id -> not equal', () {
      final a = ChatMessage(
        id: 'a',
        content: 'Hi',
        role: MessageRole.user,
        timestamp: ts,
      );
      final b = a.copyWith(id: 'b');
      expect(a == b, isFalse);
    });

    test('copyWith returns updated instance only for provided fields', () {
      final base = ChatMessage(
        id: 'base',
        content: 'Original',
        role: MessageRole.system,
        timestamp: ts,
      );
      final updated = base.copyWith(content: 'Updated');
      expect(updated.content, 'Updated');
      expect(updated.id, 'base');
      expect(updated.role, MessageRole.system);
    });
  });
}
