// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_oauth1_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthOAuth1ModelImpl _$$AuthOAuth1ModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthOAuth1ModelImpl(
  consumerKey: json['consumerKey'] as String,
  consumerSecret: json['consumerSecret'] as String,
  accessToken: json['accessToken'] as String?,
  tokenSecret: json['tokenSecret'] as String?,
  signatureMethod: json['signatureMethod'] as String? ?? "hmacSha1",
  parameterLocation: json['parameterLocation'] as String? ?? "header",
  version: json['version'] as String? ?? '1.0',
  realm: json['realm'] as String?,
  callbackUrl: json['callbackUrl'] as String?,
  verifier: json['verifier'] as String?,
  nonce: json['nonce'] as String?,
  timestamp: json['timestamp'] as String?,
  includeBodyHash: json['includeBodyHash'] as bool? ?? false,
);

Map<String, dynamic> _$$AuthOAuth1ModelImplToJson(
  _$AuthOAuth1ModelImpl instance,
) => <String, dynamic>{
  'consumerKey': instance.consumerKey,
  'consumerSecret': instance.consumerSecret,
  'accessToken': instance.accessToken,
  'tokenSecret': instance.tokenSecret,
  'signatureMethod': instance.signatureMethod,
  'parameterLocation': instance.parameterLocation,
  'version': instance.version,
  'realm': instance.realm,
  'callbackUrl': instance.callbackUrl,
  'verifier': instance.verifier,
  'nonce': instance.nonce,
  'timestamp': instance.timestamp,
  'includeBodyHash': instance.includeBodyHash,
};
