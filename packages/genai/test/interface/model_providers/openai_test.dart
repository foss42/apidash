import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/openai.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/consts.dart';

void main() {
  group('OpenAIModel', () {
    test('should return default AIRequestModel with OpenAI configs', () {
      final defaultModel = OpenAIModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider, equals(ModelAPIProvider.openai));
      expect(defaultModel.url, equals(kOpenAIUrl));
      expect(defaultModel.modelConfigs.length, greaterThan(0));
    });

    test('should create correct HttpRequestModel', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        url: kOpenAIUrl,
        model: 'gpt-4',
        apiKey: 'test-key',
        userPrompt: 'Hello',
        systemPrompt: 'You are helpful',
        stream: false,
      );

      final httpReq = OpenAIModel.instance.createRequest(req)!;

      expect(httpReq.url, equals(kOpenAIUrl));
      expect(httpReq.method.name, equals('post'));
      expect(httpReq.authModel?.type.name, equals('bearer'));
      expect(httpReq.authModel?.bearer?.token, equals('test-key'));
    });

    test('should include stream flag when streaming is enabled', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        url: kOpenAIUrl,
        model: 'gpt-4',
        apiKey: 'test-key',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
        stream: true,
      );

      final httpReq = OpenAIModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      expect(body['stream'], true);
    });

    test('should use "Generate" as default user prompt when empty', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        url: kOpenAIUrl,
        model: 'gpt-4',
        apiKey: 'test-key',
        userPrompt: '',
        systemPrompt: 'Sys',
      );

      final httpReq = OpenAIModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;
      final messages = body['messages'] as List;
      final userMessage = messages.firstWhere((m) => m['role'] == 'user');

      expect(userMessage['content'], 'Generate');
    });

    test('should return null for null request', () {
      final result = OpenAIModel.instance.createRequest(null);
      expect(result, isNull);
    });

    test('should create request without auth when apiKey is null', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        url: kOpenAIUrl,
        model: 'gpt-4',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
      );

      final httpReq = OpenAIModel.instance.createRequest(req)!;
      expect(httpReq.authModel, isNull);
    });

    test('should format output correctly', () {
      final response = {
        'choices': [
          {
            'message': {'content': '  Hello world  '},
          },
        ],
      };
      final output = OpenAIModel.instance.outputFormatter(response);
      expect(output, equals('Hello world'));
    });

    test('should format stream output correctly', () {
      final response = {
        'choices': [
          {
            'delta': {'content': 'streaming chunk'},
          },
        ],
      };
      final output = OpenAIModel.instance.streamOutputFormatter(response);
      expect(output, equals('streaming chunk'));
    });

    test('should return null when response has no choices key', () {
      expect(OpenAIModel.instance.outputFormatter({}), isNull);
      expect(OpenAIModel.instance.streamOutputFormatter({}), isNull);
    });
  });
}
