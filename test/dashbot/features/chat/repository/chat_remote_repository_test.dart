import 'dart:convert';
import 'dart:io' as io;

import 'package:apidash/dashbot/error/chat_failure.dart';
import 'package:apidash/dashbot/repository/repository.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockAIRequestModel extends Mock implements AIRequestModel {}

void main() {
  group('ChatRemoteRepositoryImpl unit tests', () {
    late AIRequestModel dummyRequest;

    setUp(() {
      dummyRequest = AIRequestModel(
        url: 'https://example.com/chat',
        userPrompt: 'test prompt',
      );
    });

    group('constructor', () {
      test('creates instance successfully with default executor', () {
        final repo = ChatRemoteRepositoryImpl();
        expect(repo, isA<ChatRemoteRepository>());
        expect(repo, isA<ChatRemoteRepositoryImpl>());
      });

      test('creates instance successfully with custom executor', () {
        final repo = ChatRemoteRepositoryImpl(
          executeRequest: (_) async => 'custom',
        );
        expect(repo, isA<ChatRemoteRepository>());
      });
    });

    group('sendChat response handling', () {
      test('returns non-empty response string on success', () async {
        final repo = ChatRemoteRepositoryImpl(
          executeRequest: (_) async => 'Hello from AI',
        );

        final result = await repo.sendChat(request: dummyRequest);
        expect(result, 'Hello from AI');
      });

      test('returns null when executeRequest returns null', () async {
        final repo = ChatRemoteRepositoryImpl(
          executeRequest: (_) async => null,
        );

        final result = await repo.sendChat(request: dummyRequest);
        expect(result, isNull);
      });

      test('returns null when executeRequest returns empty string', () async {
        final repo = ChatRemoteRepositoryImpl(
          executeRequest: (_) async => '',
        );

        final result = await repo.sendChat(request: dummyRequest);
        expect(result, isNull);
      });
    });

    group('GenAIException translation into ChatFailure', () {
      test(
        'translates GenAIException with HTTP status code into ChatFailure',
        () async {
          final repo = ChatRemoteRepositoryImpl(
            executeRequest: (_) async => throw const GenAIException(
              'Invalid API key provided',
              statusCode: 401,
            ),
          );

          expect(
            () => repo.sendChat(request: dummyRequest),
            throwsA(
              isA<ChatFailure>()
                  .having((f) => f.message, 'message', 'Invalid API key provided')
                  .having((f) => f.code, 'code', '401'),
            ),
          );
        },
      );

      test(
        'translates GenAIException for rate limiting into ChatFailure with 429 code',
        () async {
          final repo = ChatRemoteRepositoryImpl(
            executeRequest: (_) async => throw const GenAIException(
              'Rate limit exceeded',
              statusCode: 429,
            ),
          );

          expect(
            () => repo.sendChat(request: dummyRequest),
            throwsA(
              isA<ChatFailure>()
                  .having((f) => f.message, 'message', 'Rate limit exceeded')
                  .having((f) => f.code, 'code', '429'),
            ),
          );
        },
      );

      test(
        'translates GenAIException for server errors into ChatFailure with 500 code',
        () async {
          final repo = ChatRemoteRepositoryImpl(
            executeRequest: (_) async => throw const GenAIException(
              'Provider internal error',
              statusCode: 500,
            ),
          );

          expect(
            () => repo.sendChat(request: dummyRequest),
            throwsA(
              isA<ChatFailure>()
                  .having((f) => f.message, 'message', 'Provider internal error')
                  .having((f) => f.code, 'code', '500'),
            ),
          );
        },
      );

      test(
        'translates transport error (no status code) into ChatFailure with null code',
        () async {
          final repo = ChatRemoteRepositoryImpl(
            executeRequest: (_) async => throw const GenAIException(
              'Failed to connect to AI provider',
              statusCode: null,
            ),
          );

          expect(
            () => repo.sendChat(request: dummyRequest),
            throwsA(
              isA<ChatFailure>()
                  .having(
                    (f) => f.message,
                    'message',
                    'Failed to connect to AI provider',
                  )
                  .having((f) => f.code, 'code', isNull),
            ),
          );
        },
      );

      test(
        'translates invalid configuration error into ChatFailure',
        () async {
          final repo = ChatRemoteRepositoryImpl(
            executeRequest: (_) async => throw const GenAIException(
              'Invalid AI request configuration: unable to build HTTP request',
            ),
          );

          expect(
            () => repo.sendChat(request: dummyRequest),
            throwsA(
              isA<ChatFailure>()
                  .having(
                    (f) => f.message,
                    'message',
                    'Invalid AI request configuration: unable to build HTTP request',
                  )
                  .having((f) => f.code, 'code', isNull),
            ),
          );
        },
      );

      test(
        'does not expose raw details or sensitive provider credentials in ChatFailure',
        () async {
          final repo = ChatRemoteRepositoryImpl(
            executeRequest: (_) async => throw const GenAIException(
              'Authentication failed',
              statusCode: 401,
              details: '{"raw_secret": "sk-sensitive-key-12345"}',
            ),
          );

          expect(
            () => repo.sendChat(request: dummyRequest),
            throwsA(
              isA<ChatFailure>()
                  .having((f) => f.message, 'message', 'Authentication failed')
                  .having((f) => f.code, 'code', '401'),
            ),
          );
        },
      );
    });

    group('unrelated exceptions propagation', () {
      test('does not catch FormatException and lets it propagate', () async {
        final repo = ChatRemoteRepositoryImpl(
          executeRequest: (_) async =>
              throw const FormatException('Corrupt format'),
        );

        expect(
          () => repo.sendChat(request: dummyRequest),
          throwsA(isA<FormatException>()),
        );
      });

      test('does not catch StateError and lets it propagate', () async {
        final repo = ChatRemoteRepositoryImpl(
          executeRequest: (_) async => throw StateError('Illegal state'),
        );

        expect(
          () => repo.sendChat(request: dummyRequest),
          throwsA(isA<StateError>()),
        );
      });
    });
  });

  group('ChatRemoteRepositoryImpl loopback integration tests', () {
    late io.HttpServer server;
    late String serverUrl;

    setUpAll(() async {
      server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
      serverUrl = 'http://${server.address.host}:${server.port}';

      server.listen((io.HttpRequest req) async {
        final path = req.uri.path;
        if (path.contains('success')) {
          req.response
            ..statusCode = io.HttpStatus.ok
            ..headers.contentType = io.ContentType.json
            ..write(
              jsonEncode({
                "candidates": [
                  {
                    "content": {
                      "parts": [
                        {"text": "mock response"},
                      ],
                    },
                  },
                ],
              }),
            )
            ..close();
        } else if (path.contains('empty_text')) {
          req.response
            ..statusCode = io.HttpStatus.ok
            ..headers.contentType = io.ContentType.json
            ..write(
              jsonEncode({
                "candidates": [
                  {
                    "content": {
                      "parts": [
                        {"text": ""},
                      ],
                    },
                  },
                ],
              }),
            )
            ..close();
        } else if (path.contains('error_401')) {
          req.response
            ..statusCode = io.HttpStatus.unauthorized
            ..headers.contentType = io.ContentType.json
            ..write(
              jsonEncode({
                "error": {"message": "Invalid API key provided"},
              }),
            )
            ..close();
        } else if (path.contains('error_429')) {
          req.response
            ..statusCode = io.HttpStatus.tooManyRequests
            ..headers.contentType = io.ContentType.json
            ..write(
              jsonEncode({
                "error": {"message": "Rate limit exceeded"},
              }),
            )
            ..close();
        } else {
          req.response
            ..statusCode = io.HttpStatus.internalServerError
            ..headers.contentType = io.ContentType.json
            ..write(
              jsonEncode({
                "error": {"message": "Internal server error"},
              }),
            )
            ..close();
        }
      });
    });

    tearDownAll(() async {
      await server.close(force: true);
    });

    test('returns response when server responds 200 OK', () async {
      final repo = ChatRemoteRepositoryImpl();
      final request = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        model: 'gemini-2.0-flash',
        url: '$serverUrl/success',
        userPrompt: 'Hello',
        systemPrompt: 'System',
        apiKey: 'fake_key',
      );

      final result = await repo.sendChat(request: request);
      expect(result, 'mock response');
    });

    test('returns null when server responds 200 OK with empty content', () async {
      final repo = ChatRemoteRepositoryImpl();
      final request = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        model: 'gemini-2.0-flash',
        url: '$serverUrl/empty_text',
        userPrompt: 'Hello',
        systemPrompt: 'System',
        apiKey: 'fake_key',
      );

      final result = await repo.sendChat(request: request);
      expect(result, isNull);
    });

    test('translates 401 response into ChatFailure with code 401', () async {
      final repo = ChatRemoteRepositoryImpl();
      final request = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        model: 'gemini-2.0-flash',
        url: '$serverUrl/error_401',
        userPrompt: 'Hello',
        systemPrompt: 'System',
        apiKey: 'fake_key',
      );

      expect(
        () => repo.sendChat(request: request),
        throwsA(
          isA<ChatFailure>()
              .having((f) => f.code, 'code', '401')
              .having(
                (f) => f.message,
                'message',
                contains('Invalid API key provided'),
              ),
        ),
      );
    });

    test('translates 429 response into ChatFailure with code 429', () async {
      final repo = ChatRemoteRepositoryImpl();
      final request = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        model: 'gemini-2.0-flash',
        url: '$serverUrl/error_429',
        userPrompt: 'Hello',
        systemPrompt: 'System',
        apiKey: 'fake_key',
      );

      expect(
        () => repo.sendChat(request: request),
        throwsA(
          isA<ChatFailure>()
              .having((f) => f.code, 'code', '429')
              .having(
                (f) => f.message,
                'message',
                contains('Rate limit exceeded'),
              ),
        ),
      );
    });

    test(
      'translates transport error on unreachable port into ChatFailure with null code',
      () async {
        final repo = ChatRemoteRepositoryImpl();
        // Bind ephemeral server and close it immediately to guarantee an unreachable port
        final deadServer =
            await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
        final deadPort = deadServer.port;
        await deadServer.close(force: true);

        final request = AIRequestModel(
          modelApiProvider: ModelAPIProvider.gemini,
          model: 'gemini-2.0-flash',
          url: 'http://127.0.0.1:$deadPort/chat',
          userPrompt: 'Hello',
          systemPrompt: 'System',
          apiKey: 'fake_key',
        );

        expect(
          () => repo.sendChat(request: request),
          throwsA(
            isA<ChatFailure>().having((f) => f.code, 'code', isNull),
          ),
        );
      },
    );

    test(
      'translates invalid AI request config into ChatFailure with null code',
      () async {
        final repo = ChatRemoteRepositoryImpl();
        final request = AIRequestModel(
          url: '',
          userPrompt: 'test prompt',
        );

        expect(
          () => repo.sendChat(request: request),
          throwsA(
            isA<ChatFailure>()
                .having(
                  (f) => f.message,
                  'message',
                  contains('Invalid AI request configuration'),
                )
                .having((f) => f.code, 'code', isNull),
          ),
        );
      },
    );
  });

  group('chatRepositoryProvider', () {
    test('provides ChatRemoteRepositoryImpl instance', () {
      final container = ProviderContainer();
      final repository = container.read(chatRepositoryProvider);

      expect(repository, isA<ChatRemoteRepositoryImpl>());
      expect(repository, isA<ChatRemoteRepository>());

      container.dispose();
    });

    test('provider returns same instance on multiple reads', () {
      final container = ProviderContainer();
      final repository1 = container.read(chatRepositoryProvider);
      final repository2 = container.read(chatRepositoryProvider);

      expect(identical(repository1, repository2), isTrue);

      container.dispose();
    });

    test('provider can be overridden for testing', () {
      final mockRepository = MockChatRemoteRepository();
      final container = ProviderContainer(
        overrides: [
          chatRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
      );

      final repository = container.read(chatRepositoryProvider);
      expect(repository, same(mockRepository));

      container.dispose();
    });
  });

  group('Abstract ChatRemoteRepository', () {
    test('can be implemented', () {
      final implementation = TestChatRemoteRepository();
      expect(implementation, isA<ChatRemoteRepository>());
    });

    test('abstract methods are properly defined', () {
      expect(ChatRemoteRepository, isA<Type>());

      final implementation = TestChatRemoteRepository();
      final testRequest = AIRequestModel(url: 'test', userPrompt: 'test');
      expect(
        () => implementation.sendChat(request: testRequest),
        returnsNormally,
      );
    });
  });
}

// Test implementation of ChatRemoteRepository
class TestChatRemoteRepository implements ChatRemoteRepository {
  @override
  Future<String?> sendChat({required AIRequestModel request}) async {
    return 'test response';
  }
}

// Mock for testing provider overrides
class MockChatRemoteRepository extends Mock implements ChatRemoteRepository {}
