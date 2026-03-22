import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_action.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/dashbot/widgets/dashbot_action_buttons/dashbot_generate_language_picker_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_consts.dart';
import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashbotGenerateLanguagePicker', () {
    testWidgets('renders provided language options and sends message on tap',
        (tester) async {
      const action = ChatAction(
        action: 'show_languages',
        target: 'codegen',
        value: ['Python (requests)', 'cURL'],
        actionType: ChatActionType.showLanguages,
        targetType: ChatActionTarget.codegen,
      );

      late TestChatViewmodel notifier;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatViewmodelProvider.overrideWith((ref) {
              notifier = TestChatViewmodel(ref);
              return notifier;
            }),
          ],
          child: MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: DashbotGenerateLanguagePicker(action: action),
            ),
          ),
        ),
      );

      expect(find.text('Python (requests)'), findsOneWidget);
      expect(find.text('cURL'), findsOneWidget);

      await tester.tap(find.text('Python (requests)'));
      await tester.pump();

      expect(notifier.sendMessageCalls, hasLength(1));
      final call = notifier.sendMessageCalls.single;
      expect(call.text, 'Please generate code in Python (requests)');
      expect(call.type, ChatMessageType.generateCode);
      expect(call.countAsUser, isTrue);
    });

    testWidgets('falls back to default language list', (tester) async {
      const action = ChatAction(
        action: 'show_languages',
        target: 'codegen',
        value: 'unexpected',
        actionType: ChatActionType.showLanguages,
        targetType: ChatActionTarget.codegen,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatViewmodelProvider.overrideWith((ref) => TestChatViewmodel(ref)),
          ],
          child: MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: DashbotGenerateLanguagePicker(action: action),
            ),
          ),
        ),
      );

      expect(find.text('JavaScript (fetch)'), findsOneWidget);
      expect(find.text('Python (requests)'), findsOneWidget);
      expect(find.text('Dart (http)'), findsOneWidget);
      expect(find.text('Go (net/http)'), findsOneWidget);
      expect(find.text('cURL'), findsOneWidget);
    });
  });
}
