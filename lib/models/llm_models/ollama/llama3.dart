import 'dart:convert';

import 'package:apidash/models/llm_models/llm_config.dart';
import 'package:apidash/models/llm_models/llm_model.dart';

class LLama3LocalModel extends LLMModel {
  static LLama3LocalModel instance = LLama3LocalModel();

  @override
  String provider = 'Local';

  @override
  String modelName = 'LLaMA 3 (Local)';

  @override
  String modelIdentifier = 'llama3_local';

  @override
  LLMModelAuthorizationType authorizationType = LLMModelAuthorizationType.none;

  @override
  Map<String, LLMModelConfiguration> configurations = {
    'temperature': LLMModelConfiguration(
      configId: 'temperature',
      configName: 'Temperature',
      configDescription:
          'Controls the randomness of the model\'s output. Higher is more creative.',
      configType: LLMModelConfigurationType.slider,
      configValue: LLMConfigSliderValue(value: (0.0, 0.7, 1.5)),
    ),
    'top_p': LLMModelConfiguration(
      configId: 'top_p',
      configName: 'Top P',
      configDescription:
          'Limits token selection to a subset of the most likely options.',
      configType: LLMModelConfigurationType.slider,
      configValue: LLMConfigSliderValue(value: (0.0, 0.9, 1.0)),
    ),
    // 'max_tokens': LLMModelConfiguration(
    //   configId: 'max_tokens',
    //   configName: 'Max Tokens',
    //   configDescription:
    //       'Maximum tokens to generate. Set low for short answers.',
    //   configType: LLMModelConfigurationType.numeric,
    //   configValue: LLMConfigNumericValue(value: 512),
    // ),
  };

  @override
  String providerIcon = 'https://img.icons8.com/ios-glyphs/30/bot.png';

  @override
  LLMModelSpecifics specifics = LLMModelSpecifics(
    endpoint: 'http://localhost:11434/v1/chat/completions',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    outputFormatter: (resp) {
      if (resp == null) return null;
      return resp['choices']?[0]?['message']?['content'];
    },
  );

  @override
  Map getRequestPayload({
    required String systemPrompt,
    required String userPrompt,
    required String credential, // not used for local
  }) {
    final temp =
        (jsonDecode(configurations['temperature']!.configValue.serialize())
            as List)[1];
    final topP = (jsonDecode(configurations['top_p']!.configValue.serialize())
        as List)[1];
    // final maxTokens = configurations['max_tokens']!.configValue.value as int;

    final payload = {
      "model": "llama3:latest", // or "llama3:instruct" depending on your server
      "messages": [
        {
          "role": "system",
          "content": systemPrompt,
        },
        {
          "role": "user",
          "content": userPrompt,
        }
      ],
      "temperature": temp,
      "top_p": topP,
      // "max_tokens": maxTokens,
    };

    return {
      'url': specifics.endpoint,
      'payload': payload,
    };
  }

  @override
  loadConfigurations(Map configMap) {
    final double? temperature = configMap['temperature'];
    final double? top_p = configMap['top_p'];
    final int? max_tokens = configMap['max_tokens'];

    if (temperature != null) {
      final config = configurations['temperature']!;
      configurations['temperature'] = config.updateValue(
        LLMConfigSliderValue(value: (
          config.configValue.value.$1,
          temperature,
          config.configValue.value.$3
        )),
      );
    }

    if (top_p != null) {
      final config = configurations['top_p']!;
      configurations['top_p'] = config.updateValue(
        LLMConfigSliderValue(value: (
          config.configValue.value.$1,
          top_p,
          config.configValue.value.$3
        )),
      );
    }

    // if (max_tokens != null) {
    //   configurations['max_tokens'] = configurations['max_tokens']!
    //       .updateValue(LLMConfigNumericValue(value: max_tokens));
    // }

    // Load Modified Endpoint
    if (configMap['modifed_endpoint'] != null) {
      specifics.endpoint = configMap['modifed_endpoint']!;
    }
  }
}
