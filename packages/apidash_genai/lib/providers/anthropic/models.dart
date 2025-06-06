import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/providers/common.dart';
import 'package:apidash_genai/providers/providers.dart';

enum AnthropicModel implements LLMModel {
  claude3opus('claude-3-opus-latest', 'Claude 3 Opus', LLMProvider.anthropic),
  claude3sonnet(
    'claude-3-sonnet-latest',
    'Claude 3 Sonnet',
    LLMProvider.anthropic,
  ),
  claude3haiku(
    'claude-3-haiku-latest',
    'Claude 3 Haiku',
    LLMProvider.anthropic,
  ),
  claude35_haiku(
    'claude-3-5-haiku-latest',
    'Claude 3.5 Haiku',
    LLMProvider.anthropic,
  ),
  claude35_sonnet(
    'claude-3-5-sonnet-latest',
    'Claude 3.5 Sonnet',
    LLMProvider.anthropic,
  );

  //////////////////////////////////////////////////////////
  const AnthropicModel(this.identifier, this.modelName, this.provider);
  @override
  final String identifier;

  @override
  final String modelName;

  @override
  final LLMProvider provider;
}

AnthropicModel getAnthropicModelFromIdentifier(String id) {
  return AnthropicModel.values.firstWhere(
    (model) => model.identifier == id,
    orElse: () => throw ArgumentError('INVALID ANTHROPIC MODEL: $id'),
  );
}
