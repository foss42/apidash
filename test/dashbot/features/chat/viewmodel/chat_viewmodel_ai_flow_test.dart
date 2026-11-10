import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apidash/dashbot/error/chat_failure.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/models/models.dart' show ChatMessage;
import 'package:apidash/dashbot/repository/repository.dart';
import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/dashbot/services/agent/prompt_builder.dart';
import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/collection_providers.dart';
import '../../../../providers/helpers.dart';

/// AI-enabled flow tests for ChatViewmodel.
///
/// This file contains tests specifically for AI-enabled chat functionality,
// A mock ChatRemoteRepository returning configurable responses
class MockChatRemoteRepository extends ChatRemoteRepository {
  String? mockResponse;
  Exception? mockError;

  @override
  Future<String?> sendChat({required AIRequestModel request}) async {
    if (mockError != null) throw mockError!;
    return mockResponse;
  }
}

class _PromptCaptureBuilder extends PromptBuilder {
  final PromptBuilder _inner;
  _PromptCaptureBuilder(this._inner);
  String? lastSystemPrompt;

  @override
  String buildSystemPrompt(
    RequestModel? req,
    ChatMessageType type, {
    String? overrideLanguage,
    List<ChatMessage> history = const [],
  }) {
    final r = _inner.buildSystemPrompt(
      req,
      type,
      overrideLanguage: overrideLanguage,
      history: history,
    );
    lastSystemPrompt = r;
    return r;
  }

  @override
  String? detectLanguage(String text) => _inner.detectLanguage(text);

