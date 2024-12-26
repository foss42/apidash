// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_credentials_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OAuthCredentialsImpl _$$OAuthCredentialsImplFromJson(
        Map<String, dynamic> json) =>
    _$OAuthCredentialsImpl(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      configId: json['configId'] as String?,
    );

Map<String, dynamic> _$$OAuthCredentialsImplToJson(
        _$OAuthCredentialsImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'configId': instance.configId,
    };
