// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insomnia_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InsomniaCollectionImpl _$$InsomniaCollectionImplFromJson(Map json) =>
    _$InsomniaCollectionImpl(
      type: json['_type'] as String?,
      exportFormat: json['__export_format'] as num?,
      exportDate: json['__export_date'] as String?,
      exportSource: json['__export_source'] as String?,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => Resource.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$InsomniaCollectionImplToJson(
        _$InsomniaCollectionImpl instance) =>
    <String, dynamic>{
      if (instance.type case final value?) '_type': value,
      if (instance.exportFormat case final value?) '__export_format': value,
      if (instance.exportDate case final value?) '__export_date': value,
      if (instance.exportSource case final value?) '__export_source': value,
      if (instance.resources?.map((e) => e.toJson()).toList() case final value?)
        'resources': value,
    };

_$ResourceImpl _$$ResourceImplFromJson(Map json) => _$ResourceImpl(
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
      parameters: (json['parameters'] as List<dynamic>?)
          ?.map((e) => Parameter.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      headers: (json['headers'] as List<dynamic>?)
          ?.map((e) => Header.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      preRequestScript: json['preRequestScript'] as String?,
      metaSortKey: json['metaSortKey'] as num?,
      isPrivate: json['isPrivate'] as bool?,
      afterResponseScript: json['afterResponseScript'] as String?,
      settingSendCookies: json['settingSendCookies'] as bool?,
      settingStoreCookies: json['settingStoreCookies'] as bool?,
      settingDisableRenderRequestBody:
          json['settingDisableRenderRequestBody'] as bool?,
      settingEncodeUrl: json['settingEncodeUrl'] as bool?,
      settingRebuildPath: json['settingRebuildPath'] as bool?,
      settingFollowRedirects: json['settingFollowRedirects'] as String?,
      type: json['_type'] as String?,
    );

Map<String, dynamic> _$$ResourceImplToJson(_$ResourceImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      if (instance.parentId case final value?) 'parentId': value,
      if (instance.modified case final value?) 'modified': value,
      if (instance.created case final value?) 'created': value,
      if (instance.url case final value?) 'url': value,
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      if (instance.method case final value?) 'method': value,
      if (instance.body?.toJson() case final value?) 'body': value,
      if (instance.parameters?.map((e) => e.toJson()).toList()
          case final value?)
        'parameters': value,
      if (instance.headers?.map((e) => e.toJson()).toList() case final value?)
        'headers': value,
      if (instance.preRequestScript case final value?)
        'preRequestScript': value,
      if (instance.metaSortKey case final value?) 'metaSortKey': value,
      if (instance.isPrivate case final value?) 'isPrivate': value,
      if (instance.afterResponseScript case final value?)
        'afterResponseScript': value,
      if (instance.settingSendCookies case final value?)
        'settingSendCookies': value,
      if (instance.settingStoreCookies case final value?)
        'settingStoreCookies': value,
      if (instance.settingDisableRenderRequestBody case final value?)
        'settingDisableRenderRequestBody': value,
      if (instance.settingEncodeUrl case final value?)
        'settingEncodeUrl': value,
      if (instance.settingRebuildPath case final value?)
        'settingRebuildPath': value,
      if (instance.settingFollowRedirects case final value?)
        'settingFollowRedirects': value,
      if (instance.type case final value?) '_type': value,
    };

_$BodyImpl _$$BodyImplFromJson(Map json) => _$BodyImpl(
      mimeType: json['mimeType'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$BodyImplToJson(_$BodyImpl instance) =>
    <String, dynamic>{
      if (instance.mimeType case final value?) 'mimeType': value,
      if (instance.text case final value?) 'text': value,
    };

_$ParameterImpl _$$ParameterImplFromJson(Map json) => _$ParameterImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
      description: json['description'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$$ParameterImplToJson(_$ParameterImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.value case final value?) 'value': value,
      if (instance.description case final value?) 'description': value,
      if (instance.disabled case final value?) 'disabled': value,
    };

_$HeaderImpl _$$HeaderImplFromJson(Map json) => _$HeaderImpl(
      name: json['name'] as String?,
      value: json['value'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$$HeaderImplToJson(_$HeaderImpl instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.value case final value?) 'value': value,
      if (instance.disabled case final value?) 'disabled': value,
    };
