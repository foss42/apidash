// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postman_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostmanCollection _$PostmanCollectionFromJson(Map json) => _PostmanCollection(
  info: json['info'] == null
      ? null
      : Info.fromJson(Map<String, dynamic>.from(json['info'] as Map)),
  item: (json['item'] as List<dynamic>?)
      ?.map((e) => Item.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$PostmanCollectionToJson(_PostmanCollection instance) =>
    <String, dynamic>{
      'info': ?instance.info?.toJson(),
      'item': ?instance.item?.map((e) => e.toJson()).toList(),
    };

_Info _$InfoFromJson(Map json) => _Info(
  postmanId: json['_postman_id'] as String?,
  name: json['name'] as String?,
  schema: json['schema'] as String?,
  exporterId: json['_exporter_id'] as String?,
);

Map<String, dynamic> _$InfoToJson(_Info instance) => <String, dynamic>{
  '_postman_id': ?instance.postmanId,
  'name': ?instance.name,
  'schema': ?instance.schema,
  '_exporter_id': ?instance.exporterId,
};

_Item _$ItemFromJson(Map json) => _Item(
  name: json['name'] as String?,
  item: (json['item'] as List<dynamic>?)
      ?.map((e) => Item.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  request: json['request'] == null
      ? null
      : Request.fromJson(Map<String, dynamic>.from(json['request'] as Map)),
  response: json['response'] as List<dynamic>?,
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'name': ?instance.name,
  'item': ?instance.item?.map((e) => e.toJson()).toList(),
  'request': ?instance.request?.toJson(),
  'response': ?instance.response,
};

_Request _$RequestFromJson(Map json) => _Request(
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

Map<String, dynamic> _$RequestToJson(_Request instance) => <String, dynamic>{
  'method': ?instance.method,
  'header': ?instance.header?.map((e) => e.toJson()).toList(),
  'body': ?instance.body?.toJson(),
  'url': ?instance.url?.toJson(),
};

_Header _$HeaderFromJson(Map json) => _Header(
  key: json['key'] as String?,
  value: json['value'] as String?,
  type: json['type'] as String?,
  disabled: json['disabled'] as bool?,
);

Map<String, dynamic> _$HeaderToJson(_Header instance) => <String, dynamic>{
  'key': ?instance.key,
  'value': ?instance.value,
  'type': ?instance.type,
  'disabled': ?instance.disabled,
};

_Url _$UrlFromJson(Map json) => _Url(
  raw: json['raw'] as String?,
  protocol: json['protocol'] as String?,
  host: (json['host'] as List<dynamic>?)?.map((e) => e as String).toList(),
  path: (json['path'] as List<dynamic>?)?.map((e) => e as String).toList(),
  query: (json['query'] as List<dynamic>?)
      ?.map((e) => Query.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$UrlToJson(_Url instance) => <String, dynamic>{
  'raw': ?instance.raw,
  'protocol': ?instance.protocol,
  'host': ?instance.host,
  'path': ?instance.path,
  'query': ?instance.query?.map((e) => e.toJson()).toList(),
};

_Query _$QueryFromJson(Map json) => _Query(
  key: json['key'] as String?,
  value: json['value'] as String?,
  disabled: json['disabled'] as bool?,
);

Map<String, dynamic> _$QueryToJson(_Query instance) => <String, dynamic>{
  'key': ?instance.key,
  'value': ?instance.value,
  'disabled': ?instance.disabled,
};

_Body _$BodyFromJson(Map json) => _Body(
  mode: json['mode'] as String?,
  raw: json['raw'] as String?,
  options: json['options'] == null
      ? null
      : Options.fromJson(Map<String, dynamic>.from(json['options'] as Map)),
  formdata: (json['formdata'] as List<dynamic>?)
      ?.map((e) => Formdatum.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$BodyToJson(_Body instance) => <String, dynamic>{
  'mode': ?instance.mode,
  'raw': ?instance.raw,
  'options': ?instance.options?.toJson(),
  'formdata': ?instance.formdata?.map((e) => e.toJson()).toList(),
};

_Options _$OptionsFromJson(Map json) => _Options(
  raw: json['raw'] == null
      ? null
      : Raw.fromJson(Map<String, dynamic>.from(json['raw'] as Map)),
);

Map<String, dynamic> _$OptionsToJson(_Options instance) => <String, dynamic>{
  'raw': ?instance.raw?.toJson(),
};

_Raw _$RawFromJson(Map json) => _Raw(language: json['language'] as String?);

Map<String, dynamic> _$RawToJson(_Raw instance) => <String, dynamic>{
  'language': ?instance.language,
};

_Formdatum _$FormdatumFromJson(Map json) => _Formdatum(
  key: json['key'] as String?,
  value: json['value'] as String?,
  type: json['type'] as String?,
  src: json['src'] as String?,
);

Map<String, dynamic> _$FormdatumToJson(_Formdatum instance) =>
    <String, dynamic>{
      'key': ?instance.key,
      'value': ?instance.value,
      'type': ?instance.type,
      'src': ?instance.src,
    };
