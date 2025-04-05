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
      httpRequestModel: HttpRequestModel.fromJson(
          Map<String, Object?>.from(json['httpRequestModel'] as Map)),
      httpResponseModel: HttpResponseModel.fromJson(
          Map<String, Object?>.from(json['httpResponseModel'] as Map)),
      webSocketRequestModel: json['webSocketRequestModel'] == null
          ? null
          : WebSocketRequestModel.fromJson(
              Map<String, Object?>.from(json['webSocketRequestModel'] as Map)),
      webSocketResponseModel: json['webSocketResponseModel'] == null
          ? null
          : WebSocketResponseModel.fromJson(
              Map<String, Object?>.from(json['webSocketResponseModel'] as Map)),
    );

Map<String, dynamic> _$$HistoryRequestModelImplToJson(
        _$HistoryRequestModelImpl instance) =>
    <String, dynamic>{
      'historyId': instance.historyId,
      'metaData': instance.metaData.toJson(),
      'httpRequestModel': instance.httpRequestModel.toJson(),
      'httpResponseModel': instance.httpResponseModel.toJson(),
      'webSocketRequestModel': instance.webSocketRequestModel?.toJson(),
      'webSocketResponseModel': instance.webSocketResponseModel?.toJson(),
    };
