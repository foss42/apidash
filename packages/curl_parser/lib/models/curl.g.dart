// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Curl _$CurlFromJson(Map<String, dynamic> json) => _Curl(
      method: json['method'] as String,
      uri: const UriJsonConverter().fromJson(json['uri'] as String),
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      data: json['data'] as String?,
      cookie: json['cookie'] as String?,
      user: json['user'] as String?,
      referer: json['referer'] as String?,
      userAgent: json['userAgent'] as String?,
      form: json['form'] as bool? ?? false,
      formData: (json['formData'] as List<dynamic>?)
          ?.map((e) => FormDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      insecure: json['insecure'] as bool? ?? false,
      location: json['location'] as bool? ?? false,
    );

Map<String, dynamic> _$CurlToJson(_Curl instance) => <String, dynamic>{
      'method': instance.method,
      'uri': const UriJsonConverter().toJson(instance.uri),
      'headers': instance.headers,
      'data': instance.data,
      'cookie': instance.cookie,
      'user': instance.user,
      'referer': instance.referer,
      'userAgent': instance.userAgent,
      'form': instance.form,
      'formData': instance.formData?.map((e) => e.toJson()).toList(),
      'insecure': instance.insecure,
      'location': instance.location,
    };
