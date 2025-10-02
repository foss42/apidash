import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/error/chat_failure.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('ChatMessage & ChatState', () {
    test('ChatMessage copyWith preserves and overrides fields', () {
      final ts = DateTime.utc(2024, 5, 6, 7, 8, 9);
      const action = ChatAction(
        action: 'update_field',
        target: 'httpRequestModel',
        field: 'url',
        value: 'https://api.apidash.dev',
        actionType: ChatActionType.updateField,
        targetType: ChatActionTarget.httpRequestModel,
      );

      final m1 = ChatMessage(
        id: 'm1',
        content: 'Hello',
        role: MessageRole.user,
        timestamp: ts,
        messageType: ChatMessageType.general,
        actions: const [action],
      );

      final m2 = m1.copyWith(content: 'Hi', role: MessageRole.system);
      expect(m2.id, 'm1');
      expect(m2.content, 'Hi');
      expect(m2.role, MessageRole.system);
      expect(m2.timestamp, ts);
      expect(m2.messageType, ChatMessageType.general);
      expect(m2.actions, isNotNull);
      expect(m2.actions!.length, 1);
    });

    test('ChatState copyWith', () {
      final msg = ChatMessage(
        id: '1',
        content: 'c',
        role: MessageRole.user,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      );
      const failure = ChatFailure('net down', code: '500');
      const state = ChatState();
      final updated = state.copyWith(
        chatSessions: {
          'req1': [msg]
        },
        isGenerating: true,
        currentStreamingResponse: 'streaming..',
        currentRequestId: 'req1',
        lastError: failure,
      );

      expect(updated.chatSessions['req1']!.first, msg);
      expect(updated.isGenerating, true);
      expect(updated.currentStreamingResponse, 'streaming..');
      expect(updated.currentRequestId, 'req1');
      expect(updated.lastError, failure);

      // unchanged original
      expect(state.chatSessions, isEmpty);
      expect(state.isGenerating, false);
    });

    test('ChatResponse copyWith', () {
      const r1 =
          ChatResponse(content: 'Hello', messageType: ChatMessageType.general);
      final r2 = r1.copyWith(content: 'Hi again');
      expect(r2.content, 'Hi again');
      expect(r2.messageType, ChatMessageType.general);
      final r3 = r2.copyWith(messageType: ChatMessageType.generateCode);
      expect(r3.messageType, ChatMessageType.generateCode);
      expect(r3.content, 'Hi again');
    });
  });

  group('ChatAction serialization', () {
    test('fromJson maps to enums correctly', () {
      final json = {
        'action': 'apply_curl',
        'target': 'httpRequestModel',
        'field': 'body',
        'path': '/root',
        'value': '--curl command--',
      };

      final action = ChatAction.fromJson(json);
      expect(action.actionType, ChatActionType.applyCurl);
      expect(action.targetType, ChatActionTarget.httpRequestModel);
      expect(action.field, 'body');
      expect(action.path, '/root');
      expect(action.value, '--curl command--');
    });

    test('fromJson with unknown values defaults gracefully', () {
      final action = ChatAction.fromJson({
        'action': 'some_new_action',
        'target': 'weird_target',
      });
      expect(action.actionType, ChatActionType.other); // unknown -> other
      expect(action.targetType, ChatActionTarget.httpRequestModel); // default
      expect(action.field, '');
    });

    test('toJson returns enum string representations', () {
      const action = ChatAction(
        action: 'download_doc',
        target: 'documentation',
        field: 'n/a',
        actionType: ChatActionType.downloadDoc,
        targetType: ChatActionTarget.documentation,
      );
      final json = action.toJson();
      expect(json['action'], 'download_doc');
      expect(json['target'], 'documentation');
      expect(json['action_type'], 'download_doc');
      expect(json['target_type'], 'documentation');
    });
  });

  group('Enum mapping helpers', () {
    test('chatActionTypeToString covers all values', () {
      for (final t in ChatActionType.values) {
        final s = t.text;
        expect(s, isA<String>());
        expect(s.isNotEmpty, true);
      }
    });

    test('chatActionTargetToString covers all values', () {
      for (final t in ChatActionTarget.values) {
        final s = t.name;
        expect(s, isA<String>());
        expect(s.isNotEmpty, true);
      }
    });
  });
}
