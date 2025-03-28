// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stress_test_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StressTestConfigImpl _$$StressTestConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$StressTestConfigImpl(
      url: json['url'] as String,
      method: json['method'] as String,
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      body: json['body'],
      concurrentRequests: (json['concurrentRequests'] as num).toInt(),
      timeout: json['timeout'] == null
          ? null
          : Duration(microseconds: (json['timeout'] as num).toInt()),
      useIsolates: json['useIsolates'] as bool? ?? false,
    );

Map<String, dynamic> _$$StressTestConfigImplToJson(
        _$StressTestConfigImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'method': instance.method,
      'headers': instance.headers,
      'body': instance.body,
      'concurrentRequests': instance.concurrentRequests,
      'timeout': instance.timeout?.inMicroseconds,
      'useIsolates': instance.useIsolates,
    };
