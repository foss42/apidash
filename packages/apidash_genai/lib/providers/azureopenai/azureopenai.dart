import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/llm_input_payload.dart';
import 'package:apidash_genai/llm_request.dart';
import 'package:apidash_genai/providers/common.dart';

class AzureOpenAIModelController extends ModelController {
  @override
  LLMInputPayload get inputPayload => LLMInputPayload(
    endpoint: '', //TO BE FILLED BY USER
    credential: '',
    systemPrompt: '',
    userPrompt: '',
    configMap: {
      LLMConfigName.temperature.name:
          defaultLLMConfigurations[LLMConfigName.temperature]!,
      LLMConfigName.top_p.name:
          defaultLLMConfigurations[LLMConfigName.temperature]!,
    },
  ).clone();

  @override
  LLMRequestDetails createRequest(
    LLMModel model,
    LLMInputPayload inputPayload,
  ) {
    if (inputPayload.endpoint.isEmpty) {
      throw Exception('MODEL ENDPOINT IS EMPTY');
    }
    return LLMRequestDetails(
      endpoint: inputPayload.endpoint,
      headers: {'api-key': inputPayload.credential},
      method: 'POST',
      body: {
        "messages": [
          {"role": "system", "content": inputPayload.systemPrompt},
          if (inputPayload.userPrompt.isNotEmpty) ...{
            {"role": "user", "content": inputPayload.userPrompt},
          } else ...{
            {"role": "user", "content": "Generate"},
          },
        ],
        "temperature":
            inputPayload
                .configMap[LLMConfigName.temperature.name]
                ?.configValue
                .value
                ?.$2 ??
            0.5,
        "top_p":
            inputPayload
                .configMap[LLMConfigName.top_p.name]
                ?.configValue
                .value
                ?.$2 ??
            0.95,
        if (inputPayload.configMap[LLMConfigName.max_tokens.name] != null) ...{
          "max_tokens": inputPayload
              .configMap[LLMConfigName.max_tokens.name]!
              .configValue
              .value,
        },
      },
    );
  }

  @override
  String? outputFormatter(Map x) {
    return x["choices"]?[0]["message"]?["content"]?.trim();
  }
}
