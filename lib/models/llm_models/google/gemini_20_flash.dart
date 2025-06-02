import 'dart:convert';

import 'package:apidash/models/llm_models/llm_config.dart';
import 'package:apidash/models/llm_models/llm_model.dart';
import 'package:apidash_core/apidash_core.dart' as http;

class Gemini20FlashModel extends LLMModel {
  static Gemini20FlashModel instance = Gemini20FlashModel();

  @override
  String provider = 'Google';

  @override
  String modelName = 'Gemini 2.0 Flash';

  @override
  String modelIdentifier = 'gemini_20_flash';

  @override
  LLMModelAuthorizationType authorizationType =
      LLMModelAuthorizationType.apiKey;

  @override
  Map<String, LLMModelConfiguration> configurations = {
    'temperature': LLMModelConfiguration(
      configId: 'temperature',
      configName: 'Temperature',
      configDescription:
          'Higher values mean greater variability and lesser values mean more deterministic responses',
      configType: LLMModelConfigurationType.slider,
      configValue: LLMConfigSliderValue(value: (0.0, 0.5, 1.0)),
    ),
    'top_p': LLMModelConfiguration(
      configId: 'top_p',
      configName: 'Top P',
      configDescription: 'Controls the randomness of the LLM Response',
      configType: LLMModelConfigurationType.slider,
      configValue: LLMConfigSliderValue(value: (0.0, 0.95, 1.0)),
    ),
    'max_tokens': LLMModelConfiguration(
      configId: 'max_tokens',
      configName: 'Max Tokens',
      configDescription:
          'The maximum number of tokens to generate. -1 means no limit',
      configType: LLMModelConfigurationType.numeric,
      configValue: LLMConfigNumericValue(value: -1),
    ),
  };

  @override
  String providerIcon = 'https://img.icons8.com/color/48/google-logo.png';

  @override
  LLMModelSpecifics specifics = LLMModelSpecifics(
    endpoint:
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
    method: 'POST',
    headers: {},
    outputFormatter: (resp) {
      if (resp == null) return null;
      return resp['candidates']?[0]?['content']?['parts']?[0]?['text'];
    },
  );

  @override
  Map getRequestPayload({
    required String systemPrompt,
    required String userPrompt,
    required String credential,
  }) {
    final temp = configurations['temperature']!.configValue.serialize();
    final top_p = configurations['top_p']!.configValue.serialize();
    final mT = configurations['max_tokens']!.configValue.serialize();
    final payload = {
      "model": "gemini-2.0-flash",
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": userPrompt}
          ]
        }
      ],
      "systemInstruction": {
        "role": "system",
        "parts": [
          {"text": systemPrompt}
        ]
      },
      "generationConfig": {
        "temperature": (jsonDecode(temp) as List)[1].toString(),
        "topP": (jsonDecode(top_p) as List)[1].toString(),
        if (mT != '-1') ...{
          "maxOutputTokens": mT,
        }
      }
    };
    final endpoint = specifics.endpoint;
    final url = "$endpoint?key=$credential";
    return {
      'url': url,
      'payload': payload,
    };
  }

  @override
  loadConfigurations(Map configMap) {
    print('Loaded Gemini Configurations');
    final double? temperature = configMap['temperature'];
    final double? top_p = configMap['top_p'];
    final int? max_tokens = configMap['max_tokens'];

    //print('loading configs => $temperature, $top_p, $max_tokens');
    if (temperature != null) {
      final config = configurations['temperature']!;
      configurations['temperature'] =
          configurations['temperature']!.updateValue(
        LLMConfigSliderValue(value: (
          config.configValue.value.$1,
          temperature,
          config.configValue.value.$3
        )),
      );
    }
    if (top_p != null) {
      final config = configurations['top_p']!;
      configurations['top_p'] = configurations['top_p']!.updateValue(
        LLMConfigSliderValue(value: (
          config.configValue.value.$1,
          top_p,
          config.configValue.value.$3
        )),
      );
    }
    if (max_tokens != null) {
      configurations['max_tokens'] = configurations['max_tokens']!.updateValue(
        LLMConfigNumericValue(value: max_tokens),
      );
    }

    // Load Modified Endpoint
    if (configMap['modifed_endpoint'] != null) {
      specifics.endpoint = configMap['modifed_endpoint']!;
    }
  }
}
