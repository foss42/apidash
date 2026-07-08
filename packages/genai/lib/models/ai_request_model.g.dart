// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AIRequestModel _$AIRequestModelFromJson(Map json) => _AIRequestModel(
  modelApiProvider: $enumDecodeNullable(
    _$ModelAPIProviderEnumMap,
    json['modelApiProvider'],
  ),
  url: json['url'] as String? ?? "",
  model: json['model'] as String? ?? null,
  apiKey: json['apiKey'] as String? ?? null,
  systemPrompt: json['system_prompt'] as String? ?? "",
  userPrompt: json['user_prompt'] as String? ?? "",
  modelConfigs:
      (json['model_configs'] as List<dynamic>?)
          ?.map((e) => ModelConfig.fromJson(e as Map))
          .toList() ??
      const <ModelConfig>[],
  stream: json['stream'] as bool? ?? null,
);

Map<String, dynamic> _$AIRequestModelToJson(_AIRequestModel instance) =>
    <String, dynamic>{
      'modelApiProvider': _$ModelAPIProviderEnumMap[instance.modelApiProvider],
      'url': instance.url,
      'model': instance.model,
      'apiKey': instance.apiKey,
      'system_prompt': instance.systemPrompt,
      'user_prompt': instance.userPrompt,
      'model_configs': instance.modelConfigs.map((e) => e.toJson()).toList(),
      'stream': instance.stream,
    };

const _$ModelAPIProviderEnumMap = {
  ModelAPIProvider.openai: 'openai',
  ModelAPIProvider.anthropic: 'anthropic',
  ModelAPIProvider.gemini: 'gemini',
  ModelAPIProvider.azureopenai: 'azureopenai',
  ModelAPIProvider.ollama: 'ollama',
};
