// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestModel _$RequestModelFromJson(Map json) => _RequestModel(
      id: json['id'] as String,
      apiType: $enumDecodeNullable(_$APITypeEnumMap, json['apiType']) ??
          APIType.rest,
      name: json['name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      requestTabIndex: json['requestTabIndex'] ?? 0,
      httpRequestModel: json['httpRequestModel'] == null
          ? null
          : HttpRequestModel.fromJson(
              Map<String, Object?>.from(json['httpRequestModel'] as Map)),
      responseStatus: (json['responseStatus'] as num?)?.toInt(),
      message: json['message'] as String?,
      httpResponseModel: json['httpResponseModel'] == null
          ? null
          : HttpResponseModel.fromJson(
              Map<String, Object?>.from(json['httpResponseModel'] as Map)),
      isWorking: json['isWorking'] as bool? ?? false,
      sendingTime: json['sendingTime'] == null
          ? null
          : DateTime.parse(json['sendingTime'] as String),
      isStreaming: json['isStreaming'] as bool? ?? false,
      preRequestScript: json['preRequestScript'] as String?,
      postRequestScript: json['postRequestScript'] as String?,
      aiRequestModel: json['aiRequestModel'] == null
          ? null
          : AIRequestModel.fromJson(
              Map<String, Object?>.from(json['aiRequestModel'] as Map)),
    );

Map<String, dynamic> _$RequestModelToJson(_RequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'apiType': _$APITypeEnumMap[instance.apiType]!,
      'name': instance.name,
      'description': instance.description,
      'httpRequestModel': instance.httpRequestModel?.toJson(),
      'responseStatus': instance.responseStatus,
      'message': instance.message,
      'httpResponseModel': instance.httpResponseModel?.toJson(),
      'preRequestScript': instance.preRequestScript,
      'postRequestScript': instance.postRequestScript,
      'aiRequestModel': instance.aiRequestModel?.toJson(),
    };

const _$APITypeEnumMap = {
  APIType.rest: 'rest',
  APIType.ai: 'ai',
  APIType.graphql: 'graphql',
};
