import 'package:apidash/dashbot/features/debug.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../consts.dart';
import '../features/explain.dart';
import 'package:apidash/models/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dashbot_providers.dart';
import '../providers/llm_provider.dart';

final llmConfigProvider = StateNotifierProvider<LLMConfigNotifier, Map<LLMProvider, LLMConfig>>((ref) {
  return LLMConfigNotifier();
});

class LLMConfigNotifier extends StateNotifier<Map<LLMProvider, LLMConfig>> {
  LLMConfigNotifier()
      : super({
    LLMProvider.ollama: LLMConfig(apiUrl: "http://127.0.0.1:11434/api", model: "mistral"),
    LLMProvider.gemini: LLMConfig(apiKey: "gemini_api_key", model: "gemini-1.5"),
    LLMProvider.openai: LLMConfig(apiKey: "openAI_api_key", model: "gpt-4-turbo"),
  });

  void updateConfig(LLMProvider provider, LLMConfig newConfig) {
    state = {...state, provider: newConfig};
  }
}

final dashBotServiceProvider = Provider((ref) => DashBotService(ref, LLMProvider.ollama));

class DashBotService {
  late OllamaClient _ollamaClient;
  late OpenAIClient _openAiClient;
  late Gemini _geminiClient;
  late ExplainFeature _explainFeature;
  late DebugFeature _debugFeature;
  final Ref _ref;


  DashBotService(this._ref, LLMProvider selectedModel) {
    _initializeClients();
    _explainFeature = ExplainFeature(this);
    _debugFeature = DebugFeature(this);
  }

  void _initializeClients() {
    final config = _ref.read(llmConfigProvider);

    _ollamaClient = OllamaClient(baseUrl: config[LLMProvider.ollama]!.apiUrl,);
    _openAiClient = OpenAIClient(apiKey: config[LLMProvider.openai]!.apiKey ?? "",);
    _geminiClient = Gemini.init(apiKey: config[LLMProvider.gemini]!.apiKey ?? "", );
  }

  Future<String> generateResponse(String prompt) async {
    try {
      final selectedProvider = _ref.read(selectedLLMProvider);
      final config = _ref.read(llmConfigProvider)[selectedProvider]!;

      switch (selectedProvider) {
        case LLMProvider.gemini:
          final response = await Gemini.instance.chat(
            modelName: config.model,
              [
            Content(parts: [Part.text(prompt)], role: 'user',),
          ]);
          return response?.output ?? "Error: No response from Gemini.";

        case LLMProvider.openai:
          final response = await _openAiClient.createChatCompletion(
            request: CreateChatCompletionRequest(
              model: ChatCompletionModel.modelId(config.model),
              messages: [
                ChatCompletionMessage.user(
                  content: ChatCompletionUserMessageContent.string(prompt),
                ),
              ],
              temperature: config.temperature ?? 0.7,
            ),
          );
          return response.choices.first.message.content ?? "Error: No response from OpenAI.";

        case LLMProvider.ollama:
          final response = await _ollamaClient.generateCompletion(
            request: GenerateCompletionRequest(model: config.model, prompt: prompt),
          );
          return response.response.toString();
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }


  Future<String> handleRequest(
      String input, RequestModel? requestModel, dynamic responseModel) async {
    if (input == "Explain API") {
      return _explainFeature.explainLatestApi(
          requestModel: requestModel, responseModel: responseModel);
    } else if (input == "Debug API") {
      return _debugFeature.debugApi(
          requestModel: requestModel, responseModel: responseModel);
    }

    return generateResponse(input);
  }
}
