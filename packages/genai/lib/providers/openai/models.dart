// ignore_for_file: constant_identifier_names
import 'package:genai/providers/common.dart';
import 'package:genai/providers/providers.dart';

enum OpenAIModel implements LLMModel {
  gpt_4o('gpt-4o', 'GPT-4o', LLMProvider.openai),
  gpt_4('gpt-4', 'GPT-4', LLMProvider.openai),
  gpt_4o_mini('gpt-4o-mini', 'GPT-4o Mini', LLMProvider.openai),
  gpt_4_turbo('gpt-4-turbo', 'GPT-4 Turbo', LLMProvider.openai),
  gpt_41('gpt-4.1', 'GPT-4.1', LLMProvider.openai),
  gpt_41_mini('gpt-4.1-mini', 'GPT-4.1 Mini', LLMProvider.openai),
  gpt_41_nano('gpt-4.1-nano', 'GPT-4.1 Nano', LLMProvider.openai),
  gpt_o1('o1', 'o1', LLMProvider.openai),
  gpt_o3('o3', 'o3', LLMProvider.openai),
  gpt_o3_mini('o3-mini', 'o3 Mini', LLMProvider.openai),
  gpt_35_turbo('gpt-3.5-turbo', 'GPT-3.5 Turbo', LLMProvider.openai);

  //////////////////////////////////////////////////////////
  const OpenAIModel(this.identifier, this.modelName, this.provider);
  @override
  final String identifier;
  @override
  final String modelName;
  @override
  final LLMProvider provider;

  static OpenAIModel fromIdentifier(String id) {
    return OpenAIModel.values.firstWhere(
      (model) => model.identifier == id,
      orElse: () => throw ArgumentError('INVALID OPENAI MODEL: $id'),
    );
  }
}
