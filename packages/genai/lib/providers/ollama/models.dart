import '../../providers/common.dart';
import '../providers.dart';

enum OllamaModel implements LLMModel {
  llama3('llama3', 'Llama 3', LLMProvider.ollama),
  mistral('mistral', 'Mistral', LLMProvider.ollama),
  gemma3('gemma3', 'Gemma 3', LLMProvider.ollama),
  phi('phi', 'Phi', LLMProvider.ollama);

  //////////////////////////////////////////////////////////
  const OllamaModel(this.identifier, this.modelName, this.provider);
  @override
  final String identifier;

  @override
  final String modelName;

  @override
  final LLMProvider provider;

  static OllamaModel fromIdentifier(String id) {
    return OllamaModel.values.firstWhere(
      (model) => model.identifier == id,
      orElse: () => throw ArgumentError('INVALID OLLAMA MODEL: $id'),
    );
  }
}
