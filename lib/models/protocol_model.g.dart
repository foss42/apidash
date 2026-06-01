// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RestProtocolModel _$RestProtocolModelFromJson(Map json) => _RestProtocolModel(
  httpRequestModel: json['httpRequestModel'] == null
      ? null
      : HttpRequestModel.fromJson(
          Map<String, Object?>.from(json['httpRequestModel'] as Map),
        ),
  httpResponseModel: json['httpResponseModel'] == null
      ? null
      : HttpResponseModel.fromJson(
          Map<String, Object?>.from(json['httpResponseModel'] as Map),
        ),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$RestProtocolModelToJson(_RestProtocolModel instance) =>
    <String, dynamic>{
      'httpRequestModel': instance.httpRequestModel?.toJson(),
      'httpResponseModel': instance.httpResponseModel?.toJson(),
      'type': instance.$type,
    };

_GraphqlProtocolModel _$GraphqlProtocolModelFromJson(Map json) =>
    _GraphqlProtocolModel(
      httpRequestModel: json['httpRequestModel'] == null
          ? null
          : HttpRequestModel.fromJson(
              Map<String, Object?>.from(json['httpRequestModel'] as Map),
            ),
      httpResponseModel: json['httpResponseModel'] == null
          ? null
          : HttpResponseModel.fromJson(
              Map<String, Object?>.from(json['httpResponseModel'] as Map),
            ),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$GraphqlProtocolModelToJson(
  _GraphqlProtocolModel instance,
) => <String, dynamic>{
  'httpRequestModel': instance.httpRequestModel?.toJson(),
  'httpResponseModel': instance.httpResponseModel?.toJson(),
  'type': instance.$type,
};

_AiProtocolModel _$AiProtocolModelFromJson(Map json) => _AiProtocolModel(
  aiRequestModel: json['aiRequestModel'] == null
      ? null
      : AIRequestModel.fromJson(
          Map<String, Object?>.from(json['aiRequestModel'] as Map),
        ),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$AiProtocolModelToJson(_AiProtocolModel instance) =>
    <String, dynamic>{
      'aiRequestModel': instance.aiRequestModel?.toJson(),
      'type': instance.$type,
    };
