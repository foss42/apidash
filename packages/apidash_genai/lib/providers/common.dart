import 'package:apidash_genai/llm_config.dart';

abstract class LLMModel {
  const LLMModel(this.identifier, this.outputFormatter);
  final String identifier;
  final LLMOutputFormatter outputFormatter;
}
