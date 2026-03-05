import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/azureopenai.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/models/model_config.dart';
import 'package:genai/models/model_config_value.dart';
import 'package:genai/interface/consts.dart';
import 'package:better_networking/better_networking.dart';
import 'dart:convert';

void main() {
  group('AzureOpenAIModel', () {
    test('should return singleton instance', () {
      final instance1 = AzureOpenAIModel.instance;
      final instance2 = AzureOpenAIModel.instance;

      expect(instance1, same(instance2));
    });

    test('should return default AIRequestModel with Azure OpenAI configs', () {
      final defaultModel = AzureOpenAIModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider,
          equals(ModelAPIProvider.azureopenai));
      expect(defaultModel.modelConfigs.length, greaterThan(0));
    });

    test('should return null when AIRequestModel is null', () {
      final httpReq = AzureOpenAIModel.instance.createRequest(null);

      expect(httpReq, isNull);
    });

    group('createRequest', () {
      test('should throw exception when URL is empty', () {
        const aiReq = AIRequestModel(
          modelApiProvider: ModelAPIProvider.azureopenai,
          url: '',
          model: 'gpt-4',
          apiKey: 'test-api-key',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        expect(
          () => AzureOpenAIModel.instance.createRequest(aiReq),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('MODEL ENDPOINT IS EMPTY'),
          )),
        );
      });

      test('should create correct HttpRequestModel with valid endpoint', () {
        const azureEndpoint =
            'https://myresource.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2024-02-01';
        const aiReq = AIRequestModel(
          modelApiProvider: ModelAPIProvider.azureopenai,
          url: azureEndpoint,
          model: 'gpt-4',
          apiKey: 'test-api-key',
          systemPrompt: 'You are a helpful assistant',
          userPrompt: 'Hello, Azure!',
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;

        expect(httpReq.method, equals(HTTPVerb.post));
        expect(httpReq.url, equals(azureEndpoint));
      });

      test('should use api-key header instead of bearer token', () {
        const aiReq = AIRequestModel(
          url: 'https://test.openai.azure.com/endpoint',
          model: 'gpt-4',
          apiKey: 'azure-key-123',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;

        expect(httpReq.authModel?.type, equals(APIAuthType.apiKey));
        expect(httpReq.authModel?.apikey?.key, equals('azure-key-123'));
        expect(httpReq.authModel?.apikey?.name, equals('api-key'));
      });

      test('should create request with null auth when apiKey is null', () {
        const aiReq = AIRequestModel(
          url: 'https://test.openai.azure.com/endpoint',
          model: 'gpt-4',
          apiKey: null,
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;

        expect(httpReq.authModel, isNull);
      });

      test('should structure JSON body correctly', () {
        const aiReq = AIRequestModel(
          url: 'https://test.openai.azure.com/endpoint',
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'You are helpful',
          userPrompt: 'Tell me a story',
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['model'], equals('gpt-4'));
        expect(body['messages'], isA<List>());
        expect(body['messages'].length, equals(2));
        expect(body['messages'][0]['role'], equals('system'));
        expect(body['messages'][0]['content'], equals('You are helpful'));
        expect(body['messages'][1]['role'], equals('user'));
        expect(body['messages'][1]['content'], equals('Tell me a story'));
      });

      test('should use "Generate" as default user prompt when empty', () {
        const aiReq = AIRequestModel(
          url: 'https://test.openai.azure.com/endpoint',
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: '',
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['messages'][1]['content'], equals('Generate'));
      });

      test('should include stream flag when true', () {
        const aiReq = AIRequestModel(
          url: 'https://test.openai.azure.com/endpoint',
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: true,
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['stream'], isTrue);
      });

      test('should not include stream flag when false', () {
        const aiReq = AIRequestModel(
          url: 'https://test.openai.azure.com/endpoint',
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: false,
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body.containsKey('stream'), isFalse);
      });

      test('should not include stream flag when null', () {
        const aiReq = AIRequestModel(
          url: 'https://test.openai.azure.com/endpoint',
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: null,
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body.containsKey('stream'), isFalse);
      });

      test('should include model config parameters', () {
        final aiReq = AIRequestModel(
          url: 'https://test.openai.azure.com/endpoint',
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTemperature.copyWith(
              value: ConfigSliderValue(value: (0, 0.6, 1)),
            ),
            kDefaultModelConfigMaxTokens.copyWith(
              value: ConfigNumericValue(value: 500),
            ),
          ],
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['temperature'], equals(0.6));
        expect(body['max_tokens'], equals(500));
      });

      test('should include top_p config', () {
        final aiReq = AIRequestModel(
          url: 'https://test.openai.azure.com/endpoint',
          model: 'gpt-4',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTopP.copyWith(
              value: ConfigSliderValue(value: (0, 0.85, 1)),
            ),
          ],
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['top_p'], equals(0.85));
      });

      test('should handle complex Azure endpoint URLs', () {
        const complexUrl =
            'https://my-azure-resource.openai.azure.com/openai/deployments/my-deployment/chat/completions?api-version=2024-02-15-preview';
        const aiReq = AIRequestModel(
          url: complexUrl,
          model: 'gpt-4-turbo',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = AzureOpenAIModel.instance.createRequest(aiReq)!;

        expect(httpReq.url, equals(complexUrl));
      });
    });

    group('outputFormatter', () {
      test('should extract content from valid response', () {
        final response = {
          'choices': [
            {
              'message': {
                'content': 'Azure OpenAI response',
              },
            },
          ],
        };

        final output = AzureOpenAIModel.instance.outputFormatter(response);

        expect(output, equals('Azure OpenAI response'));
      });

      test('should trim whitespace from content', () {
        final response = {
          'choices': [
            {
              'message': {
                'content': '  Response with spaces  \n\t',
              },
            },
          ],
        };

        final output = AzureOpenAIModel.instance.outputFormatter(response);

        expect(output, equals('Response with spaces'));
      });

      test('should return null for missing choices', () {
        final response = <String, dynamic>{};

        final output = AzureOpenAIModel.instance.outputFormatter(response);

        expect(output, isNull);
      });

      test('should throw RangeError for empty choices array', () {
        final response = {
          'choices': <dynamic>[],
        };

        expect(
          () => AzureOpenAIModel.instance.outputFormatter(response),
          throwsA(isA<RangeError>()),
        );
      });

      test('should return null for missing message', () {
        final response = {
          'choices': [
            <String, dynamic>{},
          ],
        };

        final output = AzureOpenAIModel.instance.outputFormatter(response);

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

        final output = AzureOpenAIModel.instance.outputFormatter(response);

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

        final output = AzureOpenAIModel.instance.outputFormatter(response);

        expect(output, equals('Line 1\nLine 2\nLine 3'));
      });
    });

    group('streamOutputFormatter', () {
      test('should extract delta content from stream chunk', () {
        final chunk = {
          'choices': [
            {
              'delta': {
                'content': 'Streaming from Azure',
              },
            },
          ],
        };

        final output = AzureOpenAIModel.instance.streamOutputFormatter(chunk);

        expect(output, equals('Streaming from Azure'));
      });

      test('should return null for missing choices', () {
        final chunk = <String, dynamic>{};

        final output = AzureOpenAIModel.instance.streamOutputFormatter(chunk);

        expect(output, isNull);
      });

      test('should throw RangeError for empty choices', () {
        final chunk = {
          'choices': <dynamic>[],
        };

        expect(
          () => AzureOpenAIModel.instance.streamOutputFormatter(chunk),
          throwsA(isA<RangeError>()),
        );
      });

      test('should return null for missing delta', () {
        final chunk = {
          'choices': [
            <String, dynamic>{},
          ],
        };

        final output = AzureOpenAIModel.instance.streamOutputFormatter(chunk);

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

        final output = AzureOpenAIModel.instance.streamOutputFormatter(chunk);

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

        final output = AzureOpenAIModel.instance.streamOutputFormatter(chunk);

        expect(output, equals(''));
      });
    });
  });
}
