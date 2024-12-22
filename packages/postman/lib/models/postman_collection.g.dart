// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postman_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostmanCollectionImpl _$$PostmanCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$PostmanCollectionImpl(
      info: json['info'] == null
          ? null
          : Info.fromJson(json['info'] as Map<String, dynamic>),
      item: (json['item'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PostmanCollectionImplToJson(
        _$PostmanCollectionImpl instance) =>
    <String, dynamic>{
      'info': instance.info,
      'item': instance.item,
    };

_$InfoImpl _$$InfoImplFromJson(Map<String, dynamic> json) => _$InfoImpl(
      postmanId: json['postmanId'] as String?,
      name: json['name'] as String?,
      schema: json['schema'] as String?,
      exporterId: json['exporterId'] as String?,
    );

Map<String, dynamic> _$$InfoImplToJson(_$InfoImpl instance) =>
    <String, dynamic>{
      'postmanId': instance.postmanId,
      'name': instance.name,
      'schema': instance.schema,
      'exporterId': instance.exporterId,
    };

_$ItemImpl _$$ItemImplFromJson(Map<String, dynamic> json) => _$ItemImpl(
      name: json['name'] as String?,
      request: json['request'] == null
          ? null
          : Request.fromJson(json['request'] as Map<String, dynamic>),
      response: json['response'] as List<dynamic>?,
    );

Map<String, dynamic> _$$ItemImplToJson(_$ItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'request': instance.request,
      'response': instance.response,
    };

_$RequestImpl _$$RequestImplFromJson(Map<String, dynamic> json) =>
    _$RequestImpl(
      method: json['method'] as String?,
      header: (json['header'] as List<dynamic>?)
          ?.map((e) => Header.fromJson(e as Map<String, dynamic>))
          .toList(),
      body: json['body'] == null
          ? null
          : Body.fromJson(json['body'] as Map<String, dynamic>),
      url: json['url'] == null
          ? null
          : Url.fromJson(json['url'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RequestImplToJson(_$RequestImpl instance) =>
    <String, dynamic>{
      'method': instance.method,
      'header': instance.header,
      'body': instance.body,
      'url': instance.url,
    };

_$HeaderImpl _$$HeaderImplFromJson(Map<String, dynamic> json) => _$HeaderImpl(
      key: json['key'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$$HeaderImplToJson(_$HeaderImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
      'disabled': instance.disabled,
    };

_$UrlImpl _$$UrlImplFromJson(Map<String, dynamic> json) => _$UrlImpl(
      raw: json['raw'] as String?,
      protocol: json['protocol'] as String?,
      host: (json['host'] as List<dynamic>?)?.map((e) => e as String).toList(),
      path: (json['path'] as List<dynamic>?)?.map((e) => e as String).toList(),
      query: (json['query'] as List<dynamic>?)
          ?.map((e) => Query.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UrlImplToJson(_$UrlImpl instance) => <String, dynamic>{
      'raw': instance.raw,
      'protocol': instance.protocol,
      'host': instance.host,
      'path': instance.path,
      'query': instance.query,
    };

_$QueryImpl _$$QueryImplFromJson(Map<String, dynamic> json) => _$QueryImpl(
      key: json['key'] as String?,
      value: json['value'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$$QueryImplToJson(_$QueryImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'disabled': instance.disabled,
    };

_$BodyImpl _$$BodyImplFromJson(Map<String, dynamic> json) => _$BodyImpl(
      mode: json['mode'] as String?,
      raw: json['raw'] as String?,
      options: json['options'] == null
          ? null
          : Options.fromJson(json['options'] as Map<String, dynamic>),
      formdata: (json['formdata'] as List<dynamic>?)
          ?.map((e) => Formdatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BodyImplToJson(_$BodyImpl instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'raw': instance.raw,
      'options': instance.options,
      'formdata': instance.formdata,
    };

_$OptionsImpl _$$OptionsImplFromJson(Map<String, dynamic> json) =>
    _$OptionsImpl(
      raw: json['raw'] == null
          ? null
          : Raw.fromJson(json['raw'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OptionsImplToJson(_$OptionsImpl instance) =>
    <String, dynamic>{
      'raw': instance.raw,
    };

_$RawImpl _$$RawImplFromJson(Map<String, dynamic> json) => _$RawImpl(
      language: json['language'] as String?,
    );

Map<String, dynamic> _$$RawImplToJson(_$RawImpl instance) => <String, dynamic>{
      'language': instance.language,
    };

_$FormdatumImpl _$$FormdatumImplFromJson(Map<String, dynamic> json) =>
    _$FormdatumImpl(
      key: json['key'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      src: json['src'] as String?,
    );

Map<String, dynamic> _$$FormdatumImplToJson(_$FormdatumImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
      'src': instance.src,
    };
