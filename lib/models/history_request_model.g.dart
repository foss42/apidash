// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryRequestModelImpl _$$HistoryRequestModelImplFromJson(Map json) =>
    _$HistoryRequestModelImpl(
      historyId: json['historyId'] as String,
      metaData: HistoryMetaModel.fromJson(
          Map<String, Object?>.from(json['metaData'] as Map)),
      httpRequestModel: json['httpRequestModel'] == null
          ? null
          : HttpRequestModel.fromJson(
              Map<String, Object?>.from(json['httpRequestModel'] as Map)),
      aiRequestModel: json['aiRequestModel'] == null
          ? null
          : AIRequestModel.fromJson(
              Map<String, Object?>.from(json['aiRequestModel'] as Map)),
      httpResponseModel: HttpResponseModel.fromJson(
          Map<String, Object?>.from(json['httpResponseModel'] as Map)),
      preRequestScript: json['preRequestScript'] as String?,
      postRequestScript: json['postRequestScript'] as String?,
      authModel: json['authModel'] == null
          ? null
          : AuthModel.fromJson(
              Map<String, dynamic>.from(json['authModel'] as Map)),
    );

Map<String, dynamic> _$$HistoryRequestModelImplToJson(
        _$HistoryRequestModelImpl instance) =>
    <String, dynamic>{
      'historyId': instance.historyId,
      'metaData': instance.metaData.toJson(),
      'httpRequestModel': instance.httpRequestModel?.toJson(),
      'aiRequestModel': instance.aiRequestModel?.toJson(),
      'httpResponseModel': instance.httpResponseModel.toJson(),
      'preRequestScript': instance.preRequestScript,
      'postRequestScript': instance.postRequestScript,
      'authModel': instance.authModel?.toJson(),
    };
