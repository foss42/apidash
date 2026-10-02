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

    test('streamOutputFormatter extracts text from content_block_delta', () {
      expect(
        AnthropicModel.instance.streamOutputFormatter({
          'type': 'content_block_delta',
          'index': 0,
          'delta': {'type': 'text_delta', 'text': 'hello'},
        }),
        'hello',
      );
    });

    test('streamOutputFormatter ignores non-text events', () {
      for (final event in const [
        {'type': 'message_start'},
        {'type': 'ping'},
        {'type': 'content_block_start'},
        {'type': 'content_block_stop'},
        {'type': 'message_stop'},
      ]) {
        expect(AnthropicModel.instance.streamOutputFormatter(event), isNull);
      }
    });

    test('streamOutputFormatter handles content_block_delta without text', () {
      expect(
        AnthropicModel.instance.streamOutputFormatter({
          'type': 'content_block_delta',
          'delta': {'type': 'input_json_delta', 'partial_json': '{}'},
        }),
        isNull,
      );
    });

    test('defaultAIRequestModel', () {
      expect(
        AnthropicModel.instance.defaultAIRequestModel.modelApiProvider,
        ModelAPIProvider.anthropic,
      );
    });

    test('createRequest with null', () {
      expect(AnthropicModel.instance.createRequest(null), isNull);
    });

    test('outputFormatter', () {
      expect(
        AnthropicModel.instance.outputFormatter({
          'content': [
            {'text': 'output'},
          ],
        }),
        'output',
      );
    });
  });
}
