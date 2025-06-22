import '../llm_config.dart';
import '../llm_input_payload.dart';
import '../llm_model.dart';
import '../llm_request.dart';

class AzureOpenAIModelController extends ModelController {
  static final instance = AzureOpenAIModelController();
  @override
  LLMInputPayload get inputPayload => LLMInputPayload(
    endpoint: '', //TO BE FILLED BY USER
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
    if (inputPayload.endpoint.isEmpty) {
      throw Exception('MODEL ENDPOINT IS EMPTY');
    }
    return LLMRequestDetails(
      endpoint: inputPayload.endpoint,
      headers: {'api-key': inputPayload.credential},
      method: 'POST',
      body: {
        if (stream) ...{'stream': true},
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

  @override
  String? streamOutputFormatter(Map x) {
    return x["choices"]?[0]["delta"]?["content"];
  }
}
