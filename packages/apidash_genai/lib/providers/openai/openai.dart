import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/llm_input_payload.dart';
import 'package:apidash_genai/llm_request.dart';
import 'package:apidash_genai/providers/common.dart';

class OpenAIModelController extends ModelController {
  @override
  LLMInputPayload get inputPayload => LLMInputPayload(
    endpoint: 'https://api.openai.com/v1/chat/completions',
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
    return LLMRequestDetails(
      endpoint: inputPayload.endpoint,
      headers: {'Authorization': "Bearer ${inputPayload.credential}"},
      method: 'POST',
      body: {
        'model': model.identifier,
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
