// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GraphqlResponseModelImpl _$$GraphqlResponseModelImplFromJson(Map json) =>
    _$GraphqlResponseModelImpl(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      headers: (json['headers'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      requestHeaders: (json['requestHeaders'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      graphqlRequestModel: json['graphqlRequestModel'] == null
          ? null
          : GraphqlRequestModel.fromJson(
              Map<String, Object?>.from(json['graphqlRequestModel'] as Map)),
      body: json['body'] as String?,
      formattedBody: json['formattedBody'] as String?,
      bodyBytes:
          const Uint8ListConverter().fromJson(json['bodyBytes'] as List<int>?),
      time: const DurationConverter().fromJson((json['time'] as num?)?.toInt()),
    );

Map<String, dynamic> _$$GraphqlResponseModelImplToJson(
        _$GraphqlResponseModelImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'headers': instance.headers,
      'requestHeaders': instance.requestHeaders,
      'graphqlRequestModel': instance.graphqlRequestModel?.toJson(),
      'body': instance.body,
      'formattedBody': instance.formattedBody,
      'bodyBytes': const Uint8ListConverter().toJson(instance.bodyBytes),
      'time': const DurationConverter().toJson(instance.time),
    };
