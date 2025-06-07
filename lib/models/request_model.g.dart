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
      genericRequestModel: json['genericRequestModel'] == null
          ? null
          : GenericRequestModel.fromJson(
              Map<String, dynamic>.from(json['genericRequestModel'] as Map)),
      genericResponseModel: json['genericResponseModel'] == null
          ? null
          : GenericResponseModel.fromJson(
              Map<String, dynamic>.from(json['genericResponseModel'] as Map)),
    );

Map<String, dynamic> _$$RequestModelImplToJson(_$RequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'apiType': _$APITypeEnumMap[instance.apiType]!,
      'name': instance.name,
      'description': instance.description,
      'responseStatus': instance.responseStatus,
      'message': instance.message,
      'genericRequestModel': instance.genericRequestModel?.toJson(),
      'genericResponseModel': instance.genericResponseModel?.toJson(),
    };

const _$APITypeEnumMap = {
  APIType.rest: 'rest',
  APIType.graphql: 'graphql',
  APIType.ai: 'ai',
};
