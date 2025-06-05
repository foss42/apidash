import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/providers/common.dart';
import 'package:apidash_genai/providers/output_formatters.dart';

enum OllamaModel implements LLMModel {
  llama3('llama3', LLMOutputFormatters.genericOllamaOutputFormatter),
  mistral('mistral', LLMOutputFormatters.genericOllamaOutputFormatter),
  gemma3('gemma3', LLMOutputFormatters.genericOllamaOutputFormatter),
  phi('phi', LLMOutputFormatters.genericOllamaOutputFormatter);

  //////////////////////////////////////////////////////////
  const OllamaModel(this.identifier, this.outputFormatter);
  @override
  final String identifier;
  @override
  final LLMOutputFormatter outputFormatter;
}

OllamaModel getOllamaModelFromIdentifier(String id) {
  return OllamaModel.values.firstWhere(
    (model) => model.identifier == id,
    orElse: () => throw ArgumentError('INVALID OLLAMA MODEL: $id'),
  );
}
