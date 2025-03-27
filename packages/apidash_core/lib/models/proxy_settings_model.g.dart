// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProxySettingsImpl _$$ProxySettingsImplFromJson(Map<String, dynamic> json) =>
    _$ProxySettingsImpl(
      host: json['host'] as String? ?? '',
      port: json['port'] as String? ?? '',
      username: json['username'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$$ProxySettingsImplToJson(_$ProxySettingsImpl instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'username': instance.username,
      'password': instance.password,
    };
