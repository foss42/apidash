import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_action.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/dashbot/widgets/dashbot_action_buttons/dashbot_apply_workflow_button.dart';
import 'package:apidash/workflow/providers/workflow_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../test_consts.dart';
import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const action = ChatAction(
    action: 'apply_workflow',
    target: 'workflow',
    actionType: ChatActionType.applyWorkflow,
    targetType: ChatActionTarget.workflow,
    value: {
      'name': 'Login Flow',
      'nodes': [
        {'id': 'start'},
        {'id': 'n1'},
      ],
    },
  );

  testWidgets('shows only Create New when no workflow selected',
      (tester) async {
    late TestChatViewmodel notifier;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            notifier = TestChatViewmodel(ref);
            return notifier;
          }),
          selectedWorkflowIdStateProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: DashbotApplyWorkflowButton(action: action),
          ),
        ),
      ),
    );

    expect(find.text('Create New'), findsOneWidget);
    expect(find.text('Change Current'), findsNothing);

    await tester.tap(find.text('Create New'));
    await tester.pump();

    expect(notifier.applyAutoFixCalls, hasLength(1));
    expect(notifier.applyAutoFixCalls.single.field, 'apply_to_new');
  });

  testWidgets('shows Change Current and Create New when workflow selected',
      (tester) async {
    late TestChatViewmodel notifier;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            notifier = TestChatViewmodel(ref);
            return notifier;
          }),
          selectedWorkflowIdStateProvider.overrideWith((ref) => 'My Flow'),
        ],
        child: MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: DashbotApplyWorkflowButton(action: action),
          ),
        ),
      ),
    );

    expect(find.text('Change Current'), findsOneWidget);
    expect(find.text('Create New'), findsOneWidget);

    await tester.tap(find.text('Change Current'));
    await tester.pump();

    expect(notifier.applyAutoFixCalls, hasLength(1));
    expect(notifier.applyAutoFixCalls.single.field, 'apply_to_selected');
  });
}
