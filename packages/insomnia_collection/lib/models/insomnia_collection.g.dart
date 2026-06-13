// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insomnia_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InsomniaCollection _$InsomniaCollectionFromJson(Map json) =>
    _InsomniaCollection(
      type: json['_type'] as String?,
      exportFormat: json['__export_format'] as num?,
      exportDate: json['__export_date'] as String?,
      exportSource: json['__export_source'] as String?,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => Resource.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$InsomniaCollectionToJson(_InsomniaCollection instance) =>
    <String, dynamic>{
      '_type': ?instance.type,
      '__export_format': ?instance.exportFormat,
      '__export_date': ?instance.exportDate,
      '__export_source': ?instance.exportSource,
      'resources': ?instance.resources?.map((e) => e.toJson()).toList(),
    };

_Resource _$ResourceFromJson(Map json) => _Resource(
  id: json['_id'] as String?,
  parentId: json['parentId'] as String?,
  modified: json['modified'] as num?,
  created: json['created'] as num?,
  url: json['url'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  method: json['method'] as String?,
  body: json['body'] == null
      ? null
      : Body.fromJson(Map<String, dynamic>.from(json['body'] as Map)),
  preRequestScript: json['preRequestScript'] as String?,
  parameters: (json['parameters'] as List<dynamic>?)
      ?.map((e) => Parameter.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  headers: (json['headers'] as List<dynamic>?)
      ?.map((e) => Header.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  authentication: json['authentication'],
  metaSortKey: json['metaSortKey'] as num?,
  isPrivate: json['isPrivate'] as bool?,
  pathParameters: json['pathParameters'] as List<dynamic>?,
  afterResponseScript: json['afterResponseScript'] as String?,
  settingStoreCookies: json['settingStoreCookies'] as bool?,
  settingSendCookies: json['settingSendCookies'] as bool?,
  settingDisableRenderRequestBody:
      json['settingDisableRenderRequestBody'] as bool?,
  settingEncodeUrl: json['settingEncodeUrl'] as bool?,
  settingRebuildPath: json['settingRebuildPath'] as bool?,
  settingFollowRedirects: json['settingFollowRedirects'] as String?,
  environment: json['environment'],
  environmentPropertyOrder: json['environmentPropertyOrder'],
  scope: json['scope'] as String?,
  data: json['data'],
  dataPropertyOrder: json['dataPropertyOrder'],
  color: json['color'],
  cookies: (json['cookies'] as List<dynamic>?)
      ?.map((e) => Cookie.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  fileName: json['fileName'] as String?,
  contents: json['contents'] as String?,
  contentType: json['contentType'] as String?,
  environmentType: json['environmentType'] as String?,
  kvPairData: (json['kvPairData'] as List<dynamic>?)
      ?.map((e) => KVPairDatum.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  type: json['_type'] as String?,
);

Map<String, dynamic> _$ResourceToJson(_Resource instance) => <String, dynamic>{
  '_id': ?instance.id,
  'parentId': ?instance.parentId,
  'modified': ?instance.modified,
  'created': ?instance.created,
  'url': ?instance.url,
  'name': ?instance.name,
  'description': ?instance.description,
  'method': ?instance.method,
  'body': ?instance.body?.toJson(),
  'preRequestScript': ?instance.preRequestScript,
  'parameters': ?instance.parameters?.map((e) => e.toJson()).toList(),
  'headers': ?instance.headers?.map((e) => e.toJson()).toList(),
  'authentication': ?instance.authentication,
  'metaSortKey': ?instance.metaSortKey,
  'isPrivate': ?instance.isPrivate,
  'pathParameters': ?instance.pathParameters,
  'afterResponseScript': ?instance.afterResponseScript,
  'settingStoreCookies': ?instance.settingStoreCookies,
  'settingSendCookies': ?instance.settingSendCookies,
  'settingDisableRenderRequestBody': ?instance.settingDisableRenderRequestBody,
  'settingEncodeUrl': ?instance.settingEncodeUrl,
  'settingRebuildPath': ?instance.settingRebuildPath,
  'settingFollowRedirects': ?instance.settingFollowRedirects,
  'environment': ?instance.environment,
  'environmentPropertyOrder': ?instance.environmentPropertyOrder,
  'scope': ?instance.scope,
  'data': ?instance.data,
  'dataPropertyOrder': ?instance.dataPropertyOrder,
  'color': ?instance.color,
  'cookies': ?instance.cookies?.map((e) => e.toJson()).toList(),
  'fileName': ?instance.fileName,
  'contents': ?instance.contents,
  'contentType': ?instance.contentType,
  'environmentType': ?instance.environmentType,
  'kvPairData': ?instance.kvPairData?.map((e) => e.toJson()).toList(),
  '_type': ?instance.type,
};

_Body _$BodyFromJson(Map json) => _Body(
  mimeType: json['mimeType'] as String?,
  text: json['text'] as String?,
  params: (json['params'] as List<dynamic>?)
      ?.map((e) => Formdatum.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$BodyToJson(_Body instance) => <String, dynamic>{
  'mimeType': ?instance.mimeType,
  'text': ?instance.text,
  'params': ?instance.params?.map((e) => e.toJson()).toList(),
};

_Formdatum _$FormdatumFromJson(Map json) => _Formdatum(
  name: json['name'] as String?,
  value: json['value'] as String?,
  type: json['type'] as String?,
  src: json['fileName'] as String?,
);

Map<String, dynamic> _$FormdatumToJson(_Formdatum instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'value': ?instance.value,
      'type': ?instance.type,
      'fileName': ?instance.src,
    };

_Parameter _$ParameterFromJson(Map json) => _Parameter(
  id: json['id'] as String?,
  name: json['name'] as String?,
  value: json['value'] as String?,
  description: json['description'] as String?,
  disabled: json['disabled'] as bool?,
);

Map<String, dynamic> _$ParameterToJson(_Parameter instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': ?instance.name,
      'value': ?instance.value,
      'description': ?instance.description,
      'disabled': ?instance.disabled,
    };

_Header _$HeaderFromJson(Map json) => _Header(
  name: json['name'] as String?,
  value: json['value'] as String?,
  disabled: json['disabled'] as bool?,
);

Map<String, dynamic> _$HeaderToJson(_Header instance) => <String, dynamic>{
  'name': ?instance.name,
  'value': ?instance.value,
  'disabled': ?instance.disabled,
};

_Cookie _$CookieFromJson(Map json) => _Cookie(
  key: json['key'] as String?,
  value: json['value'] as String?,
  domain: json['domain'] as String?,
  path: json['path'] as String?,
  secure: json['secure'] as bool?,
  httpOnly: json['httpOnly'] as bool?,
  hostOnly: json['hostOnly'] as bool?,
  creation: json['creation'] == null
      ? null
      : DateTime.parse(json['creation'] as String),
  lastAccessed: json['lastAccessed'] == null
      ? null
      : DateTime.parse(json['lastAccessed'] as String),
  sameSite: json['sameSite'] as String?,
  id: json['id'] as String?,
);

Map<String, dynamic> _$CookieToJson(_Cookie instance) => <String, dynamic>{
  'key': ?instance.key,
  'value': ?instance.value,
  'domain': ?instance.domain,
  'path': ?instance.path,
  'secure': ?instance.secure,
  'httpOnly': ?instance.httpOnly,
  'hostOnly': ?instance.hostOnly,
  'creation': ?instance.creation?.toIso8601String(),
  'lastAccessed': ?instance.lastAccessed?.toIso8601String(),
  'sameSite': ?instance.sameSite,
  'id': ?instance.id,
};

_KVPairDatum _$KVPairDatumFromJson(Map json) => _KVPairDatum(
  id: json['id'] as String?,
  name: json['name'] as String?,
  value: json['value'] as String?,
  type: json['type'] as String?,
  enabled: json['enabled'] as bool?,
);

Map<String, dynamic> _$KVPairDatumToJson(_KVPairDatum instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': ?instance.name,
      'value': ?instance.value,
      'type': ?instance.type,
      'enabled': ?instance.enabled,
    };
