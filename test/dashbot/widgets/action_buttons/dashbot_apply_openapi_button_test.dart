import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_action.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/dashbot/widgets/dashbot_action_buttons/dashbot_apply_openapi_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_consts.dart';
import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashbotApplyOpenApiButton', () {
    testWidgets('defaults to Apply label and invokes auto fix', (tester) async {
      const action = ChatAction(
        action: 'apply_openapi',
        target: 'httpRequestModel',
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
              body: DashbotApplyOpenApiButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('Apply'), findsOneWidget);

      await tester.tap(find.text('Apply'));
      await tester.pump();

      expect(notifier.applyAutoFixCalls.single, same(action));
    });

    testWidgets('shows Create New Request label when requested',
        (tester) async {
      const action = ChatAction(
        action: 'apply_openapi',
        target: 'httpRequestModel',
        field: 'apply_to_new',
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
              body: DashbotApplyOpenApiButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('Create New Request'), findsOneWidget);
    });

    testWidgets('shows Apply to Selected label when field=apply_to_selected',
        (tester) async {
      const action = ChatAction(
        action: 'apply_openapi',
        target: 'httpRequestModel',
        field: 'apply_to_selected',
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
              body: DashbotApplyOpenApiButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('Apply to Selected'), findsOneWidget);
    });
  });
}