  @override
  String getUserMessageForTask(ChatMessageType type) =>
      _inner.getUserMessageForTask(type);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late MockChatRemoteRepository mockRepo;
  late _PromptCaptureBuilder promptCapture;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await testSetUpTempDirForHive();
  });

  // Helper to obtain a default PromptBuilder by reading the real provider in a temp container
  PromptBuilder basePromptBuilder() {
    final temp = ProviderContainer();
    final pb = temp.read(promptBuilderProvider);
    temp.dispose();
    return pb;
  }

  ProviderContainer createTestContainer({
    String? aiExplanation,
    String? actionsJson,
  }) {
    mockRepo = MockChatRemoteRepository();
    if (aiExplanation != null) {
      // Build a response optionally with actions
      final actionsPart = actionsJson ?? '[]';
      mockRepo.mockResponse =
          '{"explanation":"$aiExplanation","actions":$actionsPart}';
    }

    // Proper AI model JSON matching AIRequestModel.fromJson keys
    final aiModelJson = {
      'modelApiProvider': 'openai',
      'model': 'gpt-test',
      'apiKey': 'sk-test',
      'system_prompt': '',
      'user_prompt': '',
      'model_configs': [],
      'stream': false,
    };

    final baseSettings = SettingsModel(defaultAIModel: aiModelJson);
    promptCapture = _PromptCaptureBuilder(basePromptBuilder());

    return createContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(mockRepo),
        settingsProvider.overrideWith(
          (ref) => ThemeStateNotifier(settingsModel: baseSettings),
        ),
        // Force no selected request so chat uses the stable 'global' session key
        selectedRequestModelProvider.overrideWith((ref) => null),
        promptBuilderProvider.overrideWith((ref) => promptCapture),
      ],
    );
  }

  group('ChatViewmodel AI Enabled Flow', () {
    test('processes valid AI explanation + actions list', () async {
      container = createTestContainer(
        aiExplanation: 'Here is your code',
        actionsJson:
            '[{"action":"other","target":"code","field":"generated","value":"print(\\"hi\\")"}]',
      );
      final vm = container.read(chatViewmodelProvider.notifier);

      await vm.sendMessage(
        text: 'Generate code',
        type: ChatMessageType.generateCode,
      );

      final msgs = vm.currentMessages;
      // Expect exactly 2 messages: user + system response
      expect(msgs.length, equals(2));
      final user = msgs.first;
      final system = msgs.last;
      expect(user.role, MessageRole.user);
      expect(system.role, MessageRole.system);
      expect(system.actions, isNotNull);
      expect(system.actions!.length, equals(1));
      expect(system.content, contains('Here is your code'));
      expect(promptCapture.lastSystemPrompt, isNotNull);
      expect(promptCapture.lastSystemPrompt, contains('Generate'));
    });

    test('handles empty AI response (adds fallback message)', () async {
      container = createTestContainer();
      mockRepo.mockResponse = ''; // Explicit empty
      final vm = container.read(chatViewmodelProvider.notifier);

      await vm.sendMessage(
        text: 'Explain',
        type: ChatMessageType.explainResponse,
      );

      final msgs = vm.currentMessages;
      expect(msgs, isNotEmpty);
      expect(msgs.last.content, contains('No response'));
    });

    test('handles null AI response (adds fallback message)', () async {
      container = createTestContainer();
      mockRepo.mockResponse = null; // Explicit null
      final vm = container.read(chatViewmodelProvider.notifier);
      await vm.sendMessage(text: 'Debug', type: ChatMessageType.debugError);
      final msgs = vm.currentMessages;
      expect(msgs, isNotEmpty);
      expect(msgs.last.content, contains('No response'));
    });

    test('handles malformed actions field gracefully', () async {
      container = createTestContainer();
      mockRepo.mockResponse =
          '{"explanation":"Something","actions":"not-a-list"}';
      final vm = container.read(chatViewmodelProvider.notifier);
      await vm.sendMessage(
        text: 'Gen test',
        type: ChatMessageType.generateTest,
      );
      final msgs = vm.currentMessages;
      expect(msgs, isNotEmpty);
      final sys = msgs.last;
      expect(sys.content, contains('Something'));
    });

    test(
      'handles malformed top-level JSON gracefully (no crash, fallback)',
      () async {
        container = createTestContainer();
        // This will cause MessageJson.safeParse to catch and ignore malformed content
        mockRepo.mockResponse =
            '{"explanation":"ok","actions": [ { invalid json }';
        final vm = container.read(chatViewmodelProvider.notifier);
        await vm.sendMessage(
          text: 'Gen code',
          type: ChatMessageType.generateCode,
        );
        final msgs = vm.currentMessages;
        expect(msgs.length, equals(2)); // user + system with raw content
        expect(msgs.last.content, contains('explanation'));
      },
    );

    test(
      'handles missing explanation key (still stores raw response)',
      () async {
        container = createTestContainer();
        mockRepo.mockResponse = '{"note":"Just a note","actions": []}';
        final vm = container.read(chatViewmodelProvider.notifier);
        await vm.sendMessage(
          text: 'Explain',
          type: ChatMessageType.explainResponse,
        );
        final msgs = vm.currentMessages;
        expect(msgs.length, equals(2));
        expect(msgs.last.content, contains('note'));
      },
    );

    test(
      'catches repository exception and appends error system message',
      () async {
        container = createTestContainer();
        mockRepo.mockError = Exception('boom');
        final vm = container.read(chatViewmodelProvider.notifier);
        await vm.sendMessage(text: 'Doc', type: ChatMessageType.generateDoc);
        final msgs = vm.currentMessages;
        expect(msgs, isNotEmpty);
        expect(msgs.last.content, contains('Error:'));
        expect(msgs.last.content, contains('unexpected error occurred'));
        expect(msgs.last.content, isNot(contains('Exception: boom')));
        expect(vm.state.lastError, isNotNull);
      },
    );

    group('Error handling and lastError lifecycle', () {
      test(
        'catches ChatFailure with 401 and sets lastError with authentication message',
        () async {
          container = createTestContainer();
          mockRepo.mockError = const ChatFailure(
            'Invalid API key provided',
            code: '401',
          );
          final vm = container.read(chatViewmodelProvider.notifier);

          await vm.sendMessage(text: 'Hello');

          expect(vm.state.lastError, isNotNull);
          expect(vm.state.lastError!.code, '401');
          expect(vm.state.lastError!.message, 'Invalid API key provided');
          expect(vm.state.isGenerating, isFalse);

          final lastMessage = vm.currentMessages.last.content;
          expect(lastMessage, contains('Authentication failed'));
          expect(lastMessage, isNot(contains('ChatFailure')));
          expect(lastMessage, isNot(contains('Invalid API key provided')));
        },
      );

      test(
        'catches ChatFailure with 403 and sets lastError with authentication message',
        () async {
          container = createTestContainer();
          mockRepo.mockError = const ChatFailure(
            'Forbidden permission',
            code: '403',
          );
          final vm = container.read(chatViewmodelProvider.notifier);

          await vm.sendMessage(text: 'Hello');

          expect(vm.state.lastError?.code, '403');
          final lastMessage = vm.currentMessages.last.content;
          expect(lastMessage, contains('Authentication failed'));
          expect(lastMessage, isNot(contains('ChatFailure')));
        },
      );

      test(
        'catches ChatFailure with 429 and sets lastError with rate limit message',
        () async {
          container = createTestContainer();
          mockRepo.mockError = const ChatFailure(
            'Rate limit exceeded',
            code: '429',
          );
          final vm = container.read(chatViewmodelProvider.notifier);

          await vm.sendMessage(text: 'Hello');

          expect(vm.state.lastError?.code, '429');
          final lastMessage = vm.currentMessages.last.content;
          expect(lastMessage, contains('Rate limit reached'));
          expect(lastMessage, isNot(contains('ChatFailure')));
          expect(lastMessage, isNot(contains('Rate limit exceeded')));
        },
      );

      test(
        'catches ChatFailure with 500/502/503/504 and sets lastError with unavailable message',
        () async {
          container = createTestContainer();
          final vm = container.read(chatViewmodelProvider.notifier);

          for (final code in ['500', '502', '503', '504']) {
            mockRepo.mockError = ChatFailure(
              'Server error for $code',
              code: code,
            );
            await vm.sendMessage(text: 'Test $code');
            expect(vm.state.lastError?.code, code);
            final lastMessage = vm.currentMessages.last.content;
            expect(lastMessage, contains('temporarily unavailable'));
            expect(lastMessage, isNot(contains('ChatFailure')));
            expect(lastMessage, isNot(contains('Server error')));
          }
        },
      );

      test(
        'catches ChatFailure with no status code (transport error) and sets network message',
        () async {
          container = createTestContainer();
          mockRepo.mockError = const ChatFailure(
            'Failed to connect to AI provider',
            code: null,
          );
          final vm = container.read(chatViewmodelProvider.notifier);

          await vm.sendMessage(text: 'Hello');

          expect(vm.state.lastError?.code, isNull);
          final lastMessage = vm.currentMessages.last.content;
          expect(lastMessage, contains('Network or connection problem'));
          expect(lastMessage, isNot(contains('ChatFailure')));
          expect(lastMessage, isNot(contains('Failed to connect')));
        },
      );

      test(
        'catches other status code errors and formats safe generic message',
        () async {
          container = createTestContainer();
          mockRepo.mockError = const ChatFailure(
            'Bad Request 400',
            code: '400',
          );
          final vm = container.read(chatViewmodelProvider.notifier);

          await vm.sendMessage(text: 'Hello');

          expect(vm.state.lastError?.code, '400');
          final lastMessage = vm.currentMessages.last.content;
          expect(lastMessage, contains('unexpected error occurred'));
          expect(lastMessage, isNot(contains('ChatFailure')));
          expect(lastMessage, isNot(contains('Bad Request 400')));
        },
      );

      test(
        'clears previous lastError when a new message send begins',
        () async {
          container = createTestContainer();
          mockRepo.mockError = const ChatFailure('Initial failure', code: '429');
          final vm = container.read(chatViewmodelProvider.notifier);

          await vm.sendMessage(text: 'Fail first');
          expect(vm.state.lastError, isNotNull);

          // Now succeed on the next send
          mockRepo.mockError = null;
          mockRepo.mockResponse = '{"explanation":"All good","actions":[]}';

          await vm.sendMessage(text: 'Try again');
          expect(vm.state.lastError, isNull);
        },
      );

      test(
        'clears previous lastError when sending a message even if AI model is not configured',
        () async {
          container = createTestContainer();
          mockRepo.mockError = const ChatFailure('Initial failure', code: '429');
          final vm = container.read(chatViewmodelProvider.notifier);

          await vm.sendMessage(text: 'Fail first');
          expect(vm.state.lastError, isNotNull);

          // Now unset AI model in settings
          container.read(settingsProvider.notifier).state =
              const SettingsModel();

          // Sending a message should clear lastError even though it exits early due to no AI model
          await vm.sendMessage(text: 'Send with no model');
          expect(vm.state.lastError, isNull);
          expect(
            vm.currentMessages.last.content,
            contains('AI model is not configured'),
          );
        },
      );

      test(
        'clears lastError and messages when clearCurrentChat is called',
        () async {
          container = createTestContainer();
          mockRepo.mockError = const ChatFailure('Auth error', code: '401');
          final vm = container.read(chatViewmodelProvider.notifier);

          await vm.sendMessage(text: 'Fail message');
          expect(vm.state.lastError, isNotNull);
          expect(vm.currentMessages, isNotEmpty);

          vm.clearCurrentChat();

          expect(vm.state.lastError, isNull);
          expect(vm.currentMessages, isEmpty);
        },
      );
    });
  });
}
