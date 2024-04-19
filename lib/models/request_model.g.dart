// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestModelImpl _$$RequestModelImplFromJson(Map json) => _$RequestModelImpl(
      id: json['id'] as String,
      name: json['name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      requestTabIndex: json['requestTabIndex'] ?? 0,
      httpRequestModel: json['httpRequestModel'] == null
          ? null
          : HttpRequestModel.fromJson(
              Map<String, Object?>.from(json['httpRequestModel'] as Map)),
      responseStatus: json['responseStatus'] as int?,
      message: json['message'] as String?,
      httpResponseModel: json['httpResponseModel'] == null
          ? null
          : HttpResponseModel.fromJson(
              Map<String, Object?>.from(json['httpResponseModel'] as Map)),
      isWorking: json['isWorking'] as bool? ?? false,
      sendingTime: json['sendingTime'] == null
          ? null
          : DateTime.parse(json['sendingTime'] as String),
    );

Map<String, dynamic> _$$RequestModelImplToJson(_$RequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'httpRequestModel': instance.httpRequestModel?.toJson(),
      'responseStatus': instance.responseStatus,
      'message': instance.message,
      'httpResponseModel': instance.httpResponseModel?.toJson(),
    };
