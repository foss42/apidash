// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hurl_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HurlEntryImpl _$$HurlEntryImplFromJson(Map json) => _$HurlEntryImpl(
      request: HurlRequest.fromJson(
          Map<String, dynamic>.from(json['request'] as Map)),
      response: json['response'] == null
          ? null
          : HurlResponse.fromJson(
              Map<String, dynamic>.from(json['response'] as Map)),
    );

Map<String, dynamic> _$$HurlEntryImplToJson(_$HurlEntryImpl instance) =>
    <String, dynamic>{
      'request': instance.request.toJson(),
      'response': instance.response?.toJson(),
    };
