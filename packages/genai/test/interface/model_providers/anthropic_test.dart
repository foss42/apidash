import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/anthropic.dart';
import 'package:genai/interface/interface.dart';
import 'package:genai/models/models.dart';

void main() {
  group('AnthropicModel', () {
    test('createRequest with stream and system prompt', () {
      final model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: 'https://api.anthropic.com',
        apiKey: 'key',
        model: 'claude-3',
        userPrompt: 'hi',
        systemPrompt: 'system_instruction',
        stream: true,
      );

      final req = AnthropicModel.instance.createRequest(model);
      expect(req, isNotNull);
      final body = jsonDecode(req!.body.toString());
      expect(body['system'], 'system_instruction');
      expect(body['stream'], isTrue);
    });

    test('createRequest empty user prompt', () {
      final model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: 'https://api.anthropic.com',
        apiKey: 'key',
        model: 'claude-3',
        userPrompt: '',
      );

      final req = AnthropicModel.instance.createRequest(model);
      expect(req, isNotNull);
      final body = jsonDecode(req!.body.toString());
      expect(body['messages'][0]['content'], 'Generate');
    });
    
    test('streamOutputFormatter', () {
      expect(AnthropicModel.instance.streamOutputFormatter({'text': 'hello'}), 'hello');
    });

    test('defaultAIRequestModel', () {
      expect(AnthropicModel.instance.defaultAIRequestModel.modelApiProvider, ModelAPIProvider.anthropic);
    });

    test('createRequest with null', () {
      expect(AnthropicModel.instance.createRequest(null), isNull);
    });

    test('outputFormatter', () {
      expect(AnthropicModel.instance.outputFormatter({
        'content': [
          {'text': 'output'}
        ]
      }), 'output');
    });
  });
}
