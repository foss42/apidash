import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/llm_input_payload.dart';
import 'package:apidash_genai/llm_request.dart';
import 'package:apidash_genai/providers/common.dart';

class GeminiModelController extends ModelController {
  @override
  LLMInputPayload get inputPayload => LLMInputPayload(
    endpoint: 'https://generativelanguage.googleapis.com/v1beta/models',
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
    String endpont = inputPayload.endpoint;
    endpont =
        "$endpont/${model.identifier}:generateContent?key=${inputPayload.credential}";
    return LLMRequestDetails(
      endpoint: endpont,
      headers: {},
      method: 'POST',
      body: {
        "model": model.identifier,
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": inputPayload.userPrompt},
            ],
          },
        ],
        "systemInstruction": {
          "role": "system",
          "parts": [
            {"text": inputPayload.systemPrompt},
          ],
        },
        "generationConfig": {
          "temperature":
              inputPayload
                  .configMap[LLMModelConfigurationName.temperature.name]
                  ?.configValue
                  .value
                  ?.$2 ??
              0.5,
          "topP":
              inputPayload
                  .configMap[LLMModelConfigurationName.top_p.name]
                  ?.configValue
                  .value
                  ?.$2 ??
              0.95,
          if (inputPayload.configMap[LLMModelConfigurationName
                  .max_tokens
                  .name] !=
              null) ...{
            "maxOutputTokens": inputPayload
                .configMap[LLMModelConfigurationName.max_tokens.name]!
                .configValue
                .value,
          },
        },
      },
    );
  }

  @override
  String? outputFormatter(Map x) {
    return x['candidates']?[0]?['content']?['parts']?[0]?['text'];
  }
}
