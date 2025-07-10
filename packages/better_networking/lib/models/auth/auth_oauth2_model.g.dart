// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_oauth2_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthOAuth2ModelImpl _$$AuthOAuth2ModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthOAuth2ModelImpl(
  grantType: json['grantType'] as String? ?? "authorization_code",
  authorizationUrl: json['authorizationUrl'] as String,
  accessTokenUrl: json['accessTokenUrl'] as String,
  clientId: json['clientId'] as String,
  clientSecret: json['clientSecret'] as String,
  redirectUrl: json['redirectUrl'] as String?,
  scope: json['scope'] as String?,
  state: json['state'] as String?,
  codeChallengeMethod: json['codeChallengeMethod'] as String? ?? "sha-256",
  codeVerifier: json['codeVerifier'] as String?,
  codeChallenge: json['codeChallenge'] as String?,
  username: json['username'] as String?,
  password: json['password'] as String?,
  refreshToken: json['refreshToken'] as String?,
  identityToken: json['identityToken'] as String?,
  accessToken: json['accessToken'] as String?,
);

Map<String, dynamic> _$$AuthOAuth2ModelImplToJson(
  _$AuthOAuth2ModelImpl instance,
) => <String, dynamic>{
  'grantType': instance.grantType,
  'authorizationUrl': instance.authorizationUrl,
  'accessTokenUrl': instance.accessTokenUrl,
  'clientId': instance.clientId,
  'clientSecret': instance.clientSecret,
  'redirectUrl': instance.redirectUrl,
  'scope': instance.scope,
  'state': instance.state,
  'codeChallengeMethod': instance.codeChallengeMethod,
  'codeVerifier': instance.codeVerifier,
  'codeChallenge': instance.codeChallenge,
  'username': instance.username,
  'password': instance.password,
  'refreshToken': instance.refreshToken,
  'identityToken': instance.identityToken,
  'accessToken': instance.accessToken,
};
