import 'package:apidash/models/llm_models/google/gemini_20_flash.dart';
import 'package:apidash/models/llm_models/llm_model.dart';
import 'package:apidash/models/llm_models/ollama/llama3.dart';

// Exports
export 'package:apidash/models/llm_models/google/gemini_20_flash.dart';
export 'package:apidash/models/llm_models/ollama/llama3.dart';

Map<String, (LLMModel instance, LLMModel Function())> availableModels = {
  Gemini20FlashModel.instance.modelIdentifier: (
    Gemini20FlashModel.instance,
    () => Gemini20FlashModel()
  ),
  LLama3LocalModel.instance.modelIdentifier: (
    LLama3LocalModel.instance,
    () => LLama3LocalModel()
  ),
};

LLMModel? getLLMModelFromID(String modelID, [Map? configMap]) {
  for (final entry in availableModels.entries) {
    if (entry.key == modelID) {
      final m = entry.value.$2();
      if (configMap != null) {
        m.loadConfigurations(configMap);
      }
      return m;
    }
  }
  return null;
}
