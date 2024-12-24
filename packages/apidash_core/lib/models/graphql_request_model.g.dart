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
      isHeaderEnabledList: (json['isHeaderEnabledList'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      bodyContentType:
          $enumDecodeNullable(_$ContentTypeEnumMap, json['bodyContentType']) ??
              ContentType.json,
      query: json['query'] as String?,
      graphql_variables: (json['graphql_variables'] as List<dynamic>?)
          ?.map((e) =>
              NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$GraphqlRequestModelImplToJson(
        _$GraphqlRequestModelImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'headers': instance.headers?.map((e) => e.toJson()).toList(),
      'isHeaderEnabledList': instance.isHeaderEnabledList,
      'bodyContentType': _$ContentTypeEnumMap[instance.bodyContentType]!,
      'query': instance.query,
      'graphql_variables':
          instance.graphql_variables?.map((e) => e.toJson()).toList(),
    };

const _$ContentTypeEnumMap = {
  ContentType.json: 'json',
  ContentType.text: 'text',
  ContentType.formdata: 'formdata',
};
