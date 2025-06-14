// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestModelImpl _$$RequestModelImplFromJson(Map json) => _$RequestModelImpl(
      id: json['id'] as String,
      apiType: $enumDecodeNullable(_$APITypeEnumMap, json['apiType']) ??
          APIType.rest,
      name: json['name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      requestTabIndex: json['requestTabIndex'] ?? 0,
      responseStatus: (json['responseStatus'] as num?)?.toInt(),
      message: json['message'] as String?,
      isWorking: json['isWorking'] as bool? ?? false,
      sendingTime: json['sendingTime'] == null
          ? null
          : DateTime.parse(json['sendingTime'] as String),
      httpRequestModel: json['httpRequestModel'] == null
          ? null
          : HttpRequestModel.fromJson(
              Map<String, Object?>.from(json['httpRequestModel'] as Map)),
      httpResponseModel: json['httpResponseModel'] == null
          ? null
          : HttpResponseModel.fromJson(
              Map<String, Object?>.from(json['httpResponseModel'] as Map)),
      aiRequestModel: json['aiRequestModel'] == null
          ? null
          : AIRequestModel.fromJson(
              Map<String, Object?>.from(json['aiRequestModel'] as Map)),
      aiResponseModel: json['aiResponseModel'] == null
          ? null
          : AIResponseModel.fromJson(
              Map<String, Object?>.from(json['aiResponseModel'] as Map)),
    );

Map<String, dynamic> _$$RequestModelImplToJson(_$RequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'apiType': _$APITypeEnumMap[instance.apiType]!,
      'name': instance.name,
      'description': instance.description,
      'responseStatus': instance.responseStatus,
      'message': instance.message,
      'httpRequestModel': instance.httpRequestModel?.toJson(),
      'httpResponseModel': instance.httpResponseModel?.toJson(),
      'aiRequestModel': instance.aiRequestModel?.toJson(),
      'aiResponseModel': instance.aiResponseModel?.toJson(),
    };

const _$APITypeEnumMap = {
  APIType.rest: 'rest',
  APIType.graphql: 'graphql',
  APIType.ai: 'ai',
};
