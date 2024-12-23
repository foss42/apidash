// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GraphqlRequestModelImpl _$$GraphqlRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GraphqlRequestModelImpl(
      query: json['query'] as String,
      variables: json['variables'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$GraphqlRequestModelImplToJson(
        _$GraphqlRequestModelImpl instance) =>
    <String, dynamic>{
      'query': instance.query,
      'variables': instance.variables,
    };
