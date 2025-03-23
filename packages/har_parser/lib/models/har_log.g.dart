// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'har_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HarLogImpl _$$HarLogImplFromJson(Map json) => _$HarLogImpl(
      log: json['log'] == null
          ? null
          : Log.fromJson(Map<String, dynamic>.from(json['log'] as Map)),
    );

Map<String, dynamic> _$$HarLogImplToJson(_$HarLogImpl instance) =>
    <String, dynamic>{
      if (instance.log?.toJson() case final value?) 'log': value,
    };

_$LogImpl _$$LogImplFromJson(Map json) => _$LogImpl(
      version: json['version'] as String?,
      creator: json['creator'] == null
          ? null
          : Creator.fromJson(Map<String, dynamic>.from(json['creator'] as Map)),
      entries: (json['entries'] as List<dynamic>?)
          ?.map((e) => Entry.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$LogImplToJson(_$LogImpl instance) => <String, dynamic>{
      if (instance.version case final value?) 'version': value,
      if (instance.creator?.toJson() case final value?) 'creator': value,
      if (instance.entries?.map((e) => e.toJson()).toList() case final value?)
        'entries': value,
    };

_$CreatorImpl _$$CreatorImplFromJson(Map json) => _$CreatorImpl(
      name: json['name'] as String?,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$$CreatorImplToJson(_$CreatorImpl instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.version case final value?) 'version': value,
    };

_$EntryImpl _$$EntryImplFromJson(Map json) => _$EntryImpl(
      startedDateTime: json['startedDateTime'] as String?,
      time: (json['time'] as num?)?.toInt(),
      request: json['request'] == null
          ? null
          : Request.fromJson(Map<String, dynamic>.from(json['request'] as Map)),
      response: json['response'] == null
          ? null
          : Response.fromJson(
              Map<String, dynamic>.from(json['response'] as Map)),
    );

Map<String, dynamic> _$$EntryImplToJson(_$EntryImpl instance) =>
    <String, dynamic>{
      if (instance.startedDateTime case final value?) 'startedDateTime': value,
      if (instance.time case final value?) 'time': value,
      if (instance.request?.toJson() case final value?) 'request': value,
      if (instance.response?.toJson() case final value?) 'response': value,
    };

_$RequestImpl _$$RequestImplFromJson(Map json) => _$RequestImpl(
      method: json['method'] as String?,
      url: json['url'] as String?,
      httpVersion: json['httpVersion'] as String?,
      cookies: json['cookies'] as List<dynamic>?,
      headers: json['headers'] as List<dynamic>?,
      queryString: json['queryString'] as List<dynamic>?,
      postData: (json['postData'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e),
      ),
      headersSize: (json['headersSize'] as num?)?.toInt(),
      bodySize: (json['bodySize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RequestImplToJson(_$RequestImpl instance) =>
    <String, dynamic>{
      if (instance.method case final value?) 'method': value,
      if (instance.url case final value?) 'url': value,
      if (instance.httpVersion case final value?) 'httpVersion': value,
      if (instance.cookies case final value?) 'cookies': value,
      if (instance.headers case final value?) 'headers': value,
      if (instance.queryString case final value?) 'queryString': value,
      if (instance.postData case final value?) 'postData': value,
      if (instance.headersSize case final value?) 'headersSize': value,
      if (instance.bodySize case final value?) 'bodySize': value,
    };

_$ResponseImpl _$$ResponseImplFromJson(Map json) => _$ResponseImpl(
      status: (json['status'] as num?)?.toInt(),
      statusText: json['statusText'] as String?,
      httpVersion: json['httpVersion'] as String?,
      cookies: json['cookies'] as List<dynamic>?,
      headers: json['headers'] as List<dynamic>?,
      content: json['content'] == null
          ? null
          : Content.fromJson(Map<String, dynamic>.from(json['content'] as Map)),
      redirectURL: json['redirectURL'] as String?,
      headersSize: (json['headersSize'] as num?)?.toInt(),
      bodySize: (json['bodySize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ResponseImplToJson(_$ResponseImpl instance) =>
    <String, dynamic>{
      if (instance.status case final value?) 'status': value,
      if (instance.statusText case final value?) 'statusText': value,
      if (instance.httpVersion case final value?) 'httpVersion': value,
      if (instance.cookies case final value?) 'cookies': value,
      if (instance.headers case final value?) 'headers': value,
      if (instance.content?.toJson() case final value?) 'content': value,
      if (instance.redirectURL case final value?) 'redirectURL': value,
      if (instance.headersSize case final value?) 'headersSize': value,
      if (instance.bodySize case final value?) 'bodySize': value,
    };

_$ContentImpl _$$ContentImplFromJson(Map json) => _$ContentImpl(
      size: (json['size'] as num?)?.toInt(),
      mimeType: json['mimeType'] as String?,
    );

Map<String, dynamic> _$$ContentImplToJson(_$ContentImpl instance) =>
    <String, dynamic>{
      if (instance.size case final value?) 'size': value,
      if (instance.mimeType case final value?) 'mimeType': value,
    };
