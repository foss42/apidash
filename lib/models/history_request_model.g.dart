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

Map<String, dynamic> _$$HistoryRequestModelImplToJson(
        _$HistoryRequestModelImpl instance) =>
    <String, dynamic>{
      'historyId': instance.historyId,
      'metaData': instance.metaData.toJson(),
      'httpRequestModel': instance.httpRequestModel?.toJson(),
      'httpResponseModel': instance.httpResponseModel?.toJson(),
      'aiRequestModel': instance.aiRequestModel?.toJson(),
      'aiResponseModel': instance.aiResponseModel?.toJson(),
    };
