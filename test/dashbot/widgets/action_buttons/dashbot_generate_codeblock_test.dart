import 'package:apidash/dashbot/core/common/widgets/dashbot_action_buttons/dashbot_generate_codeblock.dart';
import 'package:apidash/dashbot/core/constants/constants.dart';
import 'package:apidash/dashbot/features/chat/models/chat_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_consts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashbotGeneratedCodeBlock', () {
    testWidgets('shows provided code value', (tester) async {
      const action = ChatAction(
        action: 'other',
        target: 'code',
        value: 'print("hello")',
        actionType: ChatActionType.other,
        targetType: ChatActionTarget.code,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: DashbotGeneratedCodeBlock(action: action),
          ),
        ),
      );

      expect(find.text('print("hello")'), findsOneWidget);
    });

    testWidgets('falls back to placeholder when value missing', (tester) async {
      const action = ChatAction(
        action: 'other',
        target: 'code',
        actionType: ChatActionType.other,
        targetType: ChatActionTarget.code,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: kThemeDataLight,
          home: Scaffold(
            body: DashbotGeneratedCodeBlock(action: action),
          ),
        ),
      );

      expect(find.text('// No code returned'), findsOneWidget);
    });
  });
}
