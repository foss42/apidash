import 'dart:convert';

import 'package:apidash/models/llm_models/llm_config.dart';
import 'package:apidash/models/llm_models/llm_model.dart';

class Gemini20FlashModel extends LLMModel {
  @override
  String authorizationCredential = '';

  @override
  LLMModelAuthorizationType authorizationType =
      LLMModelAuthorizationType.apiKey;

  @override
  List<LLMModelConfiguration> configurations = [
    LLMModelConfiguration(
      configName: 'Temperature',
      configDescription:
          'Higher values mean greater variability and lesser values mean more deterministic responses',
      configType: LLMModelConfigurationType.slider,
      configValue: LLMConfigSliderValue(value: (0.0, 0.5, 1.0)),
    ),
    LLMModelConfiguration(
      configName: 'Top P',
      configDescription: 'Controls the randomness of the LLM Response',
      configType: LLMModelConfigurationType.slider,
      configValue: LLMConfigSliderValue(value: (0.0, 0.95, 1.0)),
    ),
    LLMModelConfiguration(
      configName: 'Response Format (JSON)',
      configDescription:
          'Enforces that the returned response is in JSON format',
      configType: LLMModelConfigurationType.boolean,
      configValue: LLMConfigBooleanValue(value: false),
    ),
    LLMModelConfiguration(
      configName: 'Max Tokens',
      configDescription:
          'The maximum number of tokens to generate. -1 means no limit',
      configType: LLMModelConfigurationType.numeric,
      configValue: LLMConfigNumericValue(value: -1),
    ),
  ];

  @override
  String jsonPayloadBody = jsonEncode({});

  @override
  String modelName = 'Gemini 2.0 Flash';

  @override
  String provider = 'Google';

  @override
  String providerIcon = 'https://img.icons8.com/color/48/google-logo.png';
}
