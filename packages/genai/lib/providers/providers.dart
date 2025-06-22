import '../llm_manager.dart';
import 'common.dart';
import 'ollama.dart';

enum LLMProvider {
  gemini('Gemini'),
  openai('OpenAI'),
  anthropic('Anthropic'),
  ollama('Ollama'),
  azureopenai('Azure OpenAI');

  const LLMProvider(this.displayName);

  final String displayName;

  List<LLMModel> get models {
    final avl = LLMManager.models[this.name.toLowerCase()];
    if (avl == null) return [];
    List<LLMModel> models = [];
    for (final x in avl) {
      models.add(LLMModel(x[0], x[1], this));
    }
    return models;
  }

  ModelController get modelController {
    switch (this) {
      case LLMProvider.ollama:
        return OllamaModelController.instance;
      case _:
        return OllamaModelController.instance;
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
    final m = this.models.where((e) => e.identifier == identifier).firstOrNull;
    if (m == null) {
      throw Exception('MODEL DOES NOT EXIST $identifier');
    }
    return m;
  }

  static LLMProvider fromName(String name) {
    return LLMProvider.values.firstWhere(
      (model) => model.name == name,
      orElse: () => throw ArgumentError('INVALID LLM PROVIDER: $name'),
    );
  }
}
