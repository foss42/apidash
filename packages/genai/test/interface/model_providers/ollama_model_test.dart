import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/ollama.dart';
import 'package:genai/interface/model_providers/openai.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/models/model_config.dart';
import 'package:genai/models/model_config_value.dart';
import 'package:genai/interface/consts.dart';
import 'package:better_networking/better_networking.dart';
import 'dart:convert';

void main() {
  group('OllamaModel', () {
    test('should return singleton instance', () {
      final instance1 = OllamaModel.instance;
      final instance2 = OllamaModel.instance;

      expect(instance1, same(instance2));
    });

    test('should extend OpenAIModel', () {
      final instance = OllamaModel.instance;

      expect(instance, isA<OpenAIModel>());
    });

    test('should return default AIRequestModel with Ollama configs', () {
      final defaultModel = OllamaModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider, equals(ModelAPIProvider.ollama));
      expect(defaultModel.url, equals(kOllamaUrl));
    });

    test('should only include temperature and top_p in default configs', () {
      final defaultModel = OllamaModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelConfigs.length, equals(2));

      final configIds = defaultModel.modelConfigs.map((c) => c.id).toList();
      expect(configIds, contains('temperature'));
      expect(configIds, contains('top_p'));
      expect(configIds, isNot(contains('max_tokens')));
    });

    test('should use Ollama URL by default', () {
      final defaultModel = OllamaModel.instance.defaultAIRequestModel;

      expect(defaultModel.url, equals('http://localhost:11434/v1/chat/completions'));
      expect(defaultModel.url, contains('/v1/chat/completions'));
    });

    group('createRequest - inherits from OpenAI', () {
      test('should return null when AIRequestModel is null', () {
        final httpReq = OllamaModel.instance.createRequest(null);

        expect(httpReq, isNull);
      });

      test('should create correct HttpRequestModel', () {
        const aiReq = AIRequestModel(
          modelApiProvider: ModelAPIProvider.ollama,
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'ollama',
          systemPrompt: 'You are a helpful assistant',
          userPrompt: 'Hello, Ollama!',
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;

        expect(httpReq.method, equals(HTTPVerb.post));
        expect(httpReq.url, contains('localhost:11434'));
      });

      test('should use Bearer auth like OpenAI', () {
        const aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;

        expect(httpReq.authModel?.type, equals(APIAuthType.bearer));
        expect(httpReq.authModel?.bearer?.token, equals('test-key'));
      });

      test('should structure JSON body like OpenAI', () {
        const aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'test-key',
          systemPrompt: 'You are helpful',
          userPrompt: 'Tell me about Ollama',
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['model'], equals('llama2'));
        expect(body['messages'], isA<List>());
        expect(body['messages'].length, equals(2));
        expect(body['messages'][0]['role'], equals('system'));
        expect(body['messages'][0]['content'], equals('You are helpful'));
        expect(body['messages'][1]['role'], equals('user'));
        expect(body['messages'][1]['content'], equals('Tell me about Ollama'));
      });

      test('should use "Generate" when user prompt is empty', () {
        const aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: '',
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['messages'][1]['content'], equals('Generate'));
      });

      test('should include stream flag when true', () {
        const aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          stream: true,
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['stream'], isTrue);
      });
    });

    group('model config handling', () {
      test('should include temperature config', () {
        final aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTemperature.copyWith(
              value: ConfigSliderValue(value: (0, 0.7, 1)),
            ),
          ],
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['temperature'], equals(0.7));
      });

      test('should include top_p config', () {
        final aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTopP.copyWith(
              value: ConfigSliderValue(value: (0, 0.9, 1)),
            ),
          ],
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['top_p'], equals(0.9));
      });

      test('should include both temperature and top_p', () {
        final aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTemperature.copyWith(
              value: ConfigSliderValue(value: (0, 0.8, 1)),
            ),
            kDefaultModelConfigTopP.copyWith(
              value: ConfigSliderValue(value: (0, 0.95, 1)),
            ),
          ],
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['temperature'], equals(0.8));
        expect(body['top_p'], equals(0.95));
      });

      test('should handle unsupported config fields gracefully', () {
        // Test that unsupported configs (like max_tokens) can be passed
        // but won't break the request - they'll just be included in the body
        final aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [
            kDefaultModelConfigTemperature.copyWith(
              value: ConfigSliderValue(value: (0, 0.7, 1)),
            ),
            ModelConfig(
              id: 'unsupported_field',
              name: 'Unsupported',
              description: 'Not supported by Ollama',
              type: ConfigType.numeric,
              value: ConfigNumericValue(value: 100),
            ),
          ],
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        // Temperature should still work
        expect(body['temperature'], equals(0.7));
        // Unsupported field is included (Ollama may ignore it)
        expect(body['unsupported_field'], equals(100));
      });

      test('should work with empty modelConfigs', () {
        const aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          apiKey: 'test-key',
          systemPrompt: 'System',
          userPrompt: 'User',
          modelConfigs: [],
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['model'], equals('llama2'));
        expect(body['messages'], isNotEmpty);
      });
    });

    group('outputFormatter - inherits from OpenAI', () {
      test('should extract content from valid response', () {
        final response = {
          'choices': [
            {
              'message': {
                'content': 'Hello from Ollama!',
              },
            },
          ],
        };

        final output = OllamaModel.instance.outputFormatter(response);

        expect(output, equals('Hello from Ollama!'));
      });

      test('should trim whitespace from content', () {
        final response = {
          'choices': [
            {
              'message': {
                'content': '  Ollama response  \n',
              },
            },
          ],
        };

        final output = OllamaModel.instance.outputFormatter(response);

        expect(output, equals('Ollama response'));
      });

      test('should return null for missing choices', () {
        final response = <String, dynamic>{};

        final output = OllamaModel.instance.outputFormatter(response);

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

        final output = OllamaModel.instance.outputFormatter(response);

        expect(output, equals('Line 1\nLine 2\nLine 3'));
      });
    });

    group('streamOutputFormatter - inherits from OpenAI', () {
      test('should extract delta content from stream chunk', () {
        final chunk = {
          'choices': [
            {
              'delta': {
                'content': 'Streaming',
              },
            },
          ],
        };

        final output = OllamaModel.instance.streamOutputFormatter(chunk);

        expect(output, equals('Streaming'));
      });

      test('should return null for missing choices', () {
        final chunk = <String, dynamic>{};

        final output = OllamaModel.instance.streamOutputFormatter(chunk);

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

        final output = OllamaModel.instance.streamOutputFormatter(chunk);

        expect(output, equals(''));
      });
    });

    group('common Ollama models', () {
      test('should work with llama2 model', () {
        const aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'llama2',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['model'], equals('llama2'));
      });

      test('should work with mistral model', () {
        const aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'mistral',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['model'], equals('mistral'));
      });

      test('should work with codellama model', () {
        const aiReq = AIRequestModel(
          url: 'http://localhost:11434/v1/chat/completions',
          model: 'codellama',
          systemPrompt: 'System',
          userPrompt: 'User',
        );

        final httpReq = OllamaModel.instance.createRequest(aiReq)!;
        final body = jsonDecode(httpReq.body!);

        expect(body['model'], equals('codellama'));
      });
    });
  });
}
