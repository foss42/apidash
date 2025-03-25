import 'package:apidash/dashbot/features/debug.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../consts.dart';
import '../features/explain.dart';
import 'package:apidash/models/request_model.dart';


class DashBotService {
  late final OllamaClient _ollamaClient;
  late final OpenAIClient _openAiClient;
  late final ExplainFeature _explainFeature;
  late final DebugFeature _debugFeature;

  LLMProvider _selectedModel = LLMProvider.ollama;

  DashBotService()
      : _ollamaClient = OllamaClient(baseUrl: 'http://127.0.0.1:11434/api'),
        //TODO: Add API key to .env file
      _openAiClient = OpenAIClient(apiKey: "your_openai_api_key") {
    _explainFeature = ExplainFeature(this);
    _debugFeature = DebugFeature(this);
  }

  void setModel(LLMProvider model) {
    _selectedModel = model;
  }

  Future<String> generateResponse(String prompt) async {
    try {
      switch (_selectedModel) {
        case LLMProvider.gemini:
          final response = await Gemini.instance.chat([
            Content(parts: [Part.text(prompt)], role: 'user')
          ]);
          return response?.output ?? "Error: No response from Gemini.";

        case LLMProvider.ollama:
          final response = await _ollamaClient.generateCompletion(
            request: GenerateCompletionRequest(model: 'llama3.2:3b', prompt: prompt),
          );
          return response.response.toString();

        case LLMProvider.openai:
          final response = await _openAiClient.createChatCompletion(
            request: CreateChatCompletionRequest(
              model: ChatCompletionModel.modelId('gpt-4o'),
              messages: [
                ChatCompletionMessage.user(
                  content: ChatCompletionUserMessageContent.string(prompt),
                ),
              ],
              temperature: 0,
            ),
          );
          return response.choices?.first.message?.content ?? "Error: No response from OpenAI.";
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