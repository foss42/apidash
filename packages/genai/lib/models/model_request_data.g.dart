// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModelRequestDataImpl _$$ModelRequestDataImplFromJson(Map json) =>
    _$ModelRequestDataImpl(
      url: json['url'] as String? ?? "",
      model: json['model'] as String? ?? "",
      apiKey: json['apiKey'] as String? ?? "",
      systemPrompt: json['system_prompt'] as String? ?? "",
      userPrompt: json['user_prompt'] as String? ?? "",
      modelConfigs:
          (json['model_configs'] as List<dynamic>?)
              ?.map((e) => ModelConfig.fromJson(e as Map))
              .toList() ??
          const <ModelConfig>[],
      stream: json['stream'] as bool? ?? null,
    );

Map<String, dynamic> _$$ModelRequestDataImplToJson(
  _$ModelRequestDataImpl instance,
) => <String, dynamic>{
  'url': instance.url,
  'model': instance.model,
  'apiKey': instance.apiKey,
  'system_prompt': instance.systemPrompt,
  'user_prompt': instance.userPrompt,
  'model_configs': instance.modelConfigs.map((e) => e.toJson()).toList(),
  'stream': instance.stream,
};
