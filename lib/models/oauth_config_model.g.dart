// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OAuthConfigImpl _$$OAuthConfigImplFromJson(Map<String, dynamic> json) =>
    _$OAuthConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      flow: $enumDecode(_$OAuthFlowEnumMap, json['flow']),
      clientId: json['clientId'] as String,
      clientSecret: json['clientSecret'] as String,
      authUrl: json['authUrl'] as String,
      tokenEndpoint: json['tokenEndpoint'] as String,
      callbackUrl: json['callbackUrl'] as String,
      scope: json['scope'] as String,
      state: json['state'] as String,
      autoRefresh: json['autoRefresh'] as bool? ?? false,
      shareToken: json['shareToken'] as bool? ?? false,
    );

Map<String, dynamic> _$$OAuthConfigImplToJson(_$OAuthConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'flow': _$OAuthFlowEnumMap[instance.flow]!,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'authUrl': instance.authUrl,
      'tokenEndpoint': instance.tokenEndpoint,
      'callbackUrl': instance.callbackUrl,
      'scope': instance.scope,
      'state': instance.state,
      'autoRefresh': instance.autoRefresh,
      'shareToken': instance.shareToken,
    };

const _$OAuthFlowEnumMap = {
  OAuthFlow.authorizationCode: 'authorizationCode',
};
