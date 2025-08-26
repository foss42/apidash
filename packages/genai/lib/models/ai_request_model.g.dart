// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIRequestModelImpl _$$AIRequestModelImplFromJson(Map json) =>
    _$AIRequestModelImpl(
      modelProvider: $enumDecodeNullable(
        _$ModelAPIProviderEnumMap,
        json['modelProvider'],
      ),
      modelRequestData: json['modelRequestData'] == null
          ? null
          : ModelRequestData.fromJson(
              Map<String, Object?>.from(json['modelRequestData'] as Map),
            ),
    );

Map<String, dynamic> _$$AIRequestModelImplToJson(
  _$AIRequestModelImpl instance,
) => <String, dynamic>{
  'modelProvider': _$ModelAPIProviderEnumMap[instance.modelProvider],
  'modelRequestData': instance.modelRequestData?.toJson(),
};

const _$ModelAPIProviderEnumMap = {
  ModelAPIProvider.openai: 'openai',
  ModelAPIProvider.anthropic: 'anthropic',
  ModelAPIProvider.gemini: 'gemini',
  ModelAPIProvider.azureopenai: 'azureopenai',
  ModelAPIProvider.ollama: 'ollama',
};
