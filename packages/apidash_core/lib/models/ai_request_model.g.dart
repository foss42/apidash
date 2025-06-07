// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIRequestModelImpl _$$AIRequestModelImplFromJson(Map json) =>
    _$AIRequestModelImpl(
      payload: LLMInputPayload.fromJSON(json['payload'] as Map),
    );

Map<String, dynamic> _$$AIRequestModelImplToJson(
        _$AIRequestModelImpl instance) =>
    <String, dynamic>{
      'payload': LLMInputPayload.toJSON(instance.payload),
    };
