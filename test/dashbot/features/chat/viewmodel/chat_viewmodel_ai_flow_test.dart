import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Future<Stream<String?>> streamChat({required AIRequestModel request}) async {
    if (mockError != null) throw mockError!;
    final resp = mockResponse;
    if (resp == null || resp.isEmpty) return const Stream.empty();
    return Stream.value(resp);
  }
}

class _PromptCaptureBuilder extends PromptBuilder {
  final PromptBuilder _inner;
  _PromptCaptureBuilder(this._inner);
  String? lastSystemPrompt;

  @override
  String buildSystemPrompt(RequestModel? req, ChatMessageType type,
      {String? overrideLanguage, List<ChatMessage> history = const []}) {
    final r = _inner.buildSystemPrompt(req, type,
        overrideLanguage: overrideLanguage, history: history);
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
    await testSetUpTempDirForHive();
  });

  // Helper to obtain a default PromptBuilder by reading the real provider in a temp container
  PromptBuilder basePromptBuilder() {
    final temp = ProviderContainer();
    final pb = temp.read(promptBuilderProvider);
    temp.dispose();
    return pb;
  }

  ProviderContainer createTestContainer(
      {String? aiExplanation, String? actionsJson}) {
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

    return createContainer(overrides: [
      chatRepositoryProvider.overrideWithValue(mockRepo),
      settingsProvider.overrideWith(
          (ref) => ThemeStateNotifier(settingsModel: baseSettings)),
      // Force no selected request so chat uses the stable 'global' session key
      selectedRequestModelProvider.overrideWith((ref) => null),
      promptBuilderProvider.overrideWith((ref) => promptCapture),
    ]);
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
          text: 'Generate code', type: ChatMessageType.generateCode);

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
          text: 'Explain', type: ChatMessageType.explainResponse);

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
          text: 'Gen test', type: ChatMessageType.generateTest);
      final msgs = vm.currentMessages;
      expect(msgs, isNotEmpty);
      final sys = msgs.last;
      expect(sys.content, contains('Something'));
    });

    test('handles malformed top-level JSON gracefully (no crash, fallback)',
        () async {
      container = createTestContainer();
      // This will cause MessageJson.safeParse to catch and ignore malformed content
      mockRepo.mockResponse =
          '{"explanation":"ok","actions": [ { invalid json }';
      final vm = container.read(chatViewmodelProvider.notifier);
      await vm.sendMessage(
          text: 'Gen code', type: ChatMessageType.generateCode);
      final msgs = vm.currentMessages;
      expect(msgs.length, equals(2)); // user + system with raw content
      expect(msgs.last.content, contains('explanation'));
    });

    test('handles missing explanation key (still stores raw response)',
        () async {
      container = createTestContainer();
      mockRepo.mockResponse = '{"note":"Just a note","actions": []}';
      final vm = container.read(chatViewmodelProvider.notifier);
      await vm.sendMessage(
          text: 'Explain', type: ChatMessageType.explainResponse);
      final msgs = vm.currentMessages;
      expect(msgs.length, equals(2));
      expect(msgs.last.content, contains('note'));
    });

    test('catches repository exception and appends error system message',
        () async {
      container = createTestContainer();
      mockRepo.mockError = Exception('boom');
      final vm = container.read(chatViewmodelProvider.notifier);
      await vm.sendMessage(text: 'Doc', type: ChatMessageType.generateDoc);
      final msgs = vm.currentMessages;
      expect(msgs, isNotEmpty);
      expect(msgs.last.content, contains('Error:'));
    });
  });
}
