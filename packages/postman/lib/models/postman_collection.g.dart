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
      if (instance.info?.toJson() case final value?) 'info': value,
      if (instance.item?.map((e) => e.toJson()).toList() case final value?)
        'item': value,
    };

_$InfoImpl _$$InfoImplFromJson(Map json) => _$InfoImpl(
      postmanId: json['_postman_id'] as String?,
      name: json['name'] as String?,
      schema: json['schema'] as String?,
      exporterId: json['_exporter_id'] as String?,
    );

Map<String, dynamic> _$$InfoImplToJson(_$InfoImpl instance) =>
    <String, dynamic>{
      if (instance.postmanId case final value?) '_postman_id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.schema case final value?) 'schema': value,
      if (instance.exporterId case final value?) '_exporter_id': value,
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
      if (instance.name case final value?) 'name': value,
      if (instance.item?.map((e) => e.toJson()).toList() case final value?)
        'item': value,
      if (instance.request?.toJson() case final value?) 'request': value,
      if (instance.response case final value?) 'response': value,
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
      if (instance.method case final value?) 'method': value,
      if (instance.header?.map((e) => e.toJson()).toList() case final value?)
        'header': value,
      if (instance.body?.toJson() case final value?) 'body': value,
      if (instance.url?.toJson() case final value?) 'url': value,
    };

_$HeaderImpl _$$HeaderImplFromJson(Map json) => _$HeaderImpl(
      key: json['key'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$$HeaderImplToJson(_$HeaderImpl instance) =>
    <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.type case final value?) 'type': value,
      if (instance.disabled case final value?) 'disabled': value,
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
      if (instance.raw case final value?) 'raw': value,
      if (instance.protocol case final value?) 'protocol': value,
      if (instance.host case final value?) 'host': value,
      if (instance.path case final value?) 'path': value,
      if (instance.query?.map((e) => e.toJson()).toList() case final value?)
        'query': value,
    };

_$QueryImpl _$$QueryImplFromJson(Map json) => _$QueryImpl(
      key: json['key'] as String?,
      value: json['value'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$$QueryImplToJson(_$QueryImpl instance) =>
    <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.disabled case final value?) 'disabled': value,
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
      if (instance.mode case final value?) 'mode': value,
      if (instance.raw case final value?) 'raw': value,
      if (instance.options?.toJson() case final value?) 'options': value,
      if (instance.formdata?.map((e) => e.toJson()).toList() case final value?)
        'formdata': value,
    };

_$OptionsImpl _$$OptionsImplFromJson(Map json) => _$OptionsImpl(
      raw: json['raw'] == null
          ? null
          : Raw.fromJson(Map<String, dynamic>.from(json['raw'] as Map)),
    );

Map<String, dynamic> _$$OptionsImplToJson(_$OptionsImpl instance) =>
    <String, dynamic>{
      if (instance.raw?.toJson() case final value?) 'raw': value,
    };

_$RawImpl _$$RawImplFromJson(Map json) => _$RawImpl(
      language: json['language'] as String?,
    );

Map<String, dynamic> _$$RawImplToJson(_$RawImpl instance) => <String, dynamic>{
      if (instance.language case final value?) 'language': value,
    };

_$FormdatumImpl _$$FormdatumImplFromJson(Map json) => _$FormdatumImpl(
      key: json['key'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      src: json['src'] as String?,
    );

Map<String, dynamic> _$$FormdatumImplToJson(_$FormdatumImpl instance) =>
    <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.type case final value?) 'type': value,
      if (instance.src case final value?) 'src': value,
    };
