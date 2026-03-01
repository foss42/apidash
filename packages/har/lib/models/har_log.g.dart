// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'har_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HarLog _$HarLogFromJson(Map json) => _HarLog(
  log: json['log'] == null
      ? null
      : Log.fromJson(Map<String, dynamic>.from(json['log'] as Map)),
);

Map<String, dynamic> _$HarLogToJson(_HarLog instance) => <String, dynamic>{
  'log': ?instance.log?.toJson(),
};

_Log _$LogFromJson(Map json) => _Log(
  version: json['version'] as String?,
  creator: json['creator'] == null
      ? null
      : Creator.fromJson(Map<String, dynamic>.from(json['creator'] as Map)),
  entries: (json['entries'] as List<dynamic>?)
      ?.map((e) => Entry.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$LogToJson(_Log instance) => <String, dynamic>{
  'version': ?instance.version,
  'creator': ?instance.creator?.toJson(),
  'entries': ?instance.entries?.map((e) => e.toJson()).toList(),
};

_Creator _$CreatorFromJson(Map json) => _Creator(
  name: json['name'] as String?,
  version: json['version'] as String?,
);

Map<String, dynamic> _$CreatorToJson(_Creator instance) => <String, dynamic>{
  'name': ?instance.name,
  'version': ?instance.version,
};

_Entry _$EntryFromJson(Map json) => _Entry(
  startedDateTime: json['startedDateTime'] as String?,
  time: (json['time'] as num?)?.toInt(),
  request: json['request'] == null
      ? null
      : Request.fromJson(Map<String, dynamic>.from(json['request'] as Map)),
  response: json['response'] == null
      ? null
      : Response.fromJson(Map<String, dynamic>.from(json['response'] as Map)),
);

Map<String, dynamic> _$EntryToJson(_Entry instance) => <String, dynamic>{
  'startedDateTime': ?instance.startedDateTime,
  'time': ?instance.time,
  'request': ?instance.request?.toJson(),
  'response': ?instance.response?.toJson(),
};

_Request _$RequestFromJson(Map json) => _Request(
  method: json['method'] as String?,
  url: json['url'] as String?,
  httpVersion: json['httpVersion'] as String?,
  cookies: json['cookies'] as List<dynamic>?,
  headers: (json['headers'] as List<dynamic>?)
      ?.map((e) => Header.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  queryString: (json['queryString'] as List<dynamic>?)
      ?.map((e) => Query.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  postData: json['postData'] == null
      ? null
      : PostData.fromJson(Map<String, dynamic>.from(json['postData'] as Map)),
  headersSize: (json['headersSize'] as num?)?.toInt(),
  bodySize: (json['bodySize'] as num?)?.toInt(),
);

Map<String, dynamic> _$RequestToJson(_Request instance) => <String, dynamic>{
  'method': ?instance.method,
  'url': ?instance.url,
  'httpVersion': ?instance.httpVersion,
  'cookies': ?instance.cookies,
  'headers': ?instance.headers?.map((e) => e.toJson()).toList(),
  'queryString': ?instance.queryString?.map((e) => e.toJson()).toList(),
  'postData': ?instance.postData?.toJson(),
  'headersSize': ?instance.headersSize,
  'bodySize': ?instance.bodySize,
};

_PostData _$PostDataFromJson(Map json) => _PostData(
  mimeType: json['mimeType'] as String?,
  text: json['text'] as String?,
  params: (json['params'] as List<dynamic>?)
      ?.map((e) => Param.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$PostDataToJson(_PostData instance) => <String, dynamic>{
  'mimeType': ?instance.mimeType,
  'text': ?instance.text,
  'params': ?instance.params?.map((e) => e.toJson()).toList(),
};

_Param _$ParamFromJson(Map json) => _Param(
  name: json['name'] as String?,
  value: json['value'] as String?,
  fileName: json['fileName'] as String?,
  contentType: json['contentType'] as String?,
  disabled: json['disabled'] as bool?,
);

Map<String, dynamic> _$ParamToJson(_Param instance) => <String, dynamic>{
  'name': ?instance.name,
  'value': ?instance.value,
  'fileName': ?instance.fileName,
  'contentType': ?instance.contentType,
  'disabled': ?instance.disabled,
};

_Query _$QueryFromJson(Map json) => _Query(
  name: json['name'] as String?,
  value: json['value'] as String?,
  disabled: json['disabled'] as bool?,
);

Map<String, dynamic> _$QueryToJson(_Query instance) => <String, dynamic>{
  'name': ?instance.name,
  'value': ?instance.value,
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

_Response _$ResponseFromJson(Map json) => _Response(
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

Map<String, dynamic> _$ResponseToJson(_Response instance) => <String, dynamic>{
  'status': ?instance.status,
  'statusText': ?instance.statusText,
  'httpVersion': ?instance.httpVersion,
  'cookies': ?instance.cookies,
  'headers': ?instance.headers,
  'content': ?instance.content?.toJson(),
  'redirectURL': ?instance.redirectURL,
  'headersSize': ?instance.headersSize,
  'bodySize': ?instance.bodySize,
};

_Content _$ContentFromJson(Map json) => _Content(
  size: (json['size'] as num?)?.toInt(),
  mimeType: json['mimeType'] as String?,
);

Map<String, dynamic> _$ContentToJson(_Content instance) => <String, dynamic>{
  'size': ?instance.size,
  'mimeType': ?instance.mimeType,
};
