import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import '../../../../providers/helpers.dart';

// Mock ChatRemoteRepository
class MockChatRemoteRepository extends ChatRemoteRepository {
  String? mockResponse;
  Exception? mockError;
  List<String>? mockChunks;

  @override
  Future<String?> sendChat({required AIRequestModel request}) async {
    if (mockError != null) throw mockError!;
    return mockResponse;
  }

  @override
  Future<Stream<String?>> streamChat({required AIRequestModel request}) async {
    if (mockError != null) throw mockError!;

    if (mockChunks != null) {
      // FIX: yield each chunk asynchronously so intermediate state can be
      // observed between awaits in the viewmodel's stream loop.
      return Stream.fromIterable(mockChunks!).asyncMap((chunk) async {
        await Future.delayed(Duration.zero);
        return chunk;
      });
    }

    return Stream.value(mockResponse);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockChatRemoteRepository mockRepo;

  setUp(() async {
    await testSetUpTempDirForHive();
    mockRepo = MockChatRemoteRepository();

    container = createContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(mockRepo),
        selectedRequestModelProvider.overrideWith((ref) => null),
      ],
    );
  });

  group('ChatViewmodel Basic Tests', () {
    test('should initialize with default state', () {
      final state = container.read(chatViewmodelProvider);

      expect(state.chatSessions, isEmpty);
      expect(state.isGenerating, isFalse);
      expect(state.currentStreamingResponse, isEmpty);
      expect(state.currentRequestId, isNull);
      expect(state.lastError, isNull);
    });

    test('should access _repo getter through sendChat error handling',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          mockRepo.mockError = Exception('Network error');

          await viewmodel.sendMessage(
              text: 'Hello', type: ChatMessageType.generateCode);

          expect(viewmodel.currentMessages.length, greaterThanOrEqualTo(1));
        });

    test('should test helper methods like _looksLikeUrl and _looksLikeOpenApi',
            () {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final message = ChatMessage(
            id: 'test-url',
            explanation: 'https://api.apidash.dev/openapi.json',
            role: MessageRole.user,
            timestamp: DateTime.now(),
            actions: [],
          );

          viewmodel.state = viewmodel.state.copyWith(
            chatSessions: {
              'global': [message]
            },
          );

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.explanation, contains('https://'));
        });
  });

  group('ChatViewmodel Helper Methods Coverage', () {
    test('should test generateCode message type with language detection',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
            text: 'function hello() { console.log("hello"); }',
            type: ChatMessageType.generateCode,
          );

          expect(viewmodel.currentMessages, hasLength(2));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.user));
          expect(viewmodel.currentMessages.last.explanation,
              contains('AI model is not configured'));
        });

    test('should test the systemPrompt building for different message types',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
            text: 'Explain this response',
            type: ChatMessageType.explainResponse,
          );

          expect(viewmodel.currentMessages, hasLength(2));
          expect(viewmodel.currentMessages.first.explanation,
              equals('Explain this response'));
        });

    test('should test URL detection helper method', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
        text: '',
        type: ChatMessageType.importOpenApi,
        countAsUser: false,
      );

      expect(viewmodel.currentMessages, hasLength(1));
      expect(viewmodel.currentMessages.first.messageType,
          equals(ChatMessageType.importOpenApi));

      await viewmodel.sendMessage(text: 'https://api.apidash.dev/openapi.yaml');

      expect(viewmodel.currentMessages.length, greaterThan(1));
    });

    test('should test OpenAPI spec detection helper method', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
        text: '',
        type: ChatMessageType.importOpenApi,
        countAsUser: false,
      );

      expect(viewmodel.currentMessages, hasLength(1));

      const yamlSpec = '''
openapi: 3.0.0
info:
  title: Test API
  version: 1.0.0
''';
      await viewmodel.sendMessage(text: yamlSpec);

      expect(viewmodel.currentMessages.length, greaterThan(1));
    });

    test('should test OpenAPI JSON detection', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
        text: '',
        type: ChatMessageType.importOpenApi,
        countAsUser: false,
      );

      const jsonSpec = '''
{
  "openapi": "3.0.0",
  "info": {
    "title": "Test API",
    "version": "1.0.0"
  }
}
''';
      await viewmodel.sendMessage(text: jsonSpec);

      expect(viewmodel.currentMessages.length, greaterThan(1));
    });

    test('should test invalid OpenAPI explanation', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
        text: '',
        type: ChatMessageType.importOpenApi,
        countAsUser: false,
      );

      const invalidexplanation = '''
{
  "notOpenApi": true,
  "someOtherField": "value"
}
''';
      await viewmodel.sendMessage(text: invalidexplanation);

      expect(viewmodel.currentMessages.length, greaterThanOrEqualTo(1));
    });
  });

  group('ChatViewmodel Error Paths and Edge Cases', () {
    test('should handle AI response with no explanation', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      mockRepo.mockResponse = '';

      await viewmodel.sendMessage(
          text: 'Test message', type: ChatMessageType.explainResponse);

      expect(viewmodel.currentMessages, hasLength(2));
      expect(viewmodel.currentMessages.last.explanation,
          contains('AI model is not configured. Please set one.'));
    });

    test('should handle AI response with null explanation', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      mockRepo.mockResponse = null;

      await viewmodel.sendMessage(
          text: 'Test message', type: ChatMessageType.debugError);

      expect(viewmodel.currentMessages, hasLength(2));
      expect(viewmodel.currentMessages.last.explanation,
          contains('AI model is not configured. Please set one.'));
    });

    test('should handle repository error gracefully', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      mockRepo.mockError = Exception('Connection timeout');

      await viewmodel.sendMessage(
          text: 'Test message', type: ChatMessageType.generateDoc);

      expect(viewmodel.currentMessages, hasLength(2));
      expect(viewmodel.currentMessages.last.explanation,
          contains('AI model is not configured. Please set one.'));
    });

    test(
        'should test userPrompt fallback when text is empty and countAsUser is false',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
            text: '',
            type: ChatMessageType.generateTest,
            countAsUser: false,
          );

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.system));
          expect(viewmodel.currentMessages.first.explanation,
              contains('AI model is not configured'));
        });

    test('should test cURL import flow detection without active flow',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(text: 'curl -X GET https://api.apidash.dev');

          expect(viewmodel.currentMessages, hasLength(2));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.user));
          expect(viewmodel.currentMessages.first.explanation,
              equals('curl -X GET https://api.apidash.dev'));
        });
  });

  group('ChatViewmodel Environment Substitution Methods', () {
    test('should test _inferBaseUrl helper method', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final curlAction = ChatAction.fromJson({
        'action': 'apply_curl',
        'target': 'httpRequestModel',
        'field': 'apply_to_new',
        'value': {
          'method': 'GET',
          'url': 'https://api.apidash.dev/users',
          'headers': {},
          'body': '',
        },
      });

      await viewmodel.applyAutoFix(curlAction);
    });

    test('should test _maybeSubstituteBaseUrl helper method', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final curlAction = ChatAction.fromJson({
        'action': 'apply_curl',
        'target': 'httpRequestModel',
        'field': 'apply_to_new',
        'value': {
          'method': 'POST',
          'url': 'https://api.apidash.dev/data',
          'headers': {'Content-Type': 'application/json'},
          'body': '{"test": true}',
        },
      });

      await viewmodel.applyAutoFix(curlAction);
    });

    test('should test _maybeSubstituteBaseUrlForOpenApi helper method',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final openApiAction = ChatAction.fromJson({
            'action': 'apply_openapi',
            'target': 'httpRequestModel',
            'field': 'apply_to_new',
            'value': {
              'method': 'GET',
              'url': 'https://api.apidash.dev/pets',
              'baseUrl': 'https://api.apidash.dev',
              'sourceName': 'Pet Store API',
              'headers': {},
              'body': '',
            },
          });

          await viewmodel.applyAutoFix(openApiAction);
        });

    test('should test _getSubstitutedHttpRequestModel method', () async {
      final mockRequest = RequestModel(
        id: 'test-req-1',
        httpRequestModel: HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://{{baseUrl}}/api/test',
          headers: [NameValueModel(name: 'Authorization', value: '{{token}}')],
        ),
      );

      final testContainer = createContainer(
        overrides: [
          chatRepositoryProvider.overrideWithValue(mockRepo),
          selectedRequestModelProvider.overrideWith((ref) => mockRequest),
        ],
      );

      final viewmodel = testContainer.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
          text: 'Generate code for this request',
          type: ChatMessageType.generateCode);

      expect(viewmodel.currentMessages, hasLength(2));
      expect(viewmodel.currentMessages.first.role, equals(MessageRole.user));

      testContainer.dispose();
    });
  });

  group('ChatViewmodel AI Model Configuration Tests', () {
    test('should test actual AI response processing with valid response',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          mockRepo.mockResponse = '''
{
  "explanation": "Here's the generated code for your request",
  "actions": [
    {
      "action": "other",
      "target": "code",
      "field": "generated",
      "value": "console.log('Hello World');"
    }
  ]
}
''';

          await viewmodel.sendMessage(
              text: 'Generate JavaScript code', type: ChatMessageType.generateCode);

          expect(viewmodel.currentMessages, hasLength(2));
          expect(viewmodel.currentMessages.last.role, equals(MessageRole.system));
          expect(viewmodel.currentMessages.last.explanation,
              contains('AI model is not configured. Please set one.'));
        });

    test('should test AI response with invalid JSON actions', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      mockRepo.mockResponse = '''
{
  "explanation": "Here's the response",
  "actions": "invalid json string"
}
''';

      await viewmodel.sendMessage(
          text: 'Test message', type: ChatMessageType.explainResponse);

      expect(viewmodel.currentMessages, hasLength(2));
      expect(viewmodel.currentMessages.last.role, equals(MessageRole.system));
      expect(viewmodel.currentMessages.last.actions, isEmpty);
    });

    test('should test userPrompt construction with different scenarios',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          mockRepo.mockResponse = 'Response 1';
          await viewmodel.sendMessage(
              text: 'Test request', type: ChatMessageType.debugError);

          expect(viewmodel.currentMessages, hasLength(2));
          expect(viewmodel.currentMessages.first.explanation,
              equals('Test request'));

          viewmodel.clearCurrentChat();
          mockRepo.mockResponse = 'Response 2';
          await viewmodel.sendMessage(
              text: '', type: ChatMessageType.generateDoc, countAsUser: false);

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.system));
        });

    test('should test state management during AI generation', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      mockRepo.mockResponse = 'Delayed response';

      final future = viewmodel.sendMessage(
          text: 'Test generation', type: ChatMessageType.generateTest);

      await future;

      expect(viewmodel.state.isGenerating, isFalse);
      expect(viewmodel.state.currentStreamingResponse, isEmpty);
      expect(viewmodel.currentMessages, hasLength(2));
    });
  });

  group('ChatViewmodel SendMessage Tests', () {
    test(
        'sendMessage should return early if text is empty and countAsUser is true',
            () async {
          mockRepo.mockResponse = 'AI Response';
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(text: '   ', countAsUser: true);

          expect(viewmodel.currentMessages, isEmpty);
        });

    test(
        'sendMessage should show AI model not configured message when no AI model',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(text: 'Hello', type: ChatMessageType.general);

          expect(viewmodel.currentMessages, hasLength(2));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.user));
          expect(viewmodel.currentMessages.last.role, equals(MessageRole.system));
          expect(viewmodel.currentMessages.last.explanation,
              contains('AI model is not configured'));
        });

    test('sendMessage should handle curl import type without AI model',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
            text: 'test',
            type: ChatMessageType.importCurl,
            countAsUser: false,
          );

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.system));
          expect(viewmodel.currentMessages.first.messageType,
              equals(ChatMessageType.importCurl));
          expect(viewmodel.currentMessages.first.explanation, contains('cURL'));
        });

    test('sendMessage should handle OpenAPI import type without AI model',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
            text: 'test',
            type: ChatMessageType.importOpenApi,
            countAsUser: false,
          );

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.system));
          expect(viewmodel.currentMessages.first.messageType,
              equals(ChatMessageType.importOpenApi));
          expect(viewmodel.currentMessages.first.explanation, contains('OpenAPI'));
        });

    test('sendMessage should detect curl paste in import flow', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final curlImportMessage = ChatMessage(
        id: 'curl-import-id',
        explanation: 'curl import prompt',
        role: MessageRole.system,
        timestamp: DateTime.now(),
        messageType: ChatMessageType.importCurl,
        actions: [],
      );

      viewmodel.state = viewmodel.state.copyWith(
        chatSessions: {
          'global': [curlImportMessage]
        },
      );

      await viewmodel.sendMessage(text: 'curl -X GET https://api.apidash.dev');

      expect(viewmodel.currentMessages.length, greaterThan(1));
    });

    test('sendMessage should detect OpenAPI paste in import flow', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final openApiImportMessage = ChatMessage(
        id: 'openapi-import-id',
        explanation: 'openapi import prompt',
        role: MessageRole.system,
        timestamp: DateTime.now(),
        messageType: ChatMessageType.importOpenApi,
        actions: [],
      );

      viewmodel.state = viewmodel.state.copyWith(
        chatSessions: {
          'global': [openApiImportMessage]
        },
      );

      const openApiSpec = '{"openapi": "3.0.0", "info": {"title": "Test API"}}';
      await viewmodel.sendMessage(text: openApiSpec);

      expect(viewmodel.currentMessages.length, greaterThan(1));
    });

    test('sendMessage should detect URL paste in OpenAPI import flow',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final openApiImportMessage = ChatMessage(
            id: 'openapi-import-id',
            explanation: 'openapi import prompt',
            role: MessageRole.system,
            timestamp: DateTime.now(),
            messageType: ChatMessageType.importOpenApi,
            actions: [],
          );

          viewmodel.state = viewmodel.state.copyWith(
            chatSessions: {
              'global': [openApiImportMessage]
            },
          );

          await viewmodel.sendMessage(text: 'https://api.apidash.dev/openapi.json');

          expect(viewmodel.currentMessages.length, greaterThan(1));
        });
  });

  test('sendTaskMessage should add user message and call sendMessage',
          () async {
        final viewmodel = container.read(chatViewmodelProvider.notifier);

        try {
          await viewmodel.sendTaskMessage(ChatMessageType.generateTest);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

  group('ChatViewmodel AutoFix Tests', () {
    test('applyAutoFix should handle unsupported action gracefully', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final action = ChatAction.fromJson({
        'action': 'other',
        'target': 'unsupported_target',
        'field': 'test_field',
        'value': 'test_value',
      });

      await viewmodel.applyAutoFix(action);
    });
  });

  group('ChatViewmodel Attachment Tests', () {
    test('handleOpenApiAttachment should handle invalid data gracefully',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final invalidData = Uint8List.fromList([0xFF, 0xFE, 0xFD]);
          final invalidAttachment = ChatAttachment(
            id: 'test-id',
            name: 'test.json',
            mimeType: 'application/json',
            sizeBytes: invalidData.length,
            data: invalidData,
            createdAt: DateTime.now(),
          );

          await viewmodel.handleOpenApiAttachment(invalidAttachment);

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.system));
          expect(viewmodel.currentMessages.first.explanation,
              contains('Failed to read'));
        });

    test('handleOpenApiAttachment should process valid JSON attachment',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          const validOpenApiSpec =
              '{"openapi": "3.0.0", "info": {"title": "Test API", "version": "1.0.0"}}';
          final validData = Uint8List.fromList(validOpenApiSpec.codeUnits);
          final validAttachment = ChatAttachment(
            id: 'test-id-2',
            name: 'openapi.json',
            mimeType: 'application/json',
            sizeBytes: validData.length,
            data: validData,
            createdAt: DateTime.now(),
          );

          await viewmodel.handleOpenApiAttachment(validAttachment);

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.system));
          expect(viewmodel.currentMessages.first.messageType,
              equals(ChatMessageType.importOpenApi));
        });

    test('handleOpenApiAttachment should handle non-OpenAPI explanation',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          const nonOpenApiexplanation = '{"regular": "json", "not": "openapi"}';
          final validData = Uint8List.fromList(nonOpenApiexplanation.codeUnits);
          final validAttachment = ChatAttachment(
            id: 'test-id-3',
            name: 'regular.json',
            mimeType: 'application/json',
            sizeBytes: validData.length,
            data: validData,
            createdAt: DateTime.now(),
          );

          await viewmodel.handleOpenApiAttachment(validAttachment);

          expect(viewmodel.currentMessages, hasLength(0));
        });
  });

  group('ChatViewmodel Debug Tests', () {
    test('should validate _addMessage behavior', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final message = ChatMessage(
        id: 'test-message-1',
        explanation: 'Test message',
        role: MessageRole.user,
        timestamp: DateTime.now(),
        actions: [],
      );

      viewmodel.state = viewmodel.state.copyWith(
        chatSessions: {
          'global': [message],
        },
      );

      expect(viewmodel.currentMessages, hasLength(1));
      expect(viewmodel.currentMessages.first.explanation,
          equals('Test message'));
    });

    test('should validate sendMessage adds messages', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      expect(viewmodel.state.chatSessions, isEmpty);
      expect(viewmodel.currentMessages, isEmpty);

      await viewmodel.sendMessage(text: 'Hello', type: ChatMessageType.general);

      expect(viewmodel.currentMessages, hasLength(2));
      expect(viewmodel.currentMessages.first.role, equals(MessageRole.user));
      expect(viewmodel.currentMessages.first.explanation, equals('Hello'));
      expect(viewmodel.currentMessages.last.role, equals(MessageRole.system));
      expect(viewmodel.currentMessages.last.explanation,
          contains('AI model is not configured'));

      expect(viewmodel.state.chatSessions.containsKey('global'), isTrue);
      expect(viewmodel.state.chatSessions['global'], isNotNull);
      expect(viewmodel.state.chatSessions['global']!, hasLength(2));
    });

    test('should validate state updates and reading', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      expect(viewmodel.state.chatSessions, isEmpty);
      expect(viewmodel.currentMessages, isEmpty);

      final message1 = ChatMessage(
        id: 'msg-1',
        explanation: 'Message 1',
        role: MessageRole.user,
        timestamp: DateTime.now(),
        actions: [],
      );

      final message2 = ChatMessage(
        id: 'msg-2',
        explanation: 'Message 2',
        role: MessageRole.system,
        timestamp: DateTime.now(),
        actions: [],
      );

      viewmodel.state = viewmodel.state.copyWith(
        chatSessions: {
          'global': [message1, message2],
          'request-123': [message1],
        },
      );

      expect(viewmodel.currentMessages, hasLength(2));
      expect(viewmodel.state.chatSessions['global'], hasLength(2));
      expect(viewmodel.state.chatSessions['request-123'], hasLength(1));
    });
  });

  group('ChatViewmodel Import Flow Tests', () {
    test('sendMessage should handle OpenAPI import with actual spec explanation',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
            text: 'import openapi',
            type: ChatMessageType.importOpenApi,
            countAsUser: false,
          );

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.messageType,
              equals(ChatMessageType.importOpenApi));

          const yamlSpec = '''
openapi: 3.0.0
info:
  title: Test API
  version: 1.0.0
paths:
  /users:
    get:
      summary: Get users
''';
          await viewmodel.sendMessage(text: yamlSpec);

          expect(viewmodel.currentMessages.length, greaterThan(1));
        });

    test('sendMessage should handle URL import in OpenAPI flow', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
        text: 'import openapi',
        type: ChatMessageType.importOpenApi,
        countAsUser: false,
      );

      expect(viewmodel.currentMessages, hasLength(1));

      await viewmodel.sendMessage(
          text: 'https://petstore.swagger.io/v2/swagger.json');

      expect(viewmodel.currentMessages.length, greaterThan(1));
    });

    test('sendMessage should detect curl with complex command', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
        text: 'import curl',
        type: ChatMessageType.importCurl,
        countAsUser: false,
      );

      expect(viewmodel.currentMessages, hasLength(1));

      const complexCurl =
          'curl -X POST https://api.apidash.dev/users -H "Content-Type: application/json" -d \'{"name": "John", "email": "john@example.com"}\'';

      await viewmodel.sendMessage(text: complexCurl);

      expect(viewmodel.currentMessages.length, greaterThan(1));
    });
  });

  group('ChatViewmodel Error Scenarios', () {
    test('sendMessage should handle non-countAsUser messages', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
        text: 'system message',
        type: ChatMessageType.general,
        countAsUser: false,
      );

      expect(viewmodel.currentMessages, hasLength(1));
      expect(viewmodel.currentMessages.first.role, equals(MessageRole.system));
      expect(viewmodel.currentMessages.first.explanation,
          contains('AI model is not configured'));
    });

    test('sendMessage should handle different message types', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final messageTypes = [
        ChatMessageType.explainResponse,
        ChatMessageType.debugError,
        ChatMessageType.generateTest,
        ChatMessageType.generateDoc,
      ];

      for (final type in messageTypes) {
        await viewmodel.sendMessage(
          text: 'test message for $type',
          type: type,
        );
      }

      expect(viewmodel.currentMessages.length,
          equals(messageTypes.length * 2));

      for (int i = 0; i < viewmodel.currentMessages.length; i++) {
        if (i % 2 == 0) {
          expect(
              viewmodel.currentMessages[i].role, equals(MessageRole.user));
        } else {
          expect(
              viewmodel.currentMessages[i].role, equals(MessageRole.system));
          expect(viewmodel.currentMessages[i].explanation,
              contains('AI model is not configured'));
        }
      }
    });

    test('applyAutoFix should handle different action types', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final curlAction = ChatAction.fromJson({
        'action': 'apply_curl',
        'target': 'httpRequestModel',
        'field': 'apply_to_new',
        'value': {
          'method': 'GET',
          'url': 'https://api.apidash.dev',
          'headers': {},
          'body': '',
        },
      });
      await viewmodel.applyAutoFix(curlAction);

      final openApiAction = ChatAction.fromJson({
        'action': 'apply_openapi',
        'target': 'httpRequestModel',
        'field': 'apply_to_new',
        'value': {
          'method': 'POST',
          'url': 'https://api.apidash.dev/users',
          'headers': {'Content-Type': 'application/json'},
          'body': '{"name": "test"}',
        },
      });
      await viewmodel.applyAutoFix(openApiAction);

      final testAction = ChatAction.fromJson({
        'action': 'other',
        'target': 'test',
        'field': 'add_test',
        'value': 'test code here',
      });
      await viewmodel.applyAutoFix(testAction);
    });
  });

  group('ChatViewmodel State Management', () {
    test('should handle multiple chat sessions', () {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final message1 = ChatMessage(
        id: 'msg-1',
        explanation: 'Message for request 1',
        role: MessageRole.user,
        timestamp: DateTime.now(),
        actions: [],
      );

      final message2 = ChatMessage(
        id: 'msg-2',
        explanation: 'Message for request 2',
        role: MessageRole.user,
        timestamp: DateTime.now(),
        actions: [],
      );

      viewmodel.state = viewmodel.state.copyWith(
        chatSessions: {
          'request-1': [message1],
          'request-2': [message2],
          'global': [message1, message2],
        },
      );

      expect(viewmodel.state.chatSessions.keys, hasLength(3));
      expect(viewmodel.state.chatSessions['request-1'], hasLength(1));
      expect(viewmodel.state.chatSessions['request-2'], hasLength(1));
      expect(viewmodel.state.chatSessions['global'], hasLength(2));
    });

    test('should handle state updates correctly', () {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      viewmodel.state = viewmodel.state.copyWith(
        isGenerating: true,
        currentStreamingResponse: 'Generating response...',
        currentRequestId: 'req-123',
      );

      expect(viewmodel.state.isGenerating, isTrue);
      expect(viewmodel.state.currentStreamingResponse,
          equals('Generating response...'));
      expect(viewmodel.state.currentRequestId, equals('req-123'));

      viewmodel.cancel();
      expect(viewmodel.state.isGenerating, isFalse);
    });
  });

  group('cURL and OpenAPI Import Handling Methods', () {
    test('handlePotentialCurlPaste should parse valid cURL command', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      const curlCommand =
          'curl -X POST https://api.apidash.dev/users -H "Content-Type: application/json" -d \'{"name": "test"}\'';

      await viewmodel.handlePotentialCurlPaste(curlCommand);

      expect(viewmodel.currentMessages, hasLength(1));
      expect(viewmodel.currentMessages.first.messageType,
          equals(ChatMessageType.importCurl));
      // explanation field contains human-readable text, not raw JSON
      expect(viewmodel.currentMessages.first.explanation,
          contains('Where do you want to apply the changes?'));
      // actions are typed, not embedded in a JSON string
      expect(viewmodel.currentMessages.first.actions, isNotEmpty);
      expect(viewmodel.currentMessages.first.actions.first.actionType,
          equals(ChatActionType.applyCurl));
    });

    test('handlePotentialCurlPaste should handle invalid cURL command',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          const invalidCurl = 'curl invalid command with unbalanced "quotes';

          await viewmodel.handlePotentialCurlPaste(invalidCurl);

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.last.explanation,
              contains('couldn\'t parse that cURL command'));
          expect(viewmodel.currentMessages.last.messageType,
              equals(ChatMessageType.importCurl));
        });

    test('handlePotentialCurlPaste should ignore non-cURL text', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      const nonCurlText = 'This is just regular text, not a cURL command';

      await viewmodel.handlePotentialCurlPaste(nonCurlText);

      expect(viewmodel.currentMessages, isEmpty);
    });

    test('handlePotentialOpenApiPaste should parse valid OpenAPI spec',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          const openApiSpec = '''
{
  "openapi": "3.0.0",
  "info": {
    "title": "Test API",
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "https://api.test.com"
    }
  ],
  "paths": {
    "/users": {
      "get": {
        "summary": "Get users",
        "responses": {
          "200": {
            "description": "Success"
          }
        }
      }
    }
  }
}
''';

          await viewmodel.handlePotentialOpenApiPaste(openApiSpec);

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.messageType,
              equals(ChatMessageType.importOpenApi));
          expect(viewmodel.currentMessages.first.explanation,
              contains('OpenAPI parsed'));
        });

    test('handlePotentialOpenApiPaste should handle invalid OpenAPI spec',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          const invalidSpec = '{"invalid": "not an openapi spec"}';

          await viewmodel.handlePotentialOpenApiPaste(invalidSpec);

          expect(viewmodel.currentMessages, isEmpty);
        });

    test('handlePotentialOpenApiUrl should handle URL import', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      const openApiUrl = 'https://petstore.swagger.io/v2/swagger.json';

      await viewmodel.handlePotentialOpenApiUrl(openApiUrl);

      expect(viewmodel.currentMessages, hasLength(1));
      expect(viewmodel.currentMessages.first.messageType,
          equals(ChatMessageType.importOpenApi));
    });

    test('handlePotentialOpenApiUrl should handle non-URL text', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      const nonUrl = 'not a url at all';

      await viewmodel.handlePotentialOpenApiUrl(nonUrl);

      expect(viewmodel.currentMessages, isEmpty);
    });
  });

  group('Apply Actions Methods (Lines 829+)', () {
    test(
        '_applyTestToPostScript should handle null requestId gracefully in _applyOtherAction',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final testAction = ChatAction(
            action: 'add_test',
            target: 'test',
            field: 'generated',
            actionType: ChatActionType.other,
            targetType: ChatActionTarget.test,
            value: 'pm.test("Test", function () {});',
          );

          await viewmodel.applyAutoFix(testAction);

          expect(viewmodel.currentMessages, isEmpty);
        });

    test('_applyTestToPostScript routing should work when target is test',
            () async {
          final mockRequest = RequestModel(
            id: 'test-request-456',
            httpRequestModel: HttpRequestModel(
              method: HTTPVerb.post,
              url: 'https://api.apidash.dev/users',
            ),
            postRequestScript: 'console.log("Existing script");',
          );

          final testContainer = createContainer(
            overrides: [
              chatRepositoryProvider.overrideWith((ref) => mockRepo),
              selectedRequestModelProvider.overrideWith((ref) => mockRequest),
            ],
          );

          final viewmodel = testContainer.read(chatViewmodelProvider.notifier);

          final testAction = ChatAction(
            action: 'add_test',
            target: 'test',
            field: 'generated',
            actionType: ChatActionType.other,
            targetType: ChatActionTarget.test,
            value:
            'pm.test("Status code is 200", function () {\n    pm.response.to.have.status(200);\n});',
          );

          await viewmodel.applyAutoFix(testAction);

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.role, equals(MessageRole.system));
          expect(viewmodel.currentMessages.first.explanation,
              contains('Failed to apply auto-fix'));

          testContainer.dispose();
        });

    test('_applyOtherAction should handle unsupported targets gracefully',
            () async {
          final mockRequest = RequestModel(
            id: 'test-request-789',
            httpRequestModel: HttpRequestModel(
              method: HTTPVerb.get,
              url: 'https://api.apidash.dev/test',
            ),
          );

          final testContainer = createContainer(
            overrides: [
              chatRepositoryProvider.overrideWith((ref) => mockRepo),
              selectedRequestModelProvider.overrideWith((ref) => mockRequest),
            ],
          );

          final viewmodel = testContainer.read(chatViewmodelProvider.notifier);

          final testAction = ChatAction(
            action: 'unknown_action',
            target: 'unsupported_target',
            field: 'some_field',
            actionType: ChatActionType.other,
            targetType: ChatActionTarget.test,
            value: 'some value',
          );

          await viewmodel.applyAutoFix(testAction);

          expect(viewmodel.currentMessages, isEmpty);

          testContainer.dispose();
        });

    test('_applyCurl should process cURL action and update collection',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final curlAction = ChatAction(
            action: 'apply_curl',
            target: 'httpRequestModel',
            field: 'apply_to_new',
            actionType: ChatActionType.applyCurl,
            targetType: ChatActionTarget.httpRequestModel,
            value: {
              'method': 'post',
              'url': 'https://api.apidash.dev/users',
              'headers': [
                {'name': 'Content-Type', 'value': 'application/json; charset=utf-8'}
              ],
              'body': '{"name": "John"}',
            },
          );

          await viewmodel.applyAutoFix(curlAction);

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.explanation,
              contains('Created a new request from the cURL'));
        });

    test('_applyCurl should handle form data in cURL action', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final curlActionWithForm = ChatAction(
        action: 'curl',
        target: 'new',
        field: 'request',
        actionType: ChatActionType.applyCurl,
        targetType: ChatActionTarget.httpRequestModel,
        value: {
          'method': 'post',
          'uri': 'https://api.apidash.dev/upload',
          'formData': [
            {'name': 'file', 'value': 'test.txt', 'type': 'text'},
            {'name': 'description', 'value': 'Test file', 'type': 'text'},
          ],
        },
      );

      await viewmodel.applyAutoFix(curlActionWithForm);

      expect(viewmodel.currentMessages, isEmpty);
    });

    test('_applyOpenApi should process OpenAPI action', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final openApiAction = ChatAction(
        action: 'openapi',
        target: 'new',
        field: 'request',
        actionType: ChatActionType.applyOpenApi,
        targetType: ChatActionTarget.httpRequestModel,
        value: {
          'method': 'GET',
          'url': 'https://api.apidash.dev/users',
          'operationId': 'getUsers',
          'summary': 'Get all users',
        },
      );

      await viewmodel.applyAutoFix(openApiAction);

      expect(viewmodel.currentMessages, isEmpty);
    });

    test('_applyOpenApi should handle OpenAPI action with parameters',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final openApiActionWithParams = ChatAction(
            action: 'openapi',
            target: 'new',
            field: 'request',
            actionType: ChatActionType.applyOpenApi,
            targetType: ChatActionTarget.httpRequestModel,
            value: {
              'method': 'GET',
              'url': 'https://api.apidash.dev/users/{id}',
              'operationId': 'getUserById',
              'parameters': [
                {'name': 'id', 'in': 'path', 'required': true, 'type': 'integer'},
                {
                  'name': 'format',
                  'in': 'query',
                  'required': false,
                  'type': 'string'
                },
              ],
            },
          );

          await viewmodel.applyAutoFix(openApiActionWithParams);

          expect(viewmodel.currentMessages, isEmpty);
        });

    test('_applyRequest should handle request modification actions', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final requestAction = ChatAction(
        action: 'request',
        target: 'current',
        field: 'url',
        actionType: ChatActionType.updateUrl,
        targetType: ChatActionTarget.httpRequestModel,
        value: 'https://api.updated.com/endpoint',
      );

      await viewmodel.applyAutoFix(requestAction);

      expect(viewmodel.currentMessages, isEmpty);
    });

    test('applyAutoFix should handle unknown action types gracefully',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final unknownAction = ChatAction(
            action: 'unknown',
            target: 'current',
            field: 'test',
            actionType: ChatActionType.other,
            targetType: ChatActionTarget.httpRequestModel,
            value: 'test value',
          );

          await viewmodel.applyAutoFix(unknownAction);

          expect(viewmodel.currentMessages, isEmpty);
        });
  });

  group('Complex Multi-Provider Interaction Scenarios', () {
    test('should interact with collection provider when applying cURL',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final curlAction = ChatAction(
            action: 'curl',
            target: 'new',
            field: 'request',
            actionType: ChatActionType.applyCurl,
            targetType: ChatActionTarget.httpRequestModel,
            value: {
              'method': 'get',
              'uri': 'https://api.apidash.dev/test',
            },
          );

          await viewmodel.applyAutoFix(curlAction);

          expect(viewmodel.currentMessages, isEmpty);
        });

    test('should use environment providers for URL substitution', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
        text: 'Test message with URL https://{{BASE_URL}}/api/users',
        type: ChatMessageType.general,
      );

      expect(viewmodel.currentMessages, hasLength(2));
    });

    test('should interact with settings provider for AI model', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      await viewmodel.sendMessage(
          text: 'Test message', type: ChatMessageType.general);

      expect(viewmodel.currentMessages, hasLength(2));
      expect(viewmodel.currentMessages.last.explanation,
          contains('AI model is not configured'));
    });

    test('should coordinate with dashbot route provider during imports',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
            text: 'curl -X GET https://api.apidash.dev/test',
            type: ChatMessageType.importCurl,
          );

          expect(viewmodel.currentMessages, hasLength(2));
        });

    test('should integrate with prompt builder for message generation',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
            text: 'Generate documentation for this API',
            type: ChatMessageType.generateDoc,
          );

          expect(viewmodel.currentMessages, hasLength(2));
          expect(viewmodel.currentMessages.first.explanation,
              equals('Generate documentation for this API'));
        });

    test('should handle autofix service integration', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      final action = ChatAction(
        action: 'autofix',
        target: 'current',
        field: 'headers',
        actionType: ChatActionType.updateHeader,
        targetType: ChatActionTarget.httpRequestModel,
        value: {'Authorization': 'Bearer token'},
      );

      await viewmodel.applyAutoFix(action);

      expect(viewmodel.currentMessages, isEmpty);
    });

    test('should manage environment state during substitution operations',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
            text: 'Test with environment variables {{API_KEY}} and {{BASE_URL}}',
            type: ChatMessageType.general,
          );

          expect(viewmodel.currentMessages, hasLength(2));
        });

    test('should coordinate multiple providers during OpenAPI import',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          const openApiSpec = '''
{
  "openapi": "3.0.0",
  "info": {"title": "Test", "version": "1.0.0"},
  "servers": [{"url": "{{BASE_URL}}"}],
  "paths": {"/test": {"get": {"responses": {"200": {"description": "OK"}}}}}
}
''';

          await viewmodel.handlePotentialOpenApiPaste(openApiSpec);

          expect(viewmodel.currentMessages, hasLength(1));
          expect(viewmodel.currentMessages.first.messageType,
              equals(ChatMessageType.importOpenApi));
        });

    test('should handle provider errors gracefully in complex scenarios',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          final complexAction = ChatAction(
            action: 'curl',
            target: 'current',
            field: 'request',
            actionType: ChatActionType.applyCurl,
            targetType: ChatActionTarget.httpRequestModel,
            value: {
              'method': 'INVALID_METHOD',
              'uri': '',
            },
          );

          await viewmodel.applyAutoFix(complexAction);

          expect(viewmodel.currentMessages, isNotEmpty);
        });

    test('should maintain state consistency across provider interactions',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          await viewmodel.sendMessage(
              text: 'First message', type: ChatMessageType.general);
          await viewmodel.sendMessage(
              text: 'Second message', type: ChatMessageType.debugError);

          final action = ChatAction(
            action: 'request',
            target: 'current',
            field: 'method',
            actionType: ChatActionType.updateMethod,
            targetType: ChatActionTarget.httpRequestModel,
            value: 'POST',
          );

          await viewmodel.applyAutoFix(action);

          expect(viewmodel.currentMessages, hasLength(4));
        });
  });

  group('Streaming Tests', () {
    test(
        'should extract explanation progressively from partial chunks',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          const mockAI = AIRequestModel(
            model: 'gemini-1.5-flash',
            apiKey: 'dummy',
          );

          // Chunks split so explanation spans multiple deliveries
          mockRepo.mockChunks = [
            '{"explanation": "The',
            ' quick brown fox',
            '", "actions": []}',
          ];

          container.read(settingsProvider.notifier).state = container
              .read(settingsProvider)
              .copyWith(defaultAIModel: mockAI.toJson());

          // Collect every intermediate streaming value via listener
          final streamedValues = <String>[];
          container.listen(chatViewmodelProvider, (_, next) {
            if (next.currentStreamingResponse.isNotEmpty) {
              streamedValues.add(next.currentStreamingResponse);
            }
          });

          // Run to completion — asyncMap in mock ensures chunks are interleaved
          await viewmodel.sendMessage(text: 'Hello');

          // At least one intermediate state must have contained the explanation
          expect(
            streamedValues,
            anyElement(contains('The quick brown fox')),
            reason: 'currentStreamingResponse should have shown progressive text',
          );

          // Final stored message must have the clean explanation
          expect(
            viewmodel.currentMessages.last.explanation,
            equals('The quick brown fox'),
          );

          // Streaming buffer must be cleared after completion
          expect(
            container.read(chatViewmodelProvider).currentStreamingResponse,
            isEmpty,
          );
        });

    test('should only parse actions once the stream is closed', () async {
      final viewmodel = container.read(chatViewmodelProvider.notifier);

      container.read(settingsProvider.notifier).state = container
          .read(settingsProvider)
          .copyWith(defaultAIModel: {'model': 'gpt-4'});

      // Actions arrive in the second chunk — must not be parsed mid-stream
      mockRepo.mockChunks = [
        '{"explanation": "Creating request...", ',
        '"actions": [{"action": "apply_curl", "target": "httpRequestModel", "field": "apply_to_new", "value": {}}]}',
      ];

      await viewmodel.sendMessage(text: 'Import this');

      final lastMsg = viewmodel.currentMessages.last;

      expect(lastMsg.explanation, equals('Creating request...'));
      expect(lastMsg.actions, isNotEmpty);
      expect(
        lastMsg.actions.first.actionType,
        equals(ChatActionType.applyCurl),
      );
    });

    test('should clear currentStreamingResponse after stream completes',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          container.read(settingsProvider.notifier).state = container
              .read(settingsProvider)
              .copyWith(defaultAIModel: {'model': 'gpt-4'});

          mockRepo.mockChunks = [
            '{"explanation": "Done.", "actions": []}',
          ];

          await viewmodel.sendMessage(text: 'Hello');

          expect(
            container.read(chatViewmodelProvider).currentStreamingResponse,
            isEmpty,
          );
          expect(viewmodel.state.isGenerating, isFalse);
        });

    test('should fall back to raw response when JSON has no explanation key',
            () async {
          final viewmodel = container.read(chatViewmodelProvider.notifier);

          container.read(settingsProvider.notifier).state = container
              .read(settingsProvider)
              .copyWith(defaultAIModel: {'model': 'gpt-4'});

          // Plain text response — no JSON structure
          mockRepo.mockChunks = ['Just a plain text response'];

          await viewmodel.sendMessage(text: 'Hello');

          expect(
            viewmodel.currentMessages.last.explanation,
            equals('Just a plain text response'),
          );
        });
  });
}