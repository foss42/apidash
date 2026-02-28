import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_action.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/dashbot/widgets/dashbot_action_buttons/dashbot_apply_curl_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../test_consts.dart';
import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashbotApplyCurlButton', () {
    testWidgets('uses default Apply label and triggers auto-fix',
        (tester) async {
      const action = ChatAction(
        action: 'apply_curl',
        target: 'httpRequestModel',
        actionType: ChatActionType.applyCurl,
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
              body: DashbotApplyCurlButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('Apply'), findsOneWidget);

      await tester.tap(find.text('Apply'));
      await tester.pump();

      expect(notifier.applyAutoFixCalls, hasLength(1));
      expect(notifier.applyAutoFixCalls.single, same(action));
    });

    testWidgets('shows Create New Request when field=apply_to_new',
        (tester) async {
      const action = ChatAction(
        action: 'apply_curl',
        target: 'httpRequestModel',
        field: 'apply_to_new',
        actionType: ChatActionType.applyCurl,
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
              body: DashbotApplyCurlButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('Create New Request'), findsOneWidget);
    });

    testWidgets('uses path text when selecting operation', (tester) async {
      const action = ChatAction(
        action: 'apply_curl',
        target: 'httpRequestModel',
        field: 'select_operation',
        path: '/users',
        actionType: ChatActionType.applyCurl,
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
              body: DashbotApplyCurlButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('/users'), findsOneWidget);
    });
  });
}
