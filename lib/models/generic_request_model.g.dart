// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GenericRequestModelImpl _$$GenericRequestModelImplFromJson(Map json) =>
    _$GenericRequestModelImpl(
      aiRequestModel: json['aiRequestModel'] == null
          ? null
          : AIRequestModel.fromJson(
              Map<String, Object?>.from(json['aiRequestModel'] as Map)),
      httpRequestModel: json['httpRequestModel'] == null
          ? null
          : HttpRequestModel.fromJson(
              Map<String, Object?>.from(json['httpRequestModel'] as Map)),
    );

Map<String, dynamic> _$$GenericRequestModelImplToJson(
        _$GenericRequestModelImpl instance) =>
    <String, dynamic>{
      'aiRequestModel': instance.aiRequestModel?.toJson(),
      'httpRequestModel': instance.httpRequestModel?.toJson(),
    };
