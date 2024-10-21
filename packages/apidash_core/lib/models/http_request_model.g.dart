// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HttpRequestModelImpl _$$HttpRequestModelImplFromJson(Map json) =>
    _$HttpRequestModelImpl(
      method: $enumDecodeNullable(_$HTTPVerbEnumMap, json['method']) ??
          HTTPVerb.get,
      url: json['url'] as String? ?? "",
      headers: (json['headers'] as List<dynamic>?)
          ?.map((e) =>
              NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
      params: (json['params'] as List<dynamic>?)
          ?.map((e) =>
              NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
      isHeaderEnabledList: (json['isHeaderEnabledList'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      isParamEnabledList: (json['isParamEnabledList'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      bodyContentType:
          $enumDecodeNullable(_$ContentTypeEnumMap, json['bodyContentType']) ??
              ContentType.json,
      body: json['body'] as String?,
      formData: (json['formData'] as List<dynamic>?)
          ?.map((e) =>
              FormDataModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$HttpRequestModelImplToJson(
        _$HttpRequestModelImpl instance) =>
    <String, dynamic>{
      'method': _$HTTPVerbEnumMap[instance.method]!,
      'url': instance.url,
      'headers': instance.headers?.map((e) => e.toJson()).toList(),
      'params': instance.params?.map((e) => e.toJson()).toList(),
      'isHeaderEnabledList': instance.isHeaderEnabledList,
      'isParamEnabledList': instance.isParamEnabledList,
      'bodyContentType': _$ContentTypeEnumMap[instance.bodyContentType]!,
      'body': instance.body,
      'formData': instance.formData?.map((e) => e.toJson()).toList(),
    };

const _$HTTPVerbEnumMap = {
  HTTPVerb.get: 'get',
  HTTPVerb.head: 'head',
  HTTPVerb.post: 'post',
  HTTPVerb.put: 'put',
  HTTPVerb.patch: 'patch',
  HTTPVerb.delete: 'delete',
};

const _$ContentTypeEnumMap = {
  ContentType.json: 'json',
  ContentType.text: 'text',
  ContentType.formdata: 'formdata',
};
