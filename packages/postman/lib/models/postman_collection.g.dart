// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postman_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostmanCollectionImpl _$$PostmanCollectionImplFromJson(Map json) =>
    _$PostmanCollectionImpl(
      info: json['info'] == null
          ? null
          : Info.fromJson(Map<String, dynamic>.from(json['info'] as Map)),
      item: (json['item'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$PostmanCollectionImplToJson(
        _$PostmanCollectionImpl instance) =>
    <String, dynamic>{
      'info': instance.info?.toJson(),
      'item': instance.item?.map((e) => e.toJson()).toList(),
    };

_$InfoImpl _$$InfoImplFromJson(Map json) => _$InfoImpl(
      postmanId: json['_postman_id'] as String?,
      name: json['name'] as String?,
      schema: json['schema'] as String?,
      exporterId: json['_exporter_id'] as String?,
    );

Map<String, dynamic> _$$InfoImplToJson(_$InfoImpl instance) =>
    <String, dynamic>{
      '_postman_id': instance.postmanId,
      'name': instance.name,
      'schema': instance.schema,
      '_exporter_id': instance.exporterId,
    };

_$ItemImpl _$$ItemImplFromJson(Map json) => _$ItemImpl(
      name: json['name'] as String?,
      item: (json['item'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      request: json['request'] == null
          ? null
          : Request.fromJson(Map<String, dynamic>.from(json['request'] as Map)),
      response: json['response'] as List<dynamic>?,
    );

Map<String, dynamic> _$$ItemImplToJson(_$ItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'item': instance.item?.map((e) => e.toJson()).toList(),
      'request': instance.request?.toJson(),
      'response': instance.response,
    };

_$RequestImpl _$$RequestImplFromJson(Map json) => _$RequestImpl(
      method: json['method'] as String?,
      header: (json['header'] as List<dynamic>?)
          ?.map((e) => Header.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      body: json['body'] == null
          ? null
          : Body.fromJson(Map<String, dynamic>.from(json['body'] as Map)),
      url: json['url'] == null
          ? null
          : Url.fromJson(Map<String, dynamic>.from(json['url'] as Map)),
    );

Map<String, dynamic> _$$RequestImplToJson(_$RequestImpl instance) =>
    <String, dynamic>{
      'method': instance.method,
      'header': instance.header?.map((e) => e.toJson()).toList(),
      'body': instance.body?.toJson(),
      'url': instance.url?.toJson(),
    };

_$HeaderImpl _$$HeaderImplFromJson(Map json) => _$HeaderImpl(
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

_$UrlImpl _$$UrlImplFromJson(Map json) => _$UrlImpl(
      raw: json['raw'] as String?,
      protocol: json['protocol'] as String?,
      host: (json['host'] as List<dynamic>?)?.map((e) => e as String).toList(),
      path: (json['path'] as List<dynamic>?)?.map((e) => e as String).toList(),
      query: (json['query'] as List<dynamic>?)
          ?.map((e) => Query.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$UrlImplToJson(_$UrlImpl instance) => <String, dynamic>{
      'raw': instance.raw,
      'protocol': instance.protocol,
      'host': instance.host,
      'path': instance.path,
      'query': instance.query?.map((e) => e.toJson()).toList(),
    };

_$QueryImpl _$$QueryImplFromJson(Map json) => _$QueryImpl(
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

_$BodyImpl _$$BodyImplFromJson(Map json) => _$BodyImpl(
      mode: json['mode'] as String?,
      raw: json['raw'] as String?,
      options: json['options'] == null
          ? null
          : Options.fromJson(Map<String, dynamic>.from(json['options'] as Map)),
      formdata: (json['formdata'] as List<dynamic>?)
          ?.map((e) => Formdatum.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$BodyImplToJson(_$BodyImpl instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'raw': instance.raw,
      'options': instance.options?.toJson(),
      'formdata': instance.formdata?.map((e) => e.toJson()).toList(),
    };

_$OptionsImpl _$$OptionsImplFromJson(Map json) => _$OptionsImpl(
      raw: json['raw'] == null
          ? null
          : Raw.fromJson(Map<String, dynamic>.from(json['raw'] as Map)),
    );

Map<String, dynamic> _$$OptionsImplToJson(_$OptionsImpl instance) =>
    <String, dynamic>{
      'raw': instance.raw?.toJson(),
    };

_$RawImpl _$$RawImplFromJson(Map json) => _$RawImpl(
      language: json['language'] as String?,
    );

Map<String, dynamic> _$$RawImplToJson(_$RawImpl instance) => <String, dynamic>{
      'language': instance.language,
    };

_$FormdatumImpl _$$FormdatumImplFromJson(Map json) => _$FormdatumImpl(
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
