import 'package:apidash_genai/providers/anthropic/anthropic.dart';
import 'package:apidash_genai/providers/anthropic/models.dart';
import 'package:apidash_genai/providers/azureopenai/azureopenai.dart';
import 'package:apidash_genai/providers/azureopenai/models.dart';
import 'package:apidash_genai/providers/common.dart';
import 'package:apidash_genai/providers/gemini/gemini.dart';
import 'package:apidash_genai/providers/gemini/models.dart';
import 'package:apidash_genai/providers/ollama/models.dart';
import 'package:apidash_genai/providers/ollama/ollama.dart';
import 'package:apidash_genai/providers/openai/models.dart';
import 'package:apidash_genai/providers/openai/openai.dart';

enum LLMProviderType { local, remote }

enum LLMProvider {
  gemini('Gemini'),
  openai('OpenAI'),
  anthropic('Anthropic'),
  ollama('Ollama'),
  azureopenai('Azure OpenAI');

  const LLMProvider(this.displayName);
  final String displayName;
}

LLMProvider getLLMProviderByName(String name) {
  return LLMProvider.values.firstWhere(
    (model) => model.name == name,
    orElse: () => throw ArgumentError('INVALID LLM PROVIDER: $name'),
  );
}

List<LLMProvider> getLLMProvidersByType(LLMProviderType pT) {
  if (pT == LLMProviderType.local) {
    return [LLMProvider.ollama];
  }
  return LLMProvider.values.toSet().difference({LLMProvider.ollama}).toList();
}

List<LLMModel> getLLMModelsByProvider(LLMProvider p) {
  switch (p) {
    case LLMProvider.ollama:
      return OllamaModel.values;
    case LLMProvider.gemini:
      return GeminiModel.values;
    case LLMProvider.azureopenai:
      return AzureOpenAIModel.values;
    case LLMProvider.openai:
      return OpenAIModel.values;
    case LLMProvider.anthropic:
      return AnthropicModel.values;
  }
}

ModelController getLLMModelControllerByProvider(LLMProvider p) {
  switch (p) {
    case LLMProvider.ollama:
      return OllamaModelController();
    case LLMProvider.gemini:
      return GeminiModelController();
    case LLMProvider.azureopenai:
      return AzureOpenAIModelController();
    case LLMProvider.openai:
      return OpenAIModelController();
    case LLMProvider.anthropic:
      return AnthropicModelController();
  }
}
