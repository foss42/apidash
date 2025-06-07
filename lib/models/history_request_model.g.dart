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
      genericRequestModel: GenericRequestModel.fromJson(
          Map<String, dynamic>.from(json['genericRequestModel'] as Map)),
      genericResponseModel: GenericResponseModel.fromJson(
          Map<String, dynamic>.from(json['genericResponseModel'] as Map)),
    );

Map<String, dynamic> _$$HistoryRequestModelImplToJson(
        _$HistoryRequestModelImpl instance) =>
    <String, dynamic>{
      'historyId': instance.historyId,
      'metaData': instance.metaData.toJson(),
      'genericRequestModel': instance.genericRequestModel.toJson(),
      'genericResponseModel': instance.genericResponseModel.toJson(),
    };
