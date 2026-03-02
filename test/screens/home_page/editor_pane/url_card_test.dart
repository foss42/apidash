import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/env_trigger_field.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveHandler extends Mock implements HiveHandler {}

class SpyChatViewmodel extends ChatViewmodel {
  SpyChatViewmodel(super.ref);

  final List<({String text, ChatMessageType type, bool countAsUser})>
      sendMessageCalls = [];

  void setState(ChatState s) => state = s;

  @override
  Future<void> sendMessage({
    required String text,
    ChatMessageType type = ChatMessageType.general,
    bool countAsUser = true,
  }) async {
    sendMessageCalls.add((text: text, type: type, countAsUser: countAsUser));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockHiveHandler mockHiveHandler;
  SpyChatViewmodel? spyChatViewmodel;

  setUp(() {
    mockHiveHandler = MockHiveHandler();
    spyChatViewmodel = null;

    when(() => mockHiveHandler.getIds()).thenReturn(['1']);
    when(() => mockHiveHandler.getRequestModel('1')).thenReturn({
      'id': '1',
      'apiType': 'rest',
      'httpRequestModel': {'url': '', 'method': 'get'},
      'isWorking': false,
    });
  });

  Widget buildTestHarness({
    DashbotWindowNotifier? windowNotifier,
  }) {
    return ProviderScope(
      overrides: [
        selectedIdStateProvider.overrideWith((ref) => '1'),
        requestSequenceProvider.overrideWith((ref) => ['1']),
        hasUnsavedChangesProvider.overrideWith((ref) => false),
        chatViewmodelProvider.overrideWith((ref) {
          final spy = SpyChatViewmodel(ref);
          spy.setState(const ChatState());
          spyChatViewmodel = spy;
          return spy;
        }),
        collectionStateNotifierProvider.overrideWith(
          (ref) => CollectionStateNotifier(ref, mockHiveHandler),
        ),
        settingsProvider.overrideWith(
          (ref) => ThemeStateNotifier(
            settingsModel: SettingsModel(isDashBotEnabled: isDashBotEnabled),
          ),
        ),
        if (windowNotifier != null)
          dashbotWindowNotifierProvider.overrideWith((ref) => windowNotifier),
      ],
      child: const MaterialApp(
        home: Portal(
          child: Scaffold(body: URLTextField()),
        ),
      ),
    );
  }

  group('URLTextField curl paste detection', () {
    testWidgets('Typing "curl " one character at a time does NOT trigger DashBot',
        (tester) async {
      await tester.pumpWidget(buildTestHarness());
      await tester.pumpAndSettle();

      final envField = find.byType(EnvironmentTriggerField);
      expect(envField, findsOneWidget);
      final state = tester.state<EnvironmentTriggerFieldState>(envField);

      for (final text in ['c', 'cu', 'cur', 'curl', 'curl ']) {
        state.controller.text = text;
        state.widget.onChanged?.call(text);
        await tester.pump();
      }

      expect(state.controller.text, 'curl ');
      expect(spyChatViewmodel?.sendMessageCalls ?? [], isEmpty);
    });

    testWidgets(
        'Pasting a curl command triggers DashBot in tab mode and clears URL',
        (tester) async {
      final windowNotifier = DashbotWindowNotifier();

      await tester.pumpWidget(buildTestHarness(
        windowNotifier: windowNotifier,
      ));
      await tester.pumpAndSettle();

      final envField = find.byType(EnvironmentTriggerField);
      final state = tester.state<EnvironmentTriggerFieldState>(envField);

      const pasteText = 'curl -X GET https://api.example.com/users';
      state.controller.text = pasteText;
      state.widget.onChanged?.call(pasteText);
      await tester.pumpAndSettle();

      expect(windowNotifier.state.isPopped, isFalse);

      final newField = find.byType(EnvironmentTriggerField);
      expect(newField, findsOneWidget);
      final newState = tester.state<EnvironmentTriggerFieldState>(newField);
      expect(newState.controller.text, isEmpty);

      expect(spyChatViewmodel!.sendMessageCalls, hasLength(1));
      expect(spyChatViewmodel!.sendMessageCalls.first.text, pasteText);
      expect(spyChatViewmodel!.sendMessageCalls.first.type,
          ChatMessageType.importCurl);
    });

    testWidgets('Pasting curl triggers DashBot even when DashBot is disabled',
        (tester) async {
      final windowNotifier = DashbotWindowNotifier();

      await tester.pumpWidget(buildTestHarness(
        isDashBotEnabled: false,
        windowNotifier: windowNotifier,
      ));
      await tester.pumpAndSettle();

      final envField = find.byType(EnvironmentTriggerField);
      final state = tester.state<EnvironmentTriggerFieldState>(envField);

      const pasteText = 'curl https://example.com';
      state.controller.text = pasteText;
      state.widget.onChanged?.call(pasteText);
      await tester.pumpAndSettle();

      expect(windowNotifier.state.isPopped, isFalse);

      final newField = find.byType(EnvironmentTriggerField);
      final newState = tester.state<EnvironmentTriggerFieldState>(newField);
      expect(newState.controller.text, isEmpty);

      expect(spyChatViewmodel!.sendMessageCalls, hasLength(1));
      expect(spyChatViewmodel!.sendMessageCalls.first.text, pasteText);
      expect(spyChatViewmodel!.sendMessageCalls.first.type,
          ChatMessageType.importCurl);
    });

    testWidgets('Normal URL paste is not affected by curl detection',
        (tester) async {
      await tester.pumpWidget(buildTestHarness());
      await tester.pumpAndSettle();

      final envField = find.byType(EnvironmentTriggerField);
      final state = tester.state<EnvironmentTriggerFieldState>(envField);

      const url = 'https://api.example.com/users';
      state.controller.text = url;
      state.widget.onChanged?.call(url);
      await tester.pump();

      expect(state.controller.text, url);
      expect(spyChatViewmodel?.sendMessageCalls ?? [], isEmpty);
    });
  });
}
