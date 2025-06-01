import 'dart:convert';

import 'package:apidash/models/llm_models/llm_config.dart';
import 'package:apidash/models/llm_models/llm_model.dart';

class AzureOpenAIModel extends LLMModel {
  static AzureOpenAIModel instance = AzureOpenAIModel();

  @override
  String provider = 'Azure OpenAI';

  @override
  String modelName = 'AzureOpenAI';

  @override
  String modelIdentifier = 'azure_openai';

  @override
  LLMModelAuthorizationType authorizationType =
      LLMModelAuthorizationType.apiKey;
  @override
  Map<String, LLMModelConfiguration> configurations = {
    'azure_endpoint': LLMModelConfiguration(
      configId: 'azure_endpoint',
      configName: 'Azure Endpoint',
      configDescription: 'The endpoint for Azure OpenAI',
      configType: LLMModelConfigurationType.text,
      configValue: LLMConfigTextValue(
        value: 'https://openai.azure.com',
      ),
    ),
    'azure_api_version': LLMModelConfiguration(
      configId: 'azure_api_version',
      configName: 'Azure API Version',
      configDescription:
          'The Exact Version of the API used inside Azure OpenAI',
      configType: LLMModelConfigurationType.text,
      configValue: LLMConfigTextValue(
        value: 'YYYY-MM-DD-preview',
      ),
    ),
    'azure_deployment_name': LLMModelConfiguration(
      configId: 'azure_deployment_name',
      configName: 'Azure Deployment Name',
      configDescription: 'The Model Name within Azure OpenAI',
      configType: LLMModelConfigurationType.text,
      configValue: LLMConfigTextValue(
        value: 'GPT4o',
      ),
    ),
    'temperature': LLMModelConfiguration(
      configId: 'temperature',
      configName: 'Temperature',
      configDescription:
          'Controls the randomness of the model\'s output. Higher is more creative.',
      configType: LLMModelConfigurationType.slider,
      configValue: LLMConfigSliderValue(value: (0.0, 0.5, 1.0)),
    ),
    'top_p': LLMModelConfiguration(
      configId: 'top_p',
      configName: 'Top P',
      configDescription:
          'Limits token selection to a subset of the most likely options.',
      configType: LLMModelConfigurationType.slider,
      configValue: LLMConfigSliderValue(value: (0.0, 0.95, 1.0)),
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
    endpoint: "",
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    outputFormatter: (resp) {
      if (resp == null) return null;
      return resp["choices"]?[0]["message"]?["content"]?.trim();
    },
  );

  @override
  Map getRequestPayload({
    required String systemPrompt,
    required String userPrompt,
    required String credential,
  }) {
    final temp =
        (jsonDecode(configurations['temperature']!.configValue.serialize())
            as List)[1];
    final topP = (jsonDecode(configurations['top_p']!.configValue.serialize())
        as List)[1];
    // final maxTokens = configurations['max_tokens']!.configValue.value as int;

    final payload = {
      "messages": [
        {
          "role": "system",
          "content": systemPrompt,
        },
        if (userPrompt.isNotEmpty) ...{
          {
            "role": "user",
            "content": userPrompt,
          }
        } else ...{
          {"role": "user", "content": "Generate"}
        }
      ],
      "temperature": temp,
      "top_p": topP,
      // "max_tokens": maxTokens,
    };

    final azendpoint = configurations['azure_endpoint']!.configValue.value;
    final azdep = configurations['azure_deployment_name']!.configValue.value;
    final azapiver = configurations['azure_api_version']!.configValue.value;
    final url =
        "$azendpoint/openai/deployments/$azdep/chat/completions?api-version=$azapiver";

    return {
      'url': url,
      'payload': payload,
      'headers': {'api-key': credential, ...specifics.headers}
    };
  }

  @override
  loadConfigurations(Map configMap) {
    final double? temperature = configMap['temperature'];
    final double? top_p = configMap['top_p'];
    // final int? max_tokens = configMap['max_tokens'];

    final String? azure_endpoint = configMap['azure_endpoint'];
    final String? azure_api_version = configMap['azure_api_version'];
    final String? azure_deployment_name = configMap['azure_deployment_name'];

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

    if (azure_endpoint != null) {
      final config = configurations['azure_endpoint']!;
      configurations['azure_endpoint'] = config.updateValue(
        LLMConfigTextValue(value: azure_endpoint),
      );
    }

    if (azure_api_version != null) {
      final config = configurations['azure_api_version']!;
      configurations['azure_api_version'] = config.updateValue(
        LLMConfigTextValue(value: azure_api_version),
      );
    }

    if (azure_deployment_name != null) {
      final config = configurations['azure_deployment_name']!;
      configurations['azure_deployment_name'] = config.updateValue(
        LLMConfigTextValue(value: azure_deployment_name),
      );
    }

    // if (max_tokens != null) {
    //   configurations['max_tokens'] = configurations['max_tokens']!
    //       .updateValue(LLMConfigNumericValue(value: max_tokens));
    // }
  }
}


/*


 static Future<String?> openai_azure(
    String systemPrompt,
    String input,
    String credential,
  ) async {
    //KEY_FORMAT: domain|modelname|apiv|key

    final credParts = credential.split('|');
    final domain = credParts[0];
    final modelname = credParts[1];
    final apiversion = credParts[2];
    final apiKey = credParts[3];

    final String apiUrl =
        "https://$domain.openai.azure.com/openai/deployments/$modelname/chat/completions?api-version=$apiversion";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "api-key": apiKey,
        },
        body: jsonEncode({
          "messages": [
            {"role": "system", "content": systemPrompt},
            if (input.isNotEmpty)
              {"role": "user", "content": input}
            else
              {"role": "user", "content": "Generate"}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["choices"]?[0]["message"]?["content"]?.trim();
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }


*/