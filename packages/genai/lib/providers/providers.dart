import 'anthropic/anthropic.dart';
import 'anthropic/models.dart';
import 'azureopenai/azureopenai.dart';
import 'azureopenai/models.dart';
import 'common.dart';
import 'gemini/gemini.dart';
import 'gemini/models.dart';
import 'ollama/models.dart';
import 'ollama/ollama.dart';
import 'openai/models.dart';
import 'openai/openai.dart';

enum LLMProvider {
  gemini('Gemini'),
  openai('OpenAI'),
  anthropic('Anthropic'),
  ollama('Ollama'),
  azureopenai('Azure OpenAI');

  const LLMProvider(this.displayName);

  final String displayName;

  (List<LLMModel>, ModelController) get models {
    switch (this) {
      case LLMProvider.ollama:
        return (OllamaModel.values, OllamaModelController.instance);
      case LLMProvider.gemini:
        return (GeminiModel.values, GeminiModelController.instance);
      case LLMProvider.azureopenai:
        return (AzureOpenAIModel.values, AzureOpenAIModelController.instance);
      case LLMProvider.openai:
        return (OpenAIModel.values, OpenAIModelController.instance);
      case LLMProvider.anthropic:
        return (AnthropicModel.values, AnthropicModelController.instance);
    }
  }

  static LLMProvider fromJSON(Map json) {
    return LLMProvider.fromName(json['llm_provider']);
  }

  static Map toJSON(LLMProvider p) {
    return {'llm_provider': p.name};
  }

  static LLMProvider? fromJSONNullable(Map? json) {
    if (json == null) return null;
    return LLMProvider.fromName(json['llm_provider']);
  }

  static Map? toJSONNullable(LLMProvider? p) {
    if (p == null) return null;
    return {'llm_provider': p.name};
  }

  LLMModel getLLMByIdentifier(String identifier) {
    switch (this) {
      case LLMProvider.ollama:
        return OllamaModel.fromIdentifier(identifier);
      case LLMProvider.gemini:
        return GeminiModel.fromIdentifier(identifier);
      case LLMProvider.azureopenai:
        return AzureOpenAIModel.fromIdentifier(identifier);
      case LLMProvider.openai:
        return OpenAIModel.fromIdentifier(identifier);
      case LLMProvider.anthropic:
        return AnthropicModel.fromIdentifier(identifier);
    }
  }

  static LLMProvider fromName(String name) {
    return LLMProvider.values.firstWhere(
      (model) => model.name == name,
      orElse: () => throw ArgumentError('INVALID LLM PROVIDER: $name'),
    );
  }
}
