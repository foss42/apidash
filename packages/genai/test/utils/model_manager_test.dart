import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/consts.dart';
import 'package:genai/interface/interface.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/models/models_data.g.dart';
import 'package:genai/utils/model_manager.dart';

void main() {
  late HttpServer server;
  late String serverUrl;

  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    serverUrl = 'http://${server.address.host}:${server.port}';

    server.listen((HttpRequest request) async {
      if (request.uri.path == '/remote_success') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonEncode(kModelsData))
          ..close();
      } else if (request.uri.path == '/ollama_success/api/ps') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              "models": [
                {"model": "llama3", "name": "llama3"},
              ],
            }),
          )
          ..close();
      } else if (request.uri.path == '/ollama_empty/api/ps') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({}))
          ..close();
      } else if (request.uri.path == '/custom/v1/models') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              "object": "list",
              "data": [
                {"id": "gpt-4o", "object": "model"},
                {"id": "gpt-4o-mini", "object": "model"},
              ],
            }),
          )
          ..close();
      } else if (request.uri.path == '/gemini/v1beta/models') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              "models": [
                {
                  "name": "models/gemini-test",
                  "displayName": "Gemini Test",
                },
              ],
            }),
          )
          ..close();
      } else if (request.uri.path == '/ollama/v1/models') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              "object": "list",
              "data": [
                {"id": "llama3.2", "object": "model"},
              ],
            }),
          )
          ..close();
      } else if (request.uri.path == '/error') {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('Error')
          ..close();
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..close();
      }
    });
  });

  tearDownAll(() async {
    await server.close(force: true);
  });

  group('ModelManager', () {
    test('fetchModelsFromRemote success', () async {
      final res = await ModelManager.fetchModelsFromRemote(
        remoteURL: '$serverUrl/remote_success',
      );
      expect(res, isNotNull);
    });

    test('fetchModelsFromRemote failure (null response)', () async {
      final res = await ModelManager.fetchModelsFromRemote(
        remoteURL: '$serverUrl/error',
      );
      expect(res, isNull);
    });

    test('fetchModelsFromRemote network error', () async {
      final res = await ModelManager.fetchModelsFromRemote(
        remoteURL: 'http://invalid.local',
      );
      expect(res, isNull);
    });

    test('fetchAvailableModels success replaces ollama', () async {
      final res = await ModelManager.fetchAvailableModels(
        ollamaUrl: '$serverUrl/ollama_success',
      );
      expect(res, isNotNull);
      final ollamaProvider = res.modelProviders.firstWhere(
        (p) => p.providerId == ModelAPIProvider.ollama,
      );
      expect(ollamaProvider.models!.length, 1);
      expect(ollamaProvider.models![0].id, 'llama3');
    });

    test('fetchAvailableModels failure keeps default', () async {
      final res = await ModelManager.fetchAvailableModels(
        ollamaUrl: '$serverUrl/error',
      );
      expect(res, kAvailableModels);
    });

    test('fetchAvailableModels network error keeps default', () async {
      final res = await ModelManager.fetchAvailableModels(
        ollamaUrl: 'http://invalid.local',
      );
      expect(res, kAvailableModels);
    });

    test('fetchInstalledOllamaModels success', () async {
      final res = await ModelManager.fetchInstalledOllamaModels(
        ollamaUrl: '$serverUrl/ollama_success',
      );
      expect(res, isNotNull);
      expect(res!.length, 1);
    });

    test('fetchInstalledOllamaModels null models', () async {
      final res = await ModelManager.fetchInstalledOllamaModels(
        ollamaUrl: '$serverUrl/ollama_empty',
      );
      expect(res, isEmpty);
    });

    test('fetchInstalledOllamaModels failure', () async {
      final res = await ModelManager.fetchInstalledOllamaModels(
        ollamaUrl: '$serverUrl/error',
      );
      expect(res, isNull);
    });

    test('fetchInstalledOllamaModels network error', () async {
      final res = await ModelManager.fetchInstalledOllamaModels(
        ollamaUrl: 'http://invalid.local',
      );
      expect(res, isNull);
    });
  });

  group('fetchProviderModels', () {
    test('openai-compatible provider returns parsed models', () async {
      final res = await ModelManager.fetchProviderModels(
        ModelAPIProvider.openai,
        aiRequestModel: AIRequestModel(
          modelApiProvider: ModelAPIProvider.openai,
          url: '$serverUrl/custom/v1/chat/completions',
          apiKey: 'sk-test',
        ),
      );
      expect(res, isNotNull);
      expect(res!.map((m) => m.id), ['gpt-4o', 'gpt-4o-mini']);
    });

    test('gemini provider returns parsed models', () async {
      final res = await ModelManager.fetchProviderModels(
        ModelAPIProvider.gemini,
        aiRequestModel: AIRequestModel(
          modelApiProvider: ModelAPIProvider.gemini,
          url: '$serverUrl/gemini/v1beta/models',
          apiKey: 'gemini-key',
        ),
      );
      expect(res, isNotNull);
      expect(res!.single.id, 'gemini-test');
      expect(res.single.name, 'Gemini Test');
    });

    test('ollama provider returns parsed models without api key', () async {
      final res = await ModelManager.fetchProviderModels(
        ModelAPIProvider.ollama,
        aiRequestModel: AIRequestModel(
          modelApiProvider: ModelAPIProvider.ollama,
          url: '$serverUrl/ollama/v1/chat/completions',
        ),
      );
      expect(res, isNotNull);
      expect(res!.single.id, 'llama3.2');
    });

    test('returns null when api key is missing', () async {
      final res = await ModelManager.fetchProviderModels(
        ModelAPIProvider.openai,
        aiRequestModel: const AIRequestModel(
          modelApiProvider: ModelAPIProvider.openai,
          url: 'https://api.openai.com/v1/chat/completions',
        ),
      );
      expect(res, isNull);
    });

    test('returns null for providers that cannot list models', () async {
      final res = await ModelManager.fetchProviderModels(
        ModelAPIProvider.azureopenai,
        aiRequestModel: const AIRequestModel(
          modelApiProvider: ModelAPIProvider.azureopenai,
          url: 'https://example.openai.azure.com',
          apiKey: 'key',
        ),
      );
      expect(res, isNull);
    });

    test('returns null on server error', () async {
      final res = await ModelManager.fetchProviderModels(
        ModelAPIProvider.openai,
        aiRequestModel: AIRequestModel(
          modelApiProvider: ModelAPIProvider.openai,
          url: '$serverUrl/error/v1/chat/completions',
          apiKey: 'sk-test',
        ),
      );
      expect(res, isNull);
    });
  });
}
