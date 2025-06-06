// ignore_for_file: constant_identifier_names

import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/providers/common.dart';
import 'package:apidash_genai/providers/gemini/gemini.dart';
import 'package:apidash_genai/providers/providers.dart';

enum GeminiModel implements LLMModel {
  gemini_15_pro('gemini-1.5-pro', 'Gemini 1.5 Pro', LLMProvider.gemini),
  gemini_15_flash('gemini-1.5-flash', 'Gemini 1.5 Flash', LLMProvider.gemini),
  gemini_15_flash_8b(
    'gemini-1.5-flash-8b',
    'Gemini 1.5 Flash 8B',
    LLMProvider.gemini,
  ),
  gemini_20_flash('gemini-2.0-flash', 'Gemini 2.0 Flash', LLMProvider.gemini),
  gemini_20_flash_lite(
    'gemini-2.0-flash-lite',
    'Gemini 2.0 Flash Lite',
    LLMProvider.gemini,
  ),
  gemini_25_flash_preview_0520(
    'gemini-2.5-flash-preview-05-20',
    'Gemini 2.5 Flash Preview 0520',
    LLMProvider.gemini,
  );

  //////////////////////////////////////////////////////////
  const GeminiModel(this.identifier, this.modelName, this.provider);
  @override
  final String identifier;
  @override
  final String modelName;
  @override
  final LLMProvider provider;
}

GeminiModel getGeminiModelFromIdentifier(String id) {
  return GeminiModel.values.firstWhere(
    (model) => model.identifier == id,
    orElse: () => throw ArgumentError('INVALID GEMINI MODEL: $id'),
  );
}
