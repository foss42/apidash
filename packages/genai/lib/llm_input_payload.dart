import 'llm_config.dart';

class LLMInputPayload {
  String endpoint;
  String credential;
  String systemPrompt;
  String userPrompt;
  Map<String, LLMModelConfiguration> configMap;

  LLMInputPayload({
    required this.endpoint,
    required this.credential,
    required this.systemPrompt,
    required this.userPrompt,
    required this.configMap,
  });

  LLMInputPayload clone() {
    Map<String, LLMModelConfiguration> cmap = {};
    for (final k in configMap.keys) {
      cmap[k] = configMap[k]!.clone();
    }
    return LLMInputPayload(
      endpoint: endpoint,
      credential: credential,
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      configMap: cmap,
    );
  }

  static Map toJSON(LLMInputPayload payload) {
    Map cmap = {};
    for (final e in payload.configMap.entries) {
      cmap[e.key] = e.value.toJson();
    }
    return {
      'endpoint': payload.endpoint,
      'credential': payload.credential,
      'system_prompt': payload.systemPrompt,
      'user_prompt': payload.userPrompt,
      'config_map': cmap,
    };
  }

  static LLMInputPayload fromJSON(Map json) {
    Map<String, LLMModelConfiguration> cmap = {};
    for (final k in json['config_map'].keys) {
      cmap[k] = LLMModelConfiguration.fromJson(json['config_map'][k]);
    }
    return LLMInputPayload(
      endpoint: json['endpoint'],
      credential: json['credential'],
      systemPrompt: json['system_prompt'],
      userPrompt: json['user_prompt'],
      configMap: cmap,
    );
  }
}
