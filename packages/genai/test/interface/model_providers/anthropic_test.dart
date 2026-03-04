import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/anthropic.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/consts.dart';

void main() {
  group('AnthropicModel', () {
    test('should return default AIRequestModel with Anthropic configs', () {
      final defaultModel = AnthropicModel.instance.defaultAIRequestModel;

      expect(
          defaultModel.modelApiProvider, equals(ModelAPIProvider.anthropic));
      expect(defaultModel.url, equals(kAnthropicUrl));
      expect(defaultModel.modelConfigs.length, greaterThan(0));
    });

    test('should create correct HttpRequestModel', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-opus',
        apiKey: 'test-key',
        userPrompt: 'Hello',
        systemPrompt: 'You are helpful',
        stream: false,
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;

      expect(httpReq.url, equals(kAnthropicUrl));
      expect(httpReq.method.name, equals('post'));
      expect(httpReq.authModel?.type.name, equals('apiKey'));
      expect(httpReq.authModel?.apikey?.key, equals('test-key'));
    });

    test('should include anthropic-version header', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-opus',
        apiKey: 'test-key',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;
      final versionHeader = httpReq.headers?.firstWhere(
        (h) => h.name == 'anthropic-version',
      );

      expect(versionHeader, isNotNull);
      expect(versionHeader?.value, equals('2023-06-01'));
    });

    test('should include stream flag when streaming is enabled', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-opus',
        apiKey: 'test-key',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
        stream: true,
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      expect(body['stream'], true);
    });

    test('should return null for null request', () {
      final result = AnthropicModel.instance.createRequest(null);
      expect(result, isNull);
    });

    test('should create request without auth when apiKey is null', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-opus',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;
      expect(httpReq.authModel, isNull);
    });

    test('should format output correctly', () {
      final response = {
        'content': [
          {'text': 'Hello from Claude'},
        ],
      };
      final output = AnthropicModel.instance.outputFormatter(response);
      expect(output, equals('Hello from Claude'));
    });

    test('should format stream output correctly', () {
      final response = {'text': 'streaming chunk'};
      final output = AnthropicModel.instance.streamOutputFormatter(response);
      expect(output, equals('streaming chunk'));
    });

    test('should return null when response has no content key', () {
      expect(AnthropicModel.instance.outputFormatter({}), isNull);
      expect(AnthropicModel.instance.streamOutputFormatter({}), isNull);
    });
  });
}
