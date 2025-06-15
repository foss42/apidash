import '../../llm_config.dart';
import '../../llm_input_payload.dart';
import '../../llm_request.dart';
import '../../providers/common.dart';

class AnthropicModelController extends ModelController {
  static final instance = AnthropicModelController();
  @override
  LLMInputPayload get inputPayload => LLMInputPayload(
    endpoint: 'https://api.anthropic.com/v1/messages',
    credential: '',
    systemPrompt: '',
    userPrompt: '',
    configMap: {
      LLMConfigName.temperature.name:
          defaultLLMConfigurations[LLMConfigName.temperature]!,
      LLMConfigName.top_p.name: defaultLLMConfigurations[LLMConfigName.top_p]!,
    },
  ).clone();

  @override
  LLMRequestDetails createRequest(
    LLMModel model,
    LLMInputPayload inputPayload, {
    bool stream = false,
  }) {
    return LLMRequestDetails(
      endpoint: inputPayload.endpoint,
      headers: {
        'anthropic-version': '2023-06-01',
        'Authorization': 'Bearer ${inputPayload.credential}',
      },
      method: 'POST',
      body: {
        "model": model.identifier,
        if (stream) ...{'stream': true},
        "messages": [
          {"role": "system", "content": inputPayload.systemPrompt},
          {"role": "user", "content": inputPayload.userPrompt},
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
    return x['content']?[0]['text'];
  }

  @override
  String? streamOutputFormatter(Map x) {
    return x['text'];
  }
}
