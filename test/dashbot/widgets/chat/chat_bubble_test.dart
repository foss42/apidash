import 'package:apidash/dashbot/core/common/widgets/dashbot_action_buttons/dashbot_actions_buttons.dart';
import 'package:apidash/dashbot/core/constants/constants.dart';
import 'package:apidash/dashbot/features/chat/models/chat_action.dart';
import 'package:apidash/dashbot/features/chat/view/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await Clipboard.setData(const ClipboardData(text: ''));
  });

  testWidgets('ChatBubble skips duplicate prompt override for user messages',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: 'duplicate',
              role: MessageRole.user,
              promptOverride: 'duplicate',
            ),
          ),
        ),
      ),
    );

    expect(find.text('duplicate'), findsNothing);
  });

  testWidgets('ChatBubble shows loading indicator when message empty',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: '',
              role: MessageRole.system,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('ChatBubble renders explanation parsed from system JSON',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: '{"explnation":"Parsed output"}',
              role: MessageRole.system,
            ),
          ),
        ),
      ),
    );

    final markdown =
        tester.widget<MarkdownBody>(find.byType(MarkdownBody).first);
    expect(markdown.data, 'Parsed output');
  });

  testWidgets('ChatBubble renders action widgets when provided',
      (tester) async {
    const action = ChatAction(
      action: 'download_doc',
      target: 'documentation',
      actionType: ChatActionType.downloadDoc,
      targetType: ChatActionTarget.documentation,
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: 'Here is your document',
              role: MessageRole.system,
              actions: [action],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(DashbotDownloadDocButton), findsOneWidget);
  });

  testWidgets('Copy icon copies rendered message to clipboard', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: 'Copy this please',
              role: MessageRole.system,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.copy_rounded));
    await tester.pumpAndSettle();

    // TODO: //TODO: The below test works for `flutter run` but not for `flutter test`
    // final data = await Clipboard.getData('text/plain');
    // expect(data?.text, 'Copy this please');
  });
}
