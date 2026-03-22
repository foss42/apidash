import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_state.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/dashbot/providers/dashbot_window_notifier.dart';
import 'package:apidash/dashbot/widgets/dashbot_task_buttons.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../pages/test_utils.dart';
import 'action_buttons/test_utils.dart';

void main() {
  testWidgets('DashbotTaskButtons quick actions dispatch expected commands',
      (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
          dashbotWindowNotifierProvider
              .overrideWith((ref) => RecordingDashbotWindowNotifier()),
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
        child: const MaterialApp(
          home: Scaffold(body: DashbotTaskButtons()),
        ),
      ),
    );

    const sequence = {
      '🔎 Explain me this response': ChatMessageType.explainResponse,
      '🐞 Help me debug this error': ChatMessageType.debugError,
      '📄 Generate documentation': ChatMessageType.generateDoc,
      '📝 Generate Tests': ChatMessageType.generateTest,
      '🧩 Generate Code': ChatMessageType.generateCode,
      '📥 Import cURL': ChatMessageType.importCurl,
      '📄 Import OpenAPI': ChatMessageType.importOpenApi,
    };

    for (final entry in sequence.entries) {
      spy.sendMessageCalls.clear();
      await tester.tap(find.text(entry.key));
      await tester.pump();

      expect(spy.sendMessageCalls.length, 1,
          reason: 'Expected a call for ${entry.key}');
      expect(spy.sendMessageCalls.single.type, entry.value);
      expect(spy.sendMessageCalls.single.countAsUser, isFalse);
    }
  });

  testWidgets('DashbotTaskButtons generate tool toggles window visibility',
      (tester) async {
    late SpyChatViewmodel spy;
    final windowNotifier = RecordingDashbotWindowNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
          dashbotWindowNotifierProvider.overrideWith((ref) => windowNotifier),
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
        child: const MaterialApp(
          home: Scaffold(body: DashbotTaskButtons()),
        ),
      ),
    );

    await tester.tap(find.text('🛠️ Generate Tool'));
    await tester.pumpAndSettle();

    expect(windowNotifier.hideCalls, 1);
    expect(windowNotifier.showCalls, 1);
    expect(spy.sendMessageCalls, isEmpty);
  });

  testWidgets('DashbotTaskButtons generate UI opens dialog and restores window',
      (tester) async {
    late SpyChatViewmodel spy;
    final windowNotifier = RecordingDashbotWindowNotifier();
    final requestModel = RequestModel(
      id: 'req-2',
      httpRequestModel: const HttpRequestModel(),
      httpResponseModel: const HttpResponseModel(body: 'response body'),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
          dashbotWindowNotifierProvider.overrideWith((ref) => windowNotifier),
          selectedRequestModelProvider.overrideWith((ref) => requestModel),
        ],
        child: const MaterialApp(
          home: Scaffold(body: DashbotTaskButtons()),
        ),
      ),
    );

    await tester.tap(find.text('📱 Generate UI'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);

    final dialogElement = find.byType(Dialog);
    if (dialogElement.evaluate().isNotEmpty) {
      Navigator.of(dialogElement.evaluate().first).pop();
      await tester.pumpAndSettle();
    }

    expect(windowNotifier.hideCalls, 1);
    expect(windowNotifier.showCalls, 1);
    expect(spy.sendMessageCalls, isEmpty);
  });
}
