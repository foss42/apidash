// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvailableModelsImpl _$$AvailableModelsImplFromJson(
  Map<String, dynamic> json,
) => _$AvailableModelsImpl(
  version: (json['version'] as num).toDouble(),
  modelProviders: (json['model_providers'] as List<dynamic>)
      .map((e) => AIModelProvider.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$AvailableModelsImplToJson(
  _$AvailableModelsImpl instance,
) => <String, dynamic>{
  'version': instance.version,
  'model_providers': instance.modelProviders,
};

_$AIModelProviderImpl _$$AIModelProviderImplFromJson(
  Map<String, dynamic> json,
) => _$AIModelProviderImpl(
  providerId: $enumDecodeNullable(
    _$ModelAPIProviderEnumMap,
    json['provider_id'],
  ),
  providerName: json['provider_name'] as String?,
  sourceUrl: json['source_url'] as String?,
  models: (json['models'] as List<dynamic>?)
      ?.map((e) => Model.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$AIModelProviderImplToJson(
  _$AIModelProviderImpl instance,
) => <String, dynamic>{
  'provider_id': _$ModelAPIProviderEnumMap[instance.providerId],
  'provider_name': instance.providerName,
  'source_url': instance.sourceUrl,
  'models': instance.models,
};

const _$ModelAPIProviderEnumMap = {
  ModelAPIProvider.openai: 'openai',
  ModelAPIProvider.anthropic: 'anthropic',
  ModelAPIProvider.gemini: 'gemini',
  ModelAPIProvider.azureopenai: 'azureopenai',
  ModelAPIProvider.ollama: 'ollama',
  ModelAPIProvider.openaiCompatible: 'other',
};

_$ModelImpl _$$ModelImplFromJson(Map<String, dynamic> json) =>
    _$ModelImpl(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$$ModelImplToJson(_$ModelImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
