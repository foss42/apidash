import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_action.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/dashbot/widgets/dashbot_action_buttons/dashbot_select_operation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_consts.dart';
import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashbotSelectOperationButton', () {
    testWidgets('renders operation label and applies auto fix', (tester) async {
      const action = ChatAction(
        action: 'select_operation',
        target: 'httpRequestModel',
        field: 'select_operation',
        path: 'GET /users',
        actionType: ChatActionType.applyOpenApi,
        targetType: ChatActionTarget.httpRequestModel,
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
              body: DashbotSelectOperationButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('GET /users'), findsOneWidget);

      await tester.tap(find.text('GET /users'));
      await tester.pump();

      expect(notifier.applyAutoFixCalls.single, same(action));
    });

    testWidgets('falls back to Unknown label when path missing',
        (tester) async {
      const action = ChatAction(
        action: 'select_operation',
        target: 'httpRequestModel',
        field: 'select_operation',
        actionType: ChatActionType.applyOpenApi,
        targetType: ChatActionTarget.httpRequestModel,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatViewmodelProvider.overrideWith((ref) => TestChatViewmodel(ref)),
          ],
          child: MaterialApp(
            theme: kThemeDataLight,
            home: Scaffold(
              body: DashbotSelectOperationButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('Unknown'), findsOneWidget);
    });
  });
}
