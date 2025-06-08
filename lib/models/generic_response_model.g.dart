// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GenericResponseModelImpl _$$GenericResponseModelImplFromJson(Map json) =>
    _$GenericResponseModelImpl(
      aiResponseModel: json['aiResponseModel'] == null
          ? null
          : AIResponseModel.fromJson(
              Map<String, Object?>.from(json['aiResponseModel'] as Map)),
      httpResponseModel: json['httpResponseModel'] == null
          ? null
          : HttpResponseModel.fromJson(
              Map<String, Object?>.from(json['httpResponseModel'] as Map)),
    );

Map<String, dynamic> _$$GenericResponseModelImplToJson(
        _$GenericResponseModelImpl instance) =>
    <String, dynamic>{
      'aiResponseModel': instance.aiResponseModel?.toJson(),
      'httpResponseModel': instance.httpResponseModel?.toJson(),
    };
