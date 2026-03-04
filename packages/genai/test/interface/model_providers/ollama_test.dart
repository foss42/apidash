import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/ollama.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/consts.dart';

void main() {
  group('OllamaModel', () {
    test('should return default AIRequestModel with Ollama configs', () {
      final defaultModel = OllamaModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider, equals(ModelAPIProvider.ollama));
      expect(defaultModel.url, equals(kOllamaUrl));
    });

    test('should only have temperature and top_p configs', () {
      final defaultModel = OllamaModel.instance.defaultAIRequestModel;
      final configIds =
          defaultModel.modelConfigs.map((c) => c.id).toList();

      expect(configIds, contains('temperature'));
      expect(configIds, contains('top_p'));
      expect(configIds.length, 2);
    });

    test('should inherit OpenAI request format', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.ollama,
        url: kOllamaUrl,
        model: 'llama3',
        apiKey: 'test-key',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
      );

      final httpReq = OllamaModel.instance.createRequest(req)!;

      expect(httpReq.method.name, equals('post'));
      expect(httpReq.url, equals(kOllamaUrl));
    });

    test('should inherit OpenAI output formatting', () {
      final response = {
        'choices': [
          {
            'message': {'content': '  Ollama response  '},
          },
        ],
      };
      final output = OllamaModel.instance.outputFormatter(response);
      expect(output, equals('Ollama response'));
    });

    test('should inherit OpenAI stream output formatting', () {
      final response = {
        'choices': [
          {
            'delta': {'content': 'stream chunk'},
          },
        ],
      };
      final output = OllamaModel.instance.streamOutputFormatter(response);
      expect(output, equals('stream chunk'));
    });
  });
}
