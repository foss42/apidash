import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/llm_input_payload.dart';
import 'package:apidash_genai/llm_request.dart';
import 'package:apidash_genai/providers/common.dart';

class GeminiModelController extends ModelController {
  static final instance = GeminiModelController();
  @override
  LLMInputPayload get inputPayload => LLMInputPayload(
    endpoint: 'https://generativelanguage.googleapis.com/v1beta/models',
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
    String endpoint = inputPayload.endpoint;
    endpoint =
        "$endpoint/${model.identifier}:generateContent?key=${inputPayload.credential}";
    if (stream) {
      endpoint = endpoint.replaceAll(
        'generateContent?',
        'streamGenerateContent?alt=sse&',
      );
    }
    return LLMRequestDetails(
      endpoint: endpoint,
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
                  .configMap[LLMConfigName.temperature.name]
                  ?.configValue
                  .value
                  ?.$2 ??
              0.5,
          "topP":
              inputPayload
                  .configMap[LLMConfigName.top_p.name]
                  ?.configValue
                  .value
                  ?.$2 ??
              0.95,
          if (inputPayload.configMap[LLMConfigName.max_tokens.name] !=
              null) ...{
            "maxOutputTokens": inputPayload
                .configMap[LLMConfigName.max_tokens.name]!
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

  @override
  String? streamOutputFormatter(Map x) {
    return x['candidates']?[0]?['content']?['parts']?[0]?['text'];
  }
}
