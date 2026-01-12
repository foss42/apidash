// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebSocketRequestModel _$WebSocketRequestModelFromJson(Map json) =>
    _WebSocketRequestModel(
      url: json['url'] as String? ?? "",
      headers: (json['headers'] as List<dynamic>?)
          ?.map((e) =>
              NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
      isHeaderEnabledList: (json['isHeaderEnabledList'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      params: (json['params'] as List<dynamic>?)
          ?.map((e) =>
              NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
      isParamEnabledList: (json['isParamEnabledList'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      authModel: json['authModel'] == null
          ? const AuthModel(type: APIAuthType.none)
          : AuthModel.fromJson(
              Map<String, dynamic>.from(json['authModel'] as Map)),
      initialMessage: json['initialMessage'] as String?,
      messageContentType: $enumDecodeNullable(
              _$ContentTypeEnumMap, json['messageContentType']) ??
          ContentType.json,
    );

Map<String, dynamic> _$WebSocketRequestModelToJson(
        _WebSocketRequestModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'headers': instance.headers?.map((e) => e.toJson()).toList(),
      'isHeaderEnabledList': instance.isHeaderEnabledList,
      'params': instance.params?.map((e) => e.toJson()).toList(),
      'isParamEnabledList': instance.isParamEnabledList,
      'authModel': instance.authModel?.toJson(),
      'initialMessage': instance.initialMessage,
      'messageContentType': _$ContentTypeEnumMap[instance.messageContentType]!,
    };

const _$ContentTypeEnumMap = {
  ContentType.json: 'json',
  ContentType.text: 'text',
  ContentType.formdata: 'formdata',
};
