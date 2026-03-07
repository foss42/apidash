import 'dart:convert';
import 'package:better_networking/better_networking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/consts.dart';
import 'package:genai/interface/model_providers/ollama.dart';
import 'package:genai/models/models.dart';

void main() {
  group('OllamaModel Request Generation', () {
    test('creates raw prompt request for /api/generate', () {
      final aiRequestModel = AIRequestModel(
        modelApiProvider: ModelAPIProvider.ollama,
        url: 'http://localhost:11434/api/generate',
        model: 'llama2',
        systemPrompt: 'You are a helpful assistant.',
        userPrompt: 'Tell me a joke.',
        stream: false,
      );

      final httpRequest = OllamaModel.instance.createRequest(aiRequestModel);

      expect(httpRequest, isNotNull);
      expect(httpRequest!.method, HTTPVerb.post);
      expect(httpRequest.url, 'http://localhost:11434/api/generate');

      final body = jsonDecode(httpRequest.body!) as Map<String, dynamic>;
      expect(body['model'], 'llama2');
      expect(body['prompt'], 'Tell me a joke.');
      expect(body['system'], 'You are a helpful assistant.');
      expect(body['stream'], false);
    });

    test('creates open ai compatible messages array for /api/chat', () {
      final aiRequestModel = AIRequestModel(
        modelApiProvider: ModelAPIProvider.ollama,
        url: 'http://localhost:11434/api/chat',
        model: 'mistral',
        systemPrompt: 'System',
        userPrompt: 'User Message',
        stream: true,
      );

      final httpRequest = OllamaModel.instance.createRequest(aiRequestModel);

      expect(httpRequest, isNotNull);
      expect(httpRequest!.method, HTTPVerb.post);

      final body = jsonDecode(httpRequest.body!) as Map<String, dynamic>;
      expect(body['model'], 'mistral');
      expect(body['messages'], isList);
      final messages = body['messages'] as List;
      expect(messages.length, 2);
      expect(messages[0]['role'], 'system');
      expect(messages[0]['content'], 'System');
      expect(messages[1]['role'], 'user');
      expect(messages[1]['content'], 'User Message');
      expect(body['stream'], true);
    });

    test('adds Empty model string if model is null', () {
      final aiRequestModel = AIRequestModel(
        modelApiProvider: ModelAPIProvider.ollama,
        url: 'http://localhost:11434/api/chat',
        model: null,
      );

      final httpRequest = OllamaModel.instance.createRequest(aiRequestModel);
      final body = jsonDecode(httpRequest!.body!) as Map<String, dynamic>;
      expect(body['model'], '');
    });
  });

  group('OllamaModel Response Formatters', () {
    test('outputFormatter parses /api/chat payload', () {
      final payload = {"model":"llama3","created_at":"2023-08-04T19:22:45.499127Z","message":{"role":"assistant","content":"Sure!"},"done":true};
      final result = OllamaModel.instance.outputFormatter(payload);
      expect(result, "Sure!");
    });

    test('outputFormatter parses /api/generate payload', () {
      final payload = {"model":"llama3","created_at":"2023-08-04T19:22:45.499127Z","response":"Ok!","done":true};
      final result = OllamaModel.instance.outputFormatter(payload);
      expect(result, "Ok!");
    });
    
    test('outputFormatter passes OpenAI format correctly', () {
      final payload = {"choices": [{"message": {"content": "Hello OpenAI!"}}]};
      final result = OllamaModel.instance.outputFormatter(payload);
      expect(result, "Hello OpenAI!");
    });
  });
}
