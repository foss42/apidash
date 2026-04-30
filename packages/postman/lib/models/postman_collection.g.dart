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
      variable: (json['variable'] as List<dynamic>?)
          ?.map((e) => Variable.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$PostmanCollectionToJson(_PostmanCollection instance) =>
    <String, dynamic>{
      if (instance.info?.toJson() case final value?) 'info': value,
      if (instance.item?.map((e) => e.toJson()).toList() case final value?)
        'item': value,
      if (instance.variable?.map((e) => e.toJson()).toList() case final value?)
        'variable': value,
    };

_Info _$InfoFromJson(Map json) => _Info(
      postmanId: json['_postman_id'] as String?,
      name: json['name'] as String?,
      schema: json['schema'] as String?,
      exporterId: json['_exporter_id'] as String?,
    );

Map<String, dynamic> _$InfoToJson(_Info instance) => <String, dynamic>{
      if (instance.postmanId case final value?) '_postman_id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.schema case final value?) 'schema': value,
      if (instance.exporterId case final value?) '_exporter_id': value,
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
      if (instance.name case final value?) 'name': value,
      if (instance.item?.map((e) => e.toJson()).toList() case final value?)
        'item': value,
      if (instance.request?.toJson() case final value?) 'request': value,
      if (instance.response case final value?) 'response': value,
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
      auth: json['auth'] == null
          ? null
          : PostmanAuth.fromJson(
              Map<String, dynamic>.from(json['auth'] as Map)),
    );

Map<String, dynamic> _$RequestToJson(_Request instance) => <String, dynamic>{
      if (instance.method case final value?) 'method': value,
      if (instance.header?.map((e) => e.toJson()).toList() case final value?)
        'header': value,
      if (instance.body?.toJson() case final value?) 'body': value,
      if (instance.url?.toJson() case final value?) 'url': value,
      if (instance.auth?.toJson() case final value?) 'auth': value,
    };

_Header _$HeaderFromJson(Map json) => _Header(
      key: json['key'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$HeaderToJson(_Header instance) => <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.type case final value?) 'type': value,
      if (instance.disabled case final value?) 'disabled': value,
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
      if (instance.raw case final value?) 'raw': value,
      if (instance.protocol case final value?) 'protocol': value,
      if (instance.host case final value?) 'host': value,
      if (instance.path case final value?) 'path': value,
      if (instance.query?.map((e) => e.toJson()).toList() case final value?)
        'query': value,
    };

_Query _$QueryFromJson(Map json) => _Query(
      key: json['key'] as String?,
      value: json['value'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$QueryToJson(_Query instance) => <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.disabled case final value?) 'disabled': value,
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
      urlencoded: (json['urlencoded'] as List<dynamic>?)
          ?.map((e) => Urlencoded.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$BodyToJson(_Body instance) => <String, dynamic>{
      if (instance.mode case final value?) 'mode': value,
      if (instance.raw case final value?) 'raw': value,
      if (instance.options?.toJson() case final value?) 'options': value,
      if (instance.formdata?.map((e) => e.toJson()).toList() case final value?)
        'formdata': value,
      if (instance.urlencoded?.map((e) => e.toJson()).toList()
          case final value?)
        'urlencoded': value,
    };

_Options _$OptionsFromJson(Map json) => _Options(
      raw: json['raw'] == null
          ? null
          : Raw.fromJson(Map<String, dynamic>.from(json['raw'] as Map)),
    );

Map<String, dynamic> _$OptionsToJson(_Options instance) => <String, dynamic>{
      if (instance.raw?.toJson() case final value?) 'raw': value,
    };

_Raw _$RawFromJson(Map json) => _Raw(
      language: json['language'] as String?,
    );

Map<String, dynamic> _$RawToJson(_Raw instance) => <String, dynamic>{
      if (instance.language case final value?) 'language': value,
    };

_Formdatum _$FormdatumFromJson(Map json) => _Formdatum(
      key: json['key'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      src: json['src'] as String?,
    );

Map<String, dynamic> _$FormdatumToJson(_Formdatum instance) =>
    <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.type case final value?) 'type': value,
      if (instance.src case final value?) 'src': value,
    };

_Urlencoded _$UrlencodedFromJson(Map json) => _Urlencoded(
      key: json['key'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$UrlencodedToJson(_Urlencoded instance) =>
    <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.type case final value?) 'type': value,
      if (instance.disabled case final value?) 'disabled': value,
    };

_PostmanAuth _$PostmanAuthFromJson(Map json) => _PostmanAuth(
      type: json['type'] as String?,
      bearer: (json['bearer'] as List<dynamic>?)
          ?.map(
              (e) => AuthKeyValue.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      basic: (json['basic'] as List<dynamic>?)
          ?.map(
              (e) => AuthKeyValue.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      apikey: (json['apikey'] as List<dynamic>?)
          ?.map(
              (e) => AuthKeyValue.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$PostmanAuthToJson(_PostmanAuth instance) =>
    <String, dynamic>{
      if (instance.type case final value?) 'type': value,
      if (instance.bearer?.map((e) => e.toJson()).toList() case final value?)
        'bearer': value,
      if (instance.basic?.map((e) => e.toJson()).toList() case final value?)
        'basic': value,
      if (instance.apikey?.map((e) => e.toJson()).toList() case final value?)
        'apikey': value,
    };

_AuthKeyValue _$AuthKeyValueFromJson(Map json) => _AuthKeyValue(
      key: json['key'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$AuthKeyValueToJson(_AuthKeyValue instance) =>
    <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.type case final value?) 'type': value,
    };

_Variable _$VariableFromJson(Map json) => _Variable(
      key: json['key'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$VariableToJson(_Variable instance) => <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.type case final value?) 'type': value,
    };
