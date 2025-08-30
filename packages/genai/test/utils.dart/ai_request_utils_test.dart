import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/consts.dart';
import 'package:genai/utils/ai_request_utils.dart';
import 'package:better_networking/better_networking.dart';

const kTestingAPIKey = "XXXXXXXXXXXX";

void main() {
  group('ai_request_utils', () {
    test(
      'executeGenAIRequest should return formatted output on success',
      () async {
        const model = AIRequestModel(
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
