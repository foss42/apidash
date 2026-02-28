// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_jwt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthJwtModelImpl _$$AuthJwtModelImplFromJson(Map<String, dynamic> json) =>
    _$AuthJwtModelImpl(
      secret: json['secret'] as String,
      privateKey: json['privateKey'] as String?,
      payload: json['payload'] as String,
      addTokenTo: json['addTokenTo'] as String,
      algorithm: json['algorithm'] as String,
      isSecretBase64Encoded: json['isSecretBase64Encoded'] as bool,
      headerPrefix: json['headerPrefix'] as String,
      queryParamKey: json['queryParamKey'] as String,
      header: json['header'] as String,
    );

Map<String, dynamic> _$$AuthJwtModelImplToJson(_$AuthJwtModelImpl instance) =>
    <String, dynamic>{
      'secret': instance.secret,
      'privateKey': instance.privateKey,
      'payload': instance.payload,
      'addTokenTo': instance.addTokenTo,
      'algorithm': instance.algorithm,
      'isSecretBase64Encoded': instance.isSecretBase64Encoded,
      'headerPrefix': instance.headerPrefix,
      'queryParamKey': instance.queryParamKey,
      'header': instance.header,
    };
