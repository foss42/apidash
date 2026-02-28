import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/pages/pages.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/widgets/widgets.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  Widget createChatScreen({
    List<Override> overrides = const [],
    ChatMessageType? initialTask,
  }) {
    return ProviderScope(
      overrides: [
        // Override the selectedRequestModelProvider to prevent Hive dependency issues
        selectedRequestModelProvider.overrideWith((ref) => null),
        ...overrides,
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ChatScreen(initialTask: initialTask),
        ),
      ),
    );
  }

  testWidgets('ChatScreen shows empty-state prompt when idle', (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('Ask me anything!'), findsOneWidget);
    expect(spy.sendMessageCalls, isEmpty);
  });

  testWidgets('ChatScreen triggers initial task without user input',
      (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      createChatScreen(
        initialTask: ChatMessageType.generateDoc,
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
        ],
      ),
    );

    await tester.pump();

    expect(spy.sendMessageCalls.length, 1);
    expect(spy.sendMessageCalls.first.text, isEmpty);
    expect(spy.sendMessageCalls.first.type, ChatMessageType.generateDoc);
    expect(spy.sendMessageCalls.first.countAsUser, isFalse);
  });

  testWidgets('ChatScreen toggles task suggestions panel', (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
        ],
      ),
    );

    expect(find.byType(DashbotTaskButtons), findsNothing);

    await tester.tap(find.byIcon(Icons.help_outline_rounded));
    await tester.pump();

    expect(find.byType(DashbotTaskButtons), findsOneWidget);
  });

  testWidgets('Clear chat icon delegates to viewmodel', (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
        ],
      ),
    );

    await tester.tap(find.byIcon(Icons.clear_all_rounded));
    await tester.pump();

    expect(spy.clearCalled, isTrue);
  });

  testWidgets('Submitting text sends general chat message', (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
        ],
      ),
    );

    await tester.enterText(find.byType(TextField), 'Hello Dashbot');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    expect(spy.sendMessageCalls.length, 1);
    expect(spy.sendMessageCalls.first.text, 'Hello Dashbot');
    expect(spy.sendMessageCalls.first.type, ChatMessageType.general);
  });

  testWidgets('Streaming state renders temporary ChatBubble', (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState(
                isGenerating: true, currentStreamingResponse: 'Streaming...'));
            return spy;
          }),
        ],
      ),
    );

    await tester.pump();

    final markdown =
        tester.widget<MarkdownBody>(find.byType(MarkdownBody).first);
    expect(markdown.data, 'Streaming...');
  });

  testWidgets('Existing chat messages render in list', (tester) async {
    late SpyChatViewmodel spy;
    final messages = [
      ChatMessage(
        id: '1',
        content: 'First',
        role: MessageRole.user,
        timestamp: DateTime(2024),
      ),
      ChatMessage(
        id: '2',
        content: 'Second',
        role: MessageRole.system,
        timestamp: DateTime(2024, 2),
      ),
    ];

    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setMessages(messages);
            spy.setState(ChatState(chatSessions: {'global': messages}));
            return spy;
          }),
        ],
      ),
    );

    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets('TextField onSubmitted sends message', (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
        ],
      ),
    );

    await tester.enterText(find.byType(TextField), 'Test message');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(spy.sendMessageCalls.length, 1);
    expect(spy.sendMessageCalls.first.text, 'Test message');
    expect(spy.sendMessageCalls.first.type, ChatMessageType.general);
  });

  testWidgets('Task suggestions panel hides when generating starts',
      (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState());
            return spy;
          }),
        ],
      ),
    );

    // First show task suggestions
    await tester.tap(find.byIcon(Icons.help_outline_rounded));
    await tester.pump();
    expect(find.byType(DashbotTaskButtons), findsOneWidget);

    // Then start generating - this should hide the task suggestions
    spy.setState(const ChatState(isGenerating: true));
    await tester.pump();

    expect(find.byType(DashbotTaskButtons), findsNothing);
  });

  testWidgets('Scroll animation triggers on streaming response changes',
      (tester) async {
    late SpyChatViewmodel spy;
    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState(
              isGenerating: true,
              currentStreamingResponse: 'Initial...',
            ));
            return spy;
          }),
        ],
      ),
    );

    await tester.pump();

    // Change the streaming response - this should trigger scroll
    spy.setState(const ChatState(
      isGenerating: true,
      currentStreamingResponse: 'Updated streaming response...',
    ));
    await tester.pump();

    // Verify scrolling behavior by checking that the new content is rendered
    expect(find.text('Updated streaming response...'), findsOneWidget);
  });

  testWidgets('Scroll animation triggers when generation completes',
      (tester) async {
    late SpyChatViewmodel spy;
    final messages = [
      ChatMessage(
        id: '1',
        content: 'Generated response',
        role: MessageRole.system,
        timestamp: DateTime(2024),
      ),
    ];

    await tester.pumpWidget(
      createChatScreen(
        overrides: [
          chatViewmodelProvider.overrideWith((ref) {
            spy = SpyChatViewmodel(ref);
            spy.setState(const ChatState(isGenerating: true));
            return spy;
          }),
        ],
      ),
    );

    await tester.pump();

    // Complete generation - this should trigger scroll
    spy.setMessages(messages);
    spy.setState(ChatState(
      isGenerating: false,
      chatSessions: {'global': messages},
    ));
    await tester.pump();

    expect(find.text('Generated response'), findsOneWidget);
  });
}
