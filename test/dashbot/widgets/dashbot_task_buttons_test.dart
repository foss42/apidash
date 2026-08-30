import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_state.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/dashbot/providers/dashbot_window_notifier.dart';
import 'package:apidash/dashbot/widgets/dashbot_task_buttons.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../pages/test_utils.dart';
import 'action_buttons/test_utils.dart';

void main() {
  testWidgets('DashbotTaskButtons quick actions dispatch expected commands', (
    tester,
  ) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
          dashbotWindowNotifierProvider.overrideWith(
            (ref) => RecordingDashbotWindowNotifier(),
          ),
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
        child: const MaterialApp(home: Scaffold(body: DashbotTaskButtons())),
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

      expect(
        spy.sendMessageCalls.length,
        1,
        reason: 'Expected a call for ${entry.key}',
      );
      expect(spy.sendMessageCalls.single.type, entry.value);
      expect(spy.sendMessageCalls.single.countAsUser, isFalse);
    }
  });

  testWidgets('DashbotTaskButtons generate tool toggles window visibility', (
    tester,
  ) async {
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
        child: const MaterialApp(home: Scaffold(body: DashbotTaskButtons())),
      ),
    );

    await tester.tap(find.text('🛠️ Generate Tool'));
    await tester.pumpAndSettle();

    expect(windowNotifier.hideCalls, 1);
    expect(windowNotifier.showCalls, 1);
    expect(spy.sendMessageCalls, isEmpty);
  });

  testWidgets(
    'DashbotTaskButtons generate UI opens dialog and restores window',
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
          child: const MaterialApp(home: Scaffold(body: DashbotTaskButtons())),
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
    },
  );

  group('DashbotTaskButtons WebSocket task set', () {
    final wsRequest = RequestModel(
      id: 'ws-1',
      apiType: APIType.websocket,
      wsRequestModel: const WebSocketRequestModel(
        url: 'wss://api.apidash.dev/ws/echo',
      ),
    );

    // Label -> dispatched task type, verified against
    // lib/dashbot/widgets/dashbot_task_buttons.dart.
    const wsSequence = {
      '🔌 Explain this connection': ChatMessageType.explainWsConnection,
      '🛠️ Help me fix my connection': ChatMessageType.debugWsConnection,
      '📡 What is the server sending?': ChatMessageType.summarizeWsMessages,
      '🔍 Find in messages': ChatMessageType.findInWsMessages,
      '✉️ Explain my message': ChatMessageType.explainWsMessage,
      '❓ Why did my message fail?': ChatMessageType.debugWsMessage,
      '❤️ Connection health': ChatMessageType.wsConnectionHealth,
      '📄 Generate documentation': ChatMessageType.generateWsDoc,
      '📝 Generate Tests': ChatMessageType.generateWsTest,
      '🧩 Generate Code': ChatMessageType.generateWsCode,
    };

    Future<SpyChatViewmodel> pumpWithModel(
      WidgetTester tester,
      RequestModel? model,
    ) async {
      late SpyChatViewmodel spy;
      tester.view.physicalSize = const Size(1400, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatViewmodelProvider.overrideWith((ref) {
              spy = SpyChatViewmodel(ref);
              spy.setState(const ChatState());
              return spy;
            }),
            dashbotWindowNotifierProvider.overrideWith(
              (ref) => RecordingDashbotWindowNotifier(),
            ),
            selectedRequestModelProvider.overrideWith((ref) => model),
          ],
          child: const MaterialApp(home: Scaffold(body: DashbotTaskButtons())),
        ),
      );
      await tester.pumpAndSettle();
      return spy;
    }

    testWidgets('WS request shows all WS tasks and hides HTTP-only ones', (
      tester,
    ) async {
      await pumpWithModel(tester, wsRequest);

      for (final label in wsSequence.keys) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      // Shared tasks stay available.
      expect(find.text('📥 Import cURL'), findsOneWidget);
      expect(find.text('📄 Import OpenAPI'), findsOneWidget);
      expect(find.text('🛠️ Generate Tool'), findsOneWidget);
      // HTTP-only tasks are hidden for WS.
      expect(find.text('🔎 Explain me this response'), findsNothing);
      expect(find.text('🐞 Help me debug this error'), findsNothing);
      expect(find.text('📱 Generate UI'), findsNothing);
    });

    testWidgets('WS task buttons dispatch the matching task types', (
      tester,
    ) async {
      final spy = await pumpWithModel(tester, wsRequest);

      for (final entry in wsSequence.entries) {
        spy.sendMessageCalls.clear();
        await tester.tap(find.text(entry.key));
        await tester.pump();

        expect(
          spy.sendMessageCalls.length,
          1,
          reason: 'Expected a call for ${entry.key}',
        );
        expect(spy.sendMessageCalls.single.type, entry.value);
        expect(spy.sendMessageCalls.single.countAsUser, isFalse);
      }
    });

    testWidgets('REST request keeps the HTTP task set, no WS labels', (
      tester,
    ) async {
      final restRequest = RequestModel(
        id: 'rest-1',
        httpRequestModel: const HttpRequestModel(),
      );
      await pumpWithModel(tester, restRequest);

      expect(find.text('🔎 Explain me this response'), findsOneWidget);
      expect(find.text('🐞 Help me debug this error'), findsOneWidget);
      expect(find.text('📄 Generate documentation'), findsOneWidget);
      expect(find.text('📝 Generate Tests'), findsOneWidget);
      expect(find.text('🧩 Generate Code'), findsOneWidget);
      expect(find.text('📱 Generate UI'), findsOneWidget);
      for (final label in [
        '🔌 Explain this connection',
        '🛠️ Help me fix my connection',
        '📡 What is the server sending?',
        '🔍 Find in messages',
        '✉️ Explain my message',
        '❓ Why did my message fail?',
        '❤️ Connection health',
      ]) {
        expect(find.text(label), findsNothing, reason: label);
      }
    });
  });
}
