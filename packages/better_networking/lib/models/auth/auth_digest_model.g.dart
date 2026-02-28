// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_digest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthDigestModelImpl _$$AuthDigestModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthDigestModelImpl(
  username: json['username'] as String,
  password: json['password'] as String,
  realm: json['realm'] as String,
  nonce: json['nonce'] as String,
  algorithm: json['algorithm'] as String,
  qop: json['qop'] as String,
  opaque: json['opaque'] as String,
);

Map<String, dynamic> _$$AuthDigestModelImplToJson(
  _$AuthDigestModelImpl instance,
) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
  'realm': instance.realm,
  'nonce': instance.nonce,
  'algorithm': instance.algorithm,
  'qop': instance.qop,
  'opaque': instance.opaque,
};
