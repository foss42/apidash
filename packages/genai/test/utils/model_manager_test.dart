import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/consts.dart';
import 'package:genai/interface/interface.dart';
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
      } else if (request.uri.path == '/ollama_success/api/tags') {
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
      } else if (request.uri.path == '/ollama_empty/api/tags') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({}))
          ..close();
      } else if (request.uri.path == '/v1/models') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              "data": [
                {"id": "gpt-test"},
                {"id": "gpt-other"},
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
    test('knownModelsFor skips empty ids', () {
      final models = ModelManager.knownModelsFor(ModelAPIProvider.openai);
      expect(models, isNotEmpty);
      expect(models.every((m) => m.id != null && m.id!.isNotEmpty), isTrue);
    });

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

    test('fetchProviderModels openai live list', () async {
      final res = await ModelManager.fetchProviderModels(
        provider: ModelAPIProvider.openai,
        apiKey: 'sk-test',
        url: '$serverUrl/v1/chat/completions',
      );
      expect(res, isNotNull);
      expect(res!.map((e) => e.id), containsAll(['gpt-test', 'gpt-other']));
    });

    test('fetchProviderModels openai without key returns null', () async {
      final res = await ModelManager.fetchProviderModels(
        provider: ModelAPIProvider.openai,
        apiKey: '',
      );
      expect(res, isNull);
    });

    test('ollamaHostFromEndpoint strips chat path', () {
      expect(
        ModelManager.ollamaHostFromEndpoint(
          'http://localhost:11434/v1/chat/completions',
        ),
        'http://localhost:11434',
      );
    });
  });
}
