import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/error/chat_failure.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('ChatState copyWith & integrity', () {
    test('copyWith updates provided fields only', () {
      final msg = ChatMessage(
        id: '1',
        content: 'Ping',
        role: MessageRole.user,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      );
      const failure = ChatFailure('generic');
      const base = ChatState();
      final next = base.copyWith(
        chatSessions: {
          'r1': [msg]
        },
        isGenerating: true,
        currentStreamingResponse: 'stream',
        currentRequestId: 'r1',
        lastError: failure,
      );
      expect(next.chatSessions['r1']!.single, msg);
      expect(next.isGenerating, true);
      expect(next.currentStreamingResponse, 'stream');
      expect(next.currentRequestId, 'r1');
      expect(next.lastError, failure);
      // Original untouched
      expect(base.chatSessions, isEmpty);
      expect(base.isGenerating, false);

      // Calling copyWith with NO arguments hits fallback (right side of ??)
      final same = next.copyWith();
      expect(same.chatSessions, next.chatSessions);
      expect(same.isGenerating, next.isGenerating);
      expect(same.currentStreamingResponse, next.currentStreamingResponse);
      expect(same.currentRequestId, next.currentRequestId);
      expect(same.lastError, next.lastError);

      // Explicit null parameters should also fall back to existing values
      final viaNulls = next.copyWith(
        chatSessions: null,
        isGenerating: null,
        currentStreamingResponse: null,
        currentRequestId: null,
        lastError: null,
      );
      expect(viaNulls.chatSessions, next.chatSessions);
      expect(viaNulls.isGenerating, next.isGenerating);
      expect(viaNulls.currentStreamingResponse, next.currentStreamingResponse);
      expect(viaNulls.currentRequestId, next.currentRequestId);
      expect(viaNulls.lastError, next.lastError);
    });
  });
}
