// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hurl_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HurlRequestImpl _$$HurlRequestImplFromJson(Map<String, dynamic> json) =>
    _$HurlRequestImpl(
      method: json['method'] as String,
      url: json['url'] as String,
      headers: (json['headers'] as List<dynamic>?)
          ?.map((e) => Header.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => RequestOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      body: json['body'] == null
          ? null
          : RequestBody.fromJson(json['body'] as Map<String, dynamic>),
      multiPartFormData: (json['multipart_form_data'] as List<dynamic>?)
          ?.map((e) => MultipartFormData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$HurlRequestImplToJson(_$HurlRequestImpl instance) =>
    <String, dynamic>{
      'method': instance.method,
      'url': instance.url,
      'headers': instance.headers?.map((e) => e.toJson()).toList(),
      'comments': instance.comments,
      'options': instance.options?.map((e) => e.toJson()).toList(),
      'body': instance.body?.toJson(),
      'multipart_form_data':
          instance.multiPartFormData?.map((e) => e.toJson()).toList(),
    };
