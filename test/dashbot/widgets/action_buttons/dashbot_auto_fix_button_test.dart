import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_action.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/dashbot/widgets/dashbot_action_buttons/dashbot_auto_fix_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_consts.dart';
import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const action = ChatAction(
    action: 'update_field',
    target: 'httpRequestModel',
    field: 'url',
    value: 'https://api.apidash.dev/users',
    actionType: ChatActionType.updateField,
    targetType: ChatActionTarget.httpRequestModel,
  );

  group('DashbotAutoFixButton', () {
    testWidgets('renders icon, label and triggers auto-fix', (tester) async {
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
              body: DashbotAutoFixButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('Auto Fix'), findsOneWidget);
      expect(find.byIcon(Icons.auto_fix_high), findsOneWidget);

      await tester.tap(find.text('Auto Fix'));
      await tester.pump();

      expect(notifier.applyAutoFixCalls, hasLength(1));
      expect(notifier.applyAutoFixCalls.single, same(action));
    });
  });
}
