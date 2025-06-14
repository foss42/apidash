// ignore_for_file: constant_identifier_names

import 'package:genai/llm_config.dart';
import 'package:genai/providers/common.dart';
import 'package:genai/providers/gemini/gemini.dart';
import 'package:genai/providers/providers.dart';

enum AzureOpenAIModel implements LLMModel {
  custom('custom', 'Custom', LLMProvider.azureopenai);

  //////////////////////////////////////////////////////////
  const AzureOpenAIModel(this.identifier, this.modelName, this.provider);
  @override
  final String identifier;
  @override
  final String modelName;
  @override
  final LLMProvider provider;

  static AzureOpenAIModel fromIdentifier(String id) {
    return AzureOpenAIModel.values.firstWhere(
      (model) => model.identifier == id,
      orElse: () => throw ArgumentError('INVALID AZURE OPENAI MODEL: $id'),
    );
  }
}
