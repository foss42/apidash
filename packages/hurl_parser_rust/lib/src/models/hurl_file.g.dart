// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hurl_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HurlFileImpl _$$HurlFileImplFromJson(Map json) => _$HurlFileImpl(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => HurlEntry.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$HurlFileImplToJson(_$HurlFileImpl instance) =>
    <String, dynamic>{
      'entries': instance.entries.map((e) => e.toJson()).toList(),
    };
