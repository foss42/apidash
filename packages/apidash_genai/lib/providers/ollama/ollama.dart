import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/llm_input_payload.dart';
import 'package:apidash_genai/llm_request.dart';
import 'package:apidash_genai/providers/common.dart';

class OllamaModelController extends ModelController {
  @override
  LLMInputPayload get inputPayload => LLMInputPayload(
    endpoint: 'http://localhost:11434/v1/chat/completions',
    credential: '',
    systemPrompt: '',
    userPrompt: '',
    configMap: {
      LLMModelConfigurationName.temperature.name:
          defaultLLMConfigurations[LLMModelConfigurationName.temperature]!,
      LLMModelConfigurationName.top_p.name:
          defaultLLMConfigurations[LLMModelConfigurationName.temperature]!,
    },
  ).clone();

  @override
  LLMRequestDetails createRequest(
    LLMModel model,
    LLMInputPayload inputPayload,
  ) {
    return LLMRequestDetails(
      endpoint: inputPayload.endpoint,
      headers: {},
      method: 'POST',
      body: {
        "model": model.identifier,
        "messages": [
          {"role": "system", "content": inputPayload.systemPrompt},
          {"role": "user", "content": inputPayload.userPrompt},
        ],
        "temperature":
            inputPayload
                .configMap[LLMModelConfigurationName.temperature.name]
                ?.configValue
                .value
                ?.$2 ??
            0.5,
        "top_p":
            inputPayload
                .configMap[LLMModelConfigurationName.top_p.name]
                ?.configValue
                .value
                ?.$2 ??
            0.95,
      },
    );
  }

  @override
  String? outputFormatter(Map x) {
    return x['choices']?[0]['message']?['content'];
  }
}
