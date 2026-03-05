import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/openai.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/models/model_config.dart';
import 'package:genai/models/model_config_value.dart';
import 'package:genai/interface/consts.dart';
import 'package:better_networking/better_networking.dart';
import 'dart:convert';

void main() {
  group('OpenAIModel', () {
    test('should return singleton instance', () {
      final instance1 = OpenAIModel.instance;
      final instance2 = OpenAIModel.instance;

      expect(instance1, same(instance2));
    });

    test('should return default AIRequestModel with OpenAI configs', () {
      final defaultModel = OpenAIModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider, equals(ModelAPIProvider.openai));
      expect(defaultModel.url, equals(kOpenAIUrl));
      expect(defaultModel.modelConfigs.length, greaterThan(0));
    });

    test('should return null when AIRequestModel is null', () {
      final httpReq = OpenAIModel.instance.createRequest(null);

      expect(httpReq, isNull);
    });

    group('createRequest', () {
      test('should create correct HttpRequestModel with basic fields', () {
        const aiReq = AIRequestModel(
          modelApiProvider: ModelAPIProvider.openai,
          url: kOpenAIUrl,
          model: 'gpt-4',
          apiKey: 'test-api-key',
          systemPrompt: 'You are a helpful assistant',
          userPrompt: 'Hello, world!',
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;

        expect(httpReq.method, equals(HTTPVerb.post));
        expect(httpReq.url, equals(kOpenAIUrl));
        expect(httpReq.authModel?.type, equals(APIAuthType.bearer));
        expect(httpReq.authModel?.bearer?.token, equals('test-api-key'));
      });

      test('should format Bearer token header correctly', () {
        const aiReq = AIRequestModel(
          url: kOpenAIUrl,
          model: 'gpt-3.5-turbo',
          apiKey: 'sk-test123',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;

        expect(httpReq.authModel?.type, equals(APIAuthType.bearer));
        expect(httpReq.authModel?.bearer?.token, equals('sk-test123'));
      });

      test('should create request with null auth when apiKey is null', () {
        const aiReq = AIRequestModel(
          url: kOpenAIUrl,
          model: 'gpt-4',
          apiKey: null,
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;

        expect(httpReq.authModel, isNull);
      });

      test('should structure JSON body correctly', () {
        const aiReq = AIRequestModel(
          url: kOpenAIUrl,
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'You are helpful',
          userPrompt: 'Tell me a joke',
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['model'], equals('gpt-4'));
        expect(body['messages'], isA<List>());
        expect(body['messages'].length, equals(2));
        expect(body['messages'][0]['role'], equals('system'));
        expect(body['messages'][0]['content'], equals('You are helpful'));
        expect(body['messages'][1]['role'], equals('user'));
        expect(body['messages'][1]['content'], equals('Tell me a joke'));
      });

      test('should use "Generate" as default user prompt when empty', () {
        const aiReq = AIRequestModel(
          url: kOpenAIUrl,
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: '',
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['messages'][1]['content'], equals('Generate'));
      });

      test('should include stream flag when true', () {
        const aiReq = AIRequestModel(
          url: kOpenAIUrl,
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: true,
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['stream'], isTrue);
      });

      test('should not include stream flag when false', () {
        const aiReq = AIRequestModel(
          url: kOpenAIUrl,
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: false,
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body.containsKey('stream'), isFalse);
      });

      test('should not include stream flag when null', () {
        const aiReq = AIRequestModel(
          url: kOpenAIUrl,
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: null,
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body.containsKey('stream'), isFalse);
      });

      test('should include model config parameters', () {
        final aiReq = AIRequestModel(
          url: kOpenAIUrl,
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTemperature.copyWith(
              value: ConfigSliderValue(value: (0, 0.7, 1)),
            ),
            kDefaultModelConfigMaxTokens.copyWith(
              value: ConfigNumericValue(value: 1000),
            ),
          ],
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['temperature'], equals(0.7));
        expect(body['max_tokens'], equals(1000));
      });

      test('should include top_p config', () {
        final aiReq = AIRequestModel(
          url: kOpenAIUrl,
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTopP.copyWith(
              value: ConfigSliderValue(value: (0, 0.9, 1)),
            ),
          ],
        );

        final httpReq = OpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['top_p'], equals(0.9));
      });
    });

    group('outputFormatter', () {
      test('should extract content from valid response', () {
        final response = {
          'choices': [
            {
              'message': {
                'content': 'Hello, how can I help you?',
              },
            },
          ],
        };

        final output = OpenAIModel.instance.outputFormatter(response);

        expect(output, equals('Hello, how can I help you?'));
      });

      test('should trim whitespace from content', () {
        final response = {
          'choices': [
            {
              'message': {
                'content': '  Response with spaces  \n',
              },
            },
          ],
        };

        final output = OpenAIModel.instance.outputFormatter(response);

        expect(output, equals('Response with spaces'));
      });

      test('should return null for missing choices', () {
        final response = <String, dynamic>{};

        final output = OpenAIModel.instance.outputFormatter(response);

        expect(output, isNull);
      });

      test('should throw RangeError for empty choices array', () {
        final response = {
          'choices': <dynamic>[],
        };

        expect(
          () => OpenAIModel.instance.outputFormatter(response),
          throwsA(isA<RangeError>()),
        );
      });

      test('should return null for missing message', () {
        final response = {
          'choices': [
            <String, dynamic>{},
          ],
        };

        final output = OpenAIModel.instance.outputFormatter(response);

        expect(output, isNull);
      });

      test('should return null for missing content', () {
        final response = {
          'choices': [
            {
              'message': <String, dynamic>{},
            },
          ],
        };

        final output = OpenAIModel.instance.outputFormatter(response);

        expect(output, isNull);
      });

      test('should handle multiline content', () {
        final response = {
          'choices': [
            {
              'message': {
                'content': 'Line 1\nLine 2\nLine 3',
              },
            },
          ],
        };

        final output = OpenAIModel.instance.outputFormatter(response);

        expect(output, equals('Line 1\nLine 2\nLine 3'));
      });
    });

    group('streamOutputFormatter', () {
      test('should extract delta content from stream chunk', () {
        final chunk = {
          'choices': [
            {
              'delta': {
                'content': 'Hello',
              },
            },
          ],
        };

        final output = OpenAIModel.instance.streamOutputFormatter(chunk);

        expect(output, equals('Hello'));
      });

      test('should return null for missing choices', () {
        final chunk = <String, dynamic>{};

        final output = OpenAIModel.instance.streamOutputFormatter(chunk);

        expect(output, isNull);
      });

      test('should throw RangeError for empty choices', () {
        final chunk = {
          'choices': <dynamic>[],
        };

        expect(
          () => OpenAIModel.instance.streamOutputFormatter(chunk),
          throwsA(isA<RangeError>()),
        );
      });

      test('should return null for missing delta', () {
        final chunk = {
          'choices': [
            <String, dynamic>{},
          ],
        };

        final output = OpenAIModel.instance.streamOutputFormatter(chunk);

        expect(output, isNull);
      });

      test('should return null for missing content in delta', () {
        final chunk = {
          'choices': [
            {
              'delta': <String, dynamic>{},
            },
          ],
        };

        final output = OpenAIModel.instance.streamOutputFormatter(chunk);

        expect(output, isNull);
      });

      test('should handle empty string content', () {
        final chunk = {
          'choices': [
            {
              'delta': {
                'content': '',
              },
            },
          ],
        };

        final output = OpenAIModel.instance.streamOutputFormatter(chunk);

        expect(output, equals(''));
      });
    });
  });
}
