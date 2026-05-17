import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/consts.dart';
import 'package:genai/interface/model_providers/anthropic.dart';
import 'package:genai/models/ai_request_model.dart';

void main() {
  group('AnthropicModel', () {
    test('should return default AIRequestModel with Anthropic provider', () {
      final defaultModel = AnthropicModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider, equals(ModelAPIProvider.anthropic));
      expect(defaultModel.url, equals(kAnthropicUrl));
    });

    test('should return null when aiRequestModel is null', () {
      final result = AnthropicModel.instance.createRequest(null);
      expect(result, isNull);
    });

    test('should set anthropic-version header', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-5-sonnet-latest',
        apiKey: 'test-key',
        userPrompt: 'Hello',
        systemPrompt: 'You are helpful',
        stream: false,
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;

      expect(
        httpReq.headers?.any(
          (h) => h.name == 'anthropic-version' && h.value == '2023-06-01',
        ),
        isTrue,
      );
    });

    test('should place system prompt as top-level field, not inside messages',
        () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-5-sonnet-latest',
        apiKey: 'test-key',
        userPrompt: 'Hello',
        systemPrompt: 'You are a helpful assistant',
        stream: false,
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      // system prompt must be a top-level key
      expect(body['system'], equals('You are a helpful assistant'));

      // messages must contain only the user role, never system
      final messages = body['messages'] as List;
      expect(messages, hasLength(1));
      expect(messages[0]['role'], equals('user'));
      expect(
        messages.any((m) => m['role'] == 'system'),
        isFalse,
        reason: 'Anthropic API does not support role:system inside messages',
      );
    });

    test('should omit system field when systemPrompt is empty', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-5-sonnet-latest',
        userPrompt: 'Hello',
        systemPrompt: '',
        stream: false,
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      expect(body.containsKey('system'), isFalse);
    });

    test('should use "Generate" as fallback when userPrompt is empty', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-5-sonnet-latest',
        userPrompt: '',
        systemPrompt: 'sys',
        stream: false,
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;
      final messages = body['messages'] as List;

      expect(messages[0]['content'], equals('Generate'));
    });

    test('should include stream:true in body when streaming is enabled', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-5-sonnet-latest',
        apiKey: 'test-key',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
        stream: true,
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      expect(body['stream'], isTrue);
    });

    test('should not include stream key when streaming is disabled', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-5-sonnet-latest',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
        stream: false,
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;
      final body = jsonDecode(httpReq.body!) as Map<String, dynamic>;

      expect(body.containsKey('stream'), isFalse);
    });

    test('should format non-streaming output correctly', () {
      final response = {
        'content': [
          {'text': 'Hello from Claude'},
        ],
      };

      final output = AnthropicModel.instance.outputFormatter(response);
      expect(output, equals('Hello from Claude'));
    });

    test('should return null for malformed non-streaming output', () {
      final output = AnthropicModel.instance.outputFormatter({});
      expect(output, isNull);
    });

    test('should use POST method', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.anthropic,
        url: kAnthropicUrl,
        model: 'claude-3-5-sonnet-latest',
        userPrompt: 'Hi',
        systemPrompt: '',
        stream: false,
      );

      final httpReq = AnthropicModel.instance.createRequest(req)!;
      expect(httpReq.method.name, equals('post'));
    });
  });
}
