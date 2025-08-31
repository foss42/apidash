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
}
