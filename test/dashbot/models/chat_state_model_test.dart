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
          'r1': [msg],
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

    test(
      'lastError handling: setting, preserving, and clearing via clearLastError',
      () {
        const failure = ChatFailure('generic error', code: '400');
        const base = ChatState();

        // 1. Setting lastError
        final stateWithError = base.copyWith(lastError: failure);
        expect(stateWithError.lastError, failure);

        // 2. Preserving lastError when clearLastError is false or omitted
        final preserved = stateWithError.copyWith(isGenerating: true);
        expect(preserved.lastError, failure);
        expect(preserved.isGenerating, true);

        final preservedWithExplicitFalse = stateWithError.copyWith(
          clearLastError: false,
        );
        expect(preservedWithExplicitFalse.lastError, failure);

        // 3. Setting a new lastError
        const newFailure = ChatFailure('new error', code: '500');
        final updatedError = stateWithError.copyWith(lastError: newFailure);
        expect(updatedError.lastError, newFailure);

        // 4. Clearing lastError when clearLastError is true
        final cleared = stateWithError.copyWith(clearLastError: true);
        expect(cleared.lastError, isNull);

        // 5. When clearLastError is true, it overrides lastError argument
        final clearedExplicit = stateWithError.copyWith(
          lastError: newFailure,
          clearLastError: true,
        );
        expect(clearedExplicit.lastError, isNull);
      },
    );
  });
}
