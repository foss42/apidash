import 'package:flutter_test/flutter_test.dart';
import 'package:genai/interface/model_providers/gemini.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/consts.dart';

void main() {
  group('GeminiModel', () {
    test('should return default AIRequestModel with Gemini configs', () {
      final defaultModel = GeminiModel.instance.defaultAIRequestModel;

      expect(defaultModel.modelApiProvider, equals(ModelAPIProvider.gemini));
      expect(defaultModel.url, equals(kGeminiUrl));
      expect(defaultModel.modelConfigs.length, greaterThan(0));
    });

    test('should create correct HttpRequestModel for non-streaming', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        url: kGeminiUrl,
        model: 'gemini-pro',
        apiKey: '123',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
        stream: false,
      );

      final httpReq = GeminiModel.instance.createRequest(req)!;

      expect(httpReq.url, contains('generateContent'));
      expect(httpReq.method.name, equals('post'));
      expect(httpReq.authModel?.apikey?.key, equals('123'));
    });

    test('should create correct HttpRequestModel for streaming', () {
      const req = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        url: kGeminiUrl,
        model: 'gemini-pro',
        apiKey: '123',
        userPrompt: 'Hello',
        systemPrompt: 'Sys',
        stream: true,
      );

      final httpReq = GeminiModel.instance.createRequest(req)!;

      expect(httpReq.url, contains('streamGenerateContent'));
    });

    test('should format output correctly', () {
      final response = {
        'candidates': [
          {
            'content': {
              'parts': [
                {'text': 'Hello world'},
              ],
            },
          },
        ],
      };
      final output = GeminiModel.instance.outputFormatter(response);
      expect(output, equals('Hello world'));
    });
  });
}
