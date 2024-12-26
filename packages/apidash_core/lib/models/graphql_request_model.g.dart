// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GraphqlRequestModelImpl _$$GraphqlRequestModelImplFromJson(Map json) =>
    _$GraphqlRequestModelImpl(
      url: json['url'] as String? ?? "",
      headers: (json['headers'] as List<dynamic>?)
          ?.map((e) =>
              NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
      graphqlVariables: (json['graphqlVariables'] as List<dynamic>?)
          ?.map((e) =>
              NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
      isHeaderEnabledList: (json['isHeaderEnabledList'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      isgraphqlVariablesEnabledList:
          (json['isgraphqlVariablesEnabledList'] as List<dynamic>?)
              ?.map((e) => e as bool)
              .toList(),
      query: json['query'] as String?,
    );

Map<String, dynamic> _$$GraphqlRequestModelImplToJson(
        _$GraphqlRequestModelImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'headers': instance.headers?.map((e) => e.toJson()).toList(),
      'graphqlVariables':
          instance.graphqlVariables?.map((e) => e.toJson()).toList(),
      'isHeaderEnabledList': instance.isHeaderEnabledList,
      'isgraphqlVariablesEnabledList': instance.isgraphqlVariablesEnabledList,
      'query': instance.query,
    };
