import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/consts.dart';
import 'package:genai/interface/model_providers/openai.dart';
import 'package:genai/models/ai_request_model.dart';

void main() {
  group('OpenAIModel', () {
    test('should return default AIRequestModel with OpenAI provider', () {
      final defaultModel = OpenAIModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider, equals(ModelAPIProvider.openai));
      expect(defaultModel.url, equals(kOpenAIUrl));
    });

    test('should return null when aiRequestModel is null', () {
      final result = OpenAIModel.instance.createRequest(null);
      expect(result, isNull);
    });

    test('should use POST method', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        url: kOpenAIUrl,
        model: 'gpt-4o',
        apiKey: 'sk-test',
        userPrompt: 'Hello',
        systemPrompt: 'You are helpful',
        stream: false,
      );

      final httpReq = OpenAIModel.instance.createRequest(req)!;
      expect(httpReq.method.name, equals('post'));
      expect(httpReq.url, equals(kOpenAIUrl));
    });

    test('should place system prompt inside messages with role:system', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        url: kOpenAIUrl,
        model: 'gpt-4o',
        apiKey: 'sk-test',
        userPrompt: 'Hello',
        systemPrompt: 'You are a helpful assistant',
        stream: false,
      );

      final httpReq = OpenAIModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;
      final messages = body['messages'] as List;

      expect(messages[0]['role'], equals('system'));
      expect(messages[0]['content'], equals('You are a helpful assistant'));
      expect(messages[1]['role'], equals('user'));
    });

    test('should use "Generate" as fallback when userPrompt is empty', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        url: kOpenAIUrl,
        model: 'gpt-4o',
        userPrompt: '',
        systemPrompt: 'sys',
        stream: false,
      );

      final httpReq = OpenAIModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;
      final messages = body['messages'] as List;

      expect(messages.last['content'], equals('Generate'));
    });

    test('should include stream:true in body when streaming', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        url: kOpenAIUrl,
        model: 'gpt-4o',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
        stream: true,
      );

      final httpReq = OpenAIModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      expect(body['stream'], isTrue);
    });

    test('should not include stream key when streaming is disabled', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        url: kOpenAIUrl,
        model: 'gpt-4o',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
        stream: false,
      );

      final httpReq = OpenAIModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      expect(body.containsKey('stream'), isFalse);
    });

    test('should format non-streaming output correctly', () {
      final response = {
        'choices': [
          {
            'message': {'content': '  Hello from GPT  '},
          },
        ],
      };

      final output = OpenAIModel.instance.outputFormatter(response);
      expect(output, equals('Hello from GPT'));
    });

    test('should format streaming delta output correctly', () {
      final response = {
        'choices': [
          {
            'delta': {'content': 'chunk'},
          },
        ],
      };

      final output = OpenAIModel.instance.streamOutputFormatter(response);
      expect(output, equals('chunk'));
    });

    test('should return null for malformed output', () {
      expect(OpenAIModel.instance.outputFormatter({}), isNull);
      expect(OpenAIModel.instance.streamOutputFormatter({}), isNull);
    });
  });
}
