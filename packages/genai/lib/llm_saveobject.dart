import 'package:genai/llm_config.dart';
import 'package:genai/providers/common.dart';
import 'package:genai/providers/providers.dart';

class LLMSaveObject {
  String endpoint;
  String credential;
  LLMProvider provider;
  LLMModel selectedLLM;
  Map<String, LLMModelConfiguration> configMap;

  LLMSaveObject({
    required this.endpoint,
    required this.credential,
    required this.configMap,
    required this.selectedLLM,
    required this.provider,
  });

  Map toJSON() {
    Map cmap = {};
    for (final e in configMap.entries) {
      cmap[e.key] = e.value.toJson();
    }
    return {
      'endpoint': endpoint,
      'credential': credential,
      'config_map': cmap,
      'selected_llm': selectedLLM.identifier,
      'provider': provider.name,
    };
  }

  static LLMSaveObject fromJSON(Map json) {
    Map<String, LLMModelConfiguration> cmap = {};
    for (final k in json['config_map'].keys) {
      cmap[k] = LLMModelConfiguration.fromJson(json['config_map'][k]);
    }
    final provider = LLMProvider.fromName(json['provider']);
    return LLMSaveObject(
      endpoint: json['endpoint'],
      credential: json['credential'],
      configMap: cmap,
      selectedLLM: provider.getLLMByIdentifier(json['selected_llm']),
      provider: provider,
    );
  }
}
