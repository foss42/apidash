import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../test_consts.dart';
import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const action = ChatAction(
    action: 'add_test',
    target: 'test',
    actionType: ChatActionType.other,
    targetType: ChatActionTarget.test,
  );

  group('DashbotAddTestButton', () {
    testWidgets('renders label and invokes applyAutoFix on press',
        (tester) async {
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
              body: DashbotAddTestButton(action: action),
            ),
          ),
        ),
      );

      expect(find.text('Add Test'), findsOneWidget);
      expect(find.byIcon(Icons.playlist_add_check), findsOneWidget);

      await tester.tap(find.text('Add Test'));
      await tester.pump();

      expect(notifier.applyAutoFixCalls.single, same(action));
    });
  });
}
