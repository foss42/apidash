import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/anthropic.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/models/model_config.dart';
import 'package:genai/models/model_config_value.dart';
import 'package:genai/interface/consts.dart';
import 'package:better_networking/better_networking.dart';
import 'dart:convert';

void main() {
  group('AnthropicModel', () {
    test('should return singleton instance', () {
      final instance1 = AnthropicModel.instance;
      final instance2 = AnthropicModel.instance;

      expect(instance1, same(instance2));
    });

    test('should return default AIRequestModel with Anthropic configs', () {
      final defaultModel = AnthropicModel.instance.defaultAIRequestModel;

      expect(
          defaultModel.modelApiProvider, equals(ModelAPIProvider.anthropic));
      expect(defaultModel.url, equals(kAnthropicUrl));
      expect(defaultModel.modelConfigs.length, greaterThan(0));
    });

    test('should return null when AIRequestModel is null', () {
      final httpReq = AnthropicModel.instance.createRequest(null);

      expect(httpReq, isNull);
    });

    group('createRequest', () {
      test('should create correct HttpRequestModel with basic fields', () {
        const aiReq = AIRequestModel(
          modelApiProvider: ModelAPIProvider.anthropic,
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: 'test-api-key',
          systemPrompt: 'You are a helpful assistant',
          userPrompt: 'Hello, Claude!',
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;

        expect(httpReq.method, equals(HTTPVerb.post));
        expect(httpReq.url, equals(kAnthropicUrl));
      });

      test('should use api-key auth type instead of bearer', () {
        const aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-sonnet',
          apiKey: 'sk-ant-test123',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;

        expect(httpReq.authModel?.type, equals(APIAuthType.apiKey));
        expect(httpReq.authModel?.apikey?.key, equals('sk-ant-test123'));
      });

      test('should create request with null auth when apiKey is null', () {
        const aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: null,
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;

        expect(httpReq.authModel, isNull);
      });

      test('should include anthropic-version header', () {
        const aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;

        expect(httpReq.headers, isNotNull);
        expect(httpReq.headers!.length, equals(1));
        expect(httpReq.headers![0].name, equals('anthropic-version'));
        expect(httpReq.headers![0].value, equals('2023-06-01'));
      });

      test('should structure JSON body correctly', () {
        const aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: 'test-key',
          systemPrompt: 'You are helpful',
          userPrompt: 'Tell me about yourself',
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['model'], equals('claude-3-opus'));
        expect(body['messages'], isA<List>());
        expect(body['messages'].length, equals(2));
        expect(body['messages'][0]['role'], equals('system'));
        expect(body['messages'][0]['content'], equals('You are helpful'));
        expect(body['messages'][1]['role'], equals('user'));
        expect(body['messages'][1]['content'], equals('Tell me about yourself'));
      });

      test('should always include user prompt (no default generation)', () {
        const aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'What is AI?',
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['messages'][1]['content'], equals('What is AI?'));
      });

      test('should include stream flag when true', () {
        const aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: true,
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['stream'], isTrue);
      });

      test('should not include stream flag when false', () {
        const aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: false,
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body.containsKey('stream'), isFalse);
      });

      test('should not include stream flag when null', () {
        const aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: null,
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body.containsKey('stream'), isFalse);
      });

      test('should include model config parameters', () {
        final aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTemperature.copyWith(
              value: ConfigSliderValue(value: (0, 0.8, 1)),
            ),
            ModelConfig(
              id: 'max_tokens',
              name: 'Max Tokens',
              description: 'Maximum tokens',
              type: ConfigType.numeric,
              value: ConfigNumericValue(value: 2000),
            ),
          ],
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['temperature'], equals(0.8));
        expect(body['max_tokens'], equals(2000));
      });

      test('should include top_p config', () {
        final aiReq = AIRequestModel(
          url: kAnthropicUrl,
          model: 'claude-3-opus',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTopP.copyWith(
              value: ConfigSliderValue(value: (0, 0.95, 1)),
            ),
          ],
        );

        final httpReq = AnthropicModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['top_p'], equals(0.95));
      });
    });

    group('outputFormatter', () {
      test('should extract text from valid response', () {
        final response = {
          'content': [
            {
              'text': 'Hello! How can I assist you today?',
            },
          ],
        };

        final output = AnthropicModel.instance.outputFormatter(response);

        expect(output, equals('Hello! How can I assist you today?'));
      });

      test('should return null for missing content', () {
        final response = <String, dynamic>{};

        final output = AnthropicModel.instance.outputFormatter(response);

        expect(output, isNull);
      });

      test('should throw RangeError for empty content array', () {
        final response = {
          'content': <dynamic>[],
        };

        expect(
          () => AnthropicModel.instance.outputFormatter(response),
          throwsA(isA<RangeError>()),
        );
      });

      test('should return null for missing text field', () {
        final response = {
          'content': [
            <String, dynamic>{},
          ],
        };

        final output = AnthropicModel.instance.outputFormatter(response);

        expect(output, isNull);
      });

      test('should handle multiline text', () {
        final response = {
          'content': [
            {
              'text': 'First line\nSecond line\nThird line',
            },
          ],
        };

        final output = AnthropicModel.instance.outputFormatter(response);

        expect(output, equals('First line\nSecond line\nThird line'));
      });

      test('should extract from first content block', () {
        final response = {
          'content': [
            {
              'text': 'First block',
            },
            {
              'text': 'Second block',
            },
          ],
        };

        final output = AnthropicModel.instance.outputFormatter(response);

        expect(output, equals('First block'));
      });

      test('should handle empty text', () {
        final response = {
          'content': [
            {
              'text': '',
            },
          ],
        };

        final output = AnthropicModel.instance.outputFormatter(response);

        expect(output, equals(''));
      });
    });

    group('streamOutputFormatter', () {
      test('should extract text from stream chunk', () {
        final chunk = {
          'text': 'Streaming content',
        };

        final output = AnthropicModel.instance.streamOutputFormatter(chunk);

        expect(output, equals('Streaming content'));
      });

      test('should return null for missing text', () {
        final chunk = <String, dynamic>{};

        final output = AnthropicModel.instance.streamOutputFormatter(chunk);

        expect(output, isNull);
      });

      test('should handle empty text', () {
        final chunk = {
          'text': '',
        };

        final output = AnthropicModel.instance.streamOutputFormatter(chunk);

        expect(output, equals(''));
      });

      test('should handle single character', () {
        final chunk = {
          'text': 'a',
        };

        final output = AnthropicModel.instance.streamOutputFormatter(chunk);

        expect(output, equals('a'));
      });

      test('should handle special characters', () {
        final chunk = {
          'text': '!@#\$%^&*()',
        };

        final output = AnthropicModel.instance.streamOutputFormatter(chunk);

        expect(output, equals('!@#\$%^&*()'));
      });
    });
  });
}
