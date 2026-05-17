import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/consts.dart';
import 'package:genai/interface/model_providers/ollama.dart';
import 'package:genai/models/ai_request_model.dart';

void main() {
  group('OllamaModel', () {
    test('should return default AIRequestModel with Ollama provider', () {
      final defaultModel = OllamaModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider, equals(ModelAPIProvider.ollama));
      expect(defaultModel.url, equals(kOllamaUrl));
    });

    test('should only include temperature and top_p model configs by default',
        () {
      final defaultModel = OllamaModel.instance.defaultAIRequestModel;
      final configIds = defaultModel.modelConfigs.map((c) => c.id).toList();

      expect(configIds, containsAll(['temperature', 'top_p']));
      expect(configIds, isNot(contains('max_tokens')));
    });

    test('should use OpenAI-compatible request format', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.ollama,
        url: kOllamaUrl,
        model: 'llama3',
        userPrompt: 'Hello',
        systemPrompt: 'You are helpful',
        stream: false,
      );

      final httpReq = OllamaModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      // Ollama inherits OpenAI format: system prompt in messages
      expect(body.containsKey('messages'), isTrue);
      final messages = body['messages'] as List;
      expect(messages[0]['role'], equals('system'));
      expect(messages[1]['role'], equals('user'));
    });

    test('should use POST method and point to Ollama URL', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.ollama,
        url: kOllamaUrl,
        model: 'llama3',
        userPrompt: 'Hi',
        systemPrompt: '',
        stream: false,
      );

      final httpReq = OllamaModel.instance.createRequest(req)!;
      expect(httpReq.method.name, equals('post'));
      expect(httpReq.url, equals(kOllamaUrl));
    });

    test('should format output correctly (OpenAI-compatible)', () {
      final response = {
        'choices': [
          {
            'message': {'content': '  Ollama response  '},
          },
        ],
      };

      final output = OllamaModel.instance.outputFormatter(response);
      expect(output, equals('Ollama response'));
    });

    test('should format streaming delta output correctly', () {
      final response = {
        'choices': [
          {
            'delta': {'content': 'stream chunk'},
          },
        ],
      };

      final output = OllamaModel.instance.streamOutputFormatter(response);
      expect(output, equals('stream chunk'));
    });

    test('should return null when aiRequestModel is null', () {
      final result = OllamaModel.instance.createRequest(null);
      expect(result, isNull);
    });
  });
}
