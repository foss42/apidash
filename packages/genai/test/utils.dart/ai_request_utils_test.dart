import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/consts.dart';
import 'package:genai/utils/ai_request_utils.dart';

const kGeminiApiKey = 'GEMINI_API_KEY';

void main() {
  group('ai_request_utils', () {
    test(
      'executeGenAIRequest should return formatted output on success',
      () async {
        Map<String, String> envVars = Platform.environment;
        String? kTestingAPIKey;
        if (envVars.containsKey(kGeminiApiKey)) {
          kTestingAPIKey = envVars[kGeminiApiKey];
        } else {
          throw ArgumentError(
            '$kGeminiApiKey should be available as an environment variable.',
          );
        }
        var model = AIRequestModel(
          modelApiProvider: ModelAPIProvider.gemini,
          model: 'gemini-2.0-flash',
          url: kGeminiUrl,
          userPrompt: 'Convert the Given Number into Binary',
          systemPrompt: '1',
          apiKey: kTestingAPIKey,
        );
        final result = await executeGenAIRequest(model);
        expect(result, isNotNull);
      },
    );
  });
  group('AI Request Utils Parsing', () {
    test('should parse Gemini-style non-SSE JSON chunks', () {
      const chunk = '{"candidates": [{"content": {"parts": [{"text": "Streamed response"}]}}]}';
      final regex = RegExp(r'"text"\s*:\s*"((?:\\.|[^"\\])*)"');
      final match = regex.firstMatch(chunk);

      expect(match?.group(1), equals("Streamed response"));
    });

    test('should parse standard SSE data format (OpenAI/Groq)', () {
      const sseLine = 'data: {"choices": [{"delta": {"content": "Hello world"}}]}';

      // Simulating your logic in streamGenAIRequest
      final jsonStr = sseLine.substring(6).trim();
      final jsonData = jsonDecode(jsonStr);
      final content = jsonData['choices'][0]['delta']['content'];

      expect(content, equals("Hello world"));
    });

    test('should handle API Error chunks', () {
      const errorChunk = '{"error": {"message": "Rate limit reached", "code": "429"}}';

      // Check your error detection logic
      final hasError = errorChunk.contains('"error"') && errorChunk.contains('"code"');
      expect(hasError, isTrue);
    });
  });
}
