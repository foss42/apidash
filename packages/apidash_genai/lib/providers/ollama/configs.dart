import 'package:apidash_genai/llm_config.dart';
import 'package:apidash_genai/llm_input_payload.dart';

final BASE_OLLAMA_PAYLOAD = LLMInputPayload(
  endpoint: 'http://localhost:11434/v1/chat/completions',
  credential: '',
  systemPrompt: '',
  userPrompt: '',
  configMap: {
    LLMModelConfigurationName.temperature.name:
        defaultLLMConfigurations[LLMModelConfigurationName.temperature]!,
    LLMModelConfigurationName.top_p.name:
        defaultLLMConfigurations[LLMModelConfigurationName.temperature]!,
  },
);
