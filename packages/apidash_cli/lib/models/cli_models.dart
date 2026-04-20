import 'dart:convert';

import 'package:http/http.dart' as http;

enum CliApiType { rest, ai, graphql }

enum CliHttpVerb { get, head, post, put, patch, delete, options }

extension CliHttpVerbExt on CliHttpVerb {
  bool get supportsBody => this != CliHttpVerb.get && this != CliHttpVerb.head;
  String get upperName => name.toUpperCase();
}

CliApiType parseApiType(Object? value, {CliApiType fallback = CliApiType.rest}) {
  if (value is String) {
    try {
      return CliApiType.values.byName(value);
    } catch (_) {
      return fallback;
    }
  }
  return fallback;
}

CliHttpVerb parseHttpVerb(Object? value, {CliHttpVerb fallback = CliHttpVerb.get}) {
  if (value is String) {
    try {
      return CliHttpVerb.values.byName(value);
    } catch (_) {
      return fallback;
    }
  }
  return fallback;
}

DateTime? parseDateTime(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

Map<String, Object?>? asJsonMap(Object? value) {
  if (value is Map) {
    try {
      return Map<String, Object?>.from(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}

class CliNameValue {
  CliNameValue({required this.name, required this.value});

  final String name;
  final String value;

  factory CliNameValue.fromJson(Map<String, Object?> json) {
    return CliNameValue(
      name: (json['name'] as String?) ?? '',
      value: (json['value'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class CliFormDataField {
  CliFormDataField({
    required this.name,
    required this.value,
    required this.type,
  });

  final String name;
  final String value;
  final String type;

  bool get isText => type == 'text';

  factory CliFormDataField.fromJson(Map<String, Object?> json) {
    return CliFormDataField(
      name: (json['name'] as String?) ?? '',
      value: (json['value'] as String?) ?? '',
      type: (json['type'] as String?) ?? 'text',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'type': type,
    };
  }
}

class CliHttpRequest {
  CliHttpRequest({
    this.method = CliHttpVerb.get,
    this.url = '',
    this.headers = const <CliNameValue>[],
    this.params = const <CliNameValue>[],
    this.isHeaderEnabledList,
    this.isParamEnabledList,
    this.bodyContentType = 'json',
    this.body,
    this.query,
    this.formData = const <CliFormDataField>[],
    this.authModel,
  });

  final CliHttpVerb method;
  final String url;
  final List<CliNameValue> headers;
  final List<CliNameValue> params;
  final List<bool>? isHeaderEnabledList;
  final List<bool>? isParamEnabledList;
  final String bodyContentType;
  final String? body;
  final String? query;
  final List<CliFormDataField> formData;
  final Map<String, Object?>? authModel;

  factory CliHttpRequest.fromJson(Map<String, Object?> json) {
    final headerList = (json['headers'] as List<dynamic>? ?? const <dynamic>[])
        .map((e) => asJsonMap(e))
        .whereType<Map<String, Object?>>()
        .map(CliNameValue.fromJson)
        .toList();
    final paramList = (json['params'] as List<dynamic>? ?? const <dynamic>[])
        .map((e) => asJsonMap(e))
        .whereType<Map<String, Object?>>()
        .map(CliNameValue.fromJson)
        .toList();
    final formDataList =
        (json['formData'] as List<dynamic>? ?? const <dynamic>[])
            .map((e) => asJsonMap(e))
            .whereType<Map<String, Object?>>()
            .map(CliFormDataField.fromJson)
            .toList();

    return CliHttpRequest(
      method: parseHttpVerb(json['method']),
      url: (json['url'] as String?) ?? '',
      headers: headerList,
      params: paramList,
      isHeaderEnabledList:
          (json['isHeaderEnabledList'] as List<dynamic>?)?.map((e) => e == true).toList(),
      isParamEnabledList:
          (json['isParamEnabledList'] as List<dynamic>?)?.map((e) => e == true).toList(),
      bodyContentType: (json['bodyContentType'] as String?) ?? 'json',
      body: json['body'] as String?,
      query: json['query'] as String?,
      formData: formDataList,
      authModel: asJsonMap(json['authModel']),
    );
  }

  List<CliNameValue> get enabledHeaders => _enabledRows(headers, isHeaderEnabledList);

  List<CliNameValue> get enabledParams => _enabledRows(params, isParamEnabledList);

  Map<String, String> get enabledHeadersMap {
    final result = <String, String>{};
    for (final row in enabledHeaders) {
      if (row.name.isNotEmpty) {
        result[row.name] = row.value;
      }
    }
    return result;
  }

  Map<String, String> get enabledParamsMap {
    final result = <String, String>{};
    for (final row in enabledParams) {
      if (row.name.isNotEmpty) {
        result[row.name] = row.value;
      }
    }
    return result;
  }

  bool get hasContentTypeHeader =>
      enabledHeadersMap.keys.any((k) => k.toLowerCase() == 'content-type');

  bool get hasFormDataContentType => bodyContentType == 'formdata';

  String get bodyContentTypeHeader {
    return switch (bodyContentType) {
      'text' => 'text/plain',
      'formdata' => 'multipart/form-data',
      _ => 'application/json',
    };
  }

  Uri? buildUri({String defaultScheme = 'https'}) {
    final input = url.trim();
    if (input.isEmpty) {
      return null;
    }

    Uri? uri = Uri.tryParse(input);
    if (uri == null) {
      return null;
    }

    if (!uri.hasScheme) {
      uri = Uri.tryParse('$defaultScheme://$input');
      if (uri == null) {
        return null;
      }
    }

    final mergedParams = <String, String>{
      ...uri.queryParameters,
      ...enabledParamsMap,
    };

    return uri.replace(queryParameters: mergedParams.isEmpty ? null : mergedParams);
  }

  String? requestBodyFor(CliApiType apiType) {
    if (apiType == CliApiType.graphql) {
      final gql = query?.trim();
      if (gql == null || gql.isEmpty) {
        return null;
      }
      return const JsonEncoder.withIndent('  ').convert({'query': gql});
    }

    if (apiType == CliApiType.rest && method.supportsBody) {
      final payload = body;
      if (payload != null && payload.isNotEmpty) {
        return payload;
      }
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method.name,
      'url': url,
      'headers': headers.map((h) => h.toJson()).toList(),
      'params': params.map((p) => p.toJson()).toList(),
      if (authModel != null) 'authModel': authModel,
      'isHeaderEnabledList': isHeaderEnabledList,
      'isParamEnabledList': isParamEnabledList,
      'bodyContentType': bodyContentType,
      'body': body,
      'query': query,
      'formData': formData.map((f) => f.toJson()).toList(),
    };
  }

  static List<CliNameValue> _enabledRows(
    List<CliNameValue> rows,
    List<bool>? enabled,
  ) {
    if (enabled == null || enabled.length != rows.length) {
      return rows;
    }

    final output = <CliNameValue>[];
    for (var i = 0; i < rows.length; i++) {
      if (enabled[i]) {
        output.add(rows[i]);
      }
    }
    return output;
  }
}

class CliHttpResponse {
  CliHttpResponse({
    this.statusCode,
    this.headers,
    this.requestHeaders,
    this.body,
    this.bodyBytes,
    this.time,
    this.sseOutput,
  });

  final int? statusCode;
  final Map<String, String>? headers;
  final Map<String, String>? requestHeaders;
  final String? body;
  final List<int>? bodyBytes;
  final Duration? time;
  final List<String>? sseOutput;

  factory CliHttpResponse.fromHttpResponse(
    http.Response response, {
    Duration? time,
  }) {
    return CliHttpResponse(
      statusCode: response.statusCode,
      headers: Map<String, String>.from(response.headers),
      requestHeaders: response.request?.headers,
      body: response.body,
      bodyBytes: response.bodyBytes,
      time: time,
      sseOutput: null,
    );
  }

  factory CliHttpResponse.fromJson(Map<String, Object?> json) {
    return CliHttpResponse(
      statusCode: _asInt(json['statusCode']),
      headers: _asStringMap(json['headers']),
      requestHeaders: _asStringMap(json['requestHeaders']),
      body: json['body'] as String?,
      bodyBytes: _asIntList(json['bodyBytes']),
      time: _asInt(json['time']) == null
          ? null
          : Duration(microseconds: _asInt(json['time'])!),
      sseOutput:
          (json['sseOutput'] as List<dynamic>?)?.whereType<String>().toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'headers': headers,
      'requestHeaders': requestHeaders,
      'body': body,
      'formattedBody': body,
      'bodyBytes': bodyBytes,
      'time': time?.inMicroseconds,
      'sseOutput': sseOutput,
    };
  }

  static Map<String, String>? _asStringMap(Object? value) {
    if (value is Map) {
      final output = <String, String>{};
      for (final entry in value.entries) {
        final key = entry.key;
        final val = entry.value;
        if (key is String && val is String) {
          output[key] = val;
        }
      }
      return output;
    }
    return null;
  }

  static List<int>? _asIntList(Object? value) {
    if (value is List) {
      return value.whereType<num>().map((e) => e.toInt()).toList();
    }
    return null;
  }

  static int? _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }
}

class CliRequest {
  CliRequest({
    required this.id,
    required this.name,
    required this.apiType,
    required this.httpRequestModel,
    this.httpResponseModel,
    this.preRequestScript,
    this.postRequestScript,
    this.aiRequestModel,
  });

  final String id;
  final String name;
  final CliApiType apiType;
  final CliHttpRequest httpRequestModel;
  final CliHttpResponse? httpResponseModel;
  final String? preRequestScript;
  final String? postRequestScript;
  final Map<String, Object?>? aiRequestModel;

  String get url => httpRequestModel.url;
  CliHttpVerb get method => httpRequestModel.method;
  List<CliNameValue> get enabledHeaders => httpRequestModel.enabledHeaders;

  factory CliRequest.fromJson(Map<String, Object?> json) {
    final requestJson = asJsonMap(json['httpRequestModel']);
    final responseJson = asJsonMap(json['httpResponseModel']);

    return CliRequest(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      apiType: parseApiType(json['apiType']),
      httpRequestModel: requestJson == null
          ? CliHttpRequest()
          : CliHttpRequest.fromJson(requestJson),
      httpResponseModel: responseJson == null
          ? null
          : CliHttpResponse.fromJson(responseJson),
      preRequestScript: json['preRequestScript'] as String?,
      postRequestScript: json['postRequestScript'] as String?,
      aiRequestModel: asJsonMap(json['aiRequestModel']),
    );
  }

  CliRequest copyWith({
    CliHttpResponse? httpResponseModel,
  }) {
    return CliRequest(
      id: id,
      name: name,
      apiType: apiType,
      httpRequestModel: httpRequestModel,
      httpResponseModel: httpResponseModel ?? this.httpResponseModel,
      preRequestScript: preRequestScript,
      postRequestScript: postRequestScript,
      aiRequestModel: aiRequestModel,
    );
  }

  Map<String, dynamic> toHistoryMetaJson({
    required String historyId,
    required DateTime timeStamp,
    required int responseStatus,
  }) {
    return {
      'historyId': historyId,
      'requestId': id,
      'apiType': apiType.name,
      'name': name,
      'url': url,
      'method': method.name,
      'responseStatus': responseStatus,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  Map<String, dynamic> toHistoryRequestJson({
    required String historyId,
    required Map<String, dynamic> metaData,
    required CliHttpResponse response,
  }) {
    return {
      'historyId': historyId,
      'metaData': metaData,
      'httpRequestModel': httpRequestModel.toJson(),
      if (aiRequestModel != null) 'aiRequestModel': aiRequestModel,
      'httpResponseModel': response.toJson(),
      if (preRequestScript != null) 'preRequestScript': preRequestScript,
      if (postRequestScript != null) 'postRequestScript': postRequestScript,
      if (httpRequestModel.authModel != null)
        'authModel': httpRequestModel.authModel,
    };
  }
}

class CliHistoryEntry {
  CliHistoryEntry({
    required this.id,
    required this.requestId,
    required this.apiType,
    required this.name,
    required this.httpRequestModel,
    required this.httpResponseModel,
    required this.timeStamp,
  });

  final String id;
  final String requestId;
  final CliApiType apiType;
  final String name;
  final CliHttpRequest httpRequestModel;
  final CliHttpResponse? httpResponseModel;
  final DateTime? timeStamp;

  String get url => httpRequestModel.url;
  CliHttpVerb get method => httpRequestModel.method;

  factory CliHistoryEntry.fromHive({
    required String historyId,
    Map<String, Object?>? metaMap,
    Map<String, Object?>? historyMap,
  }) {
    final nestedMetaMap = asJsonMap(historyMap?['metaData']);
    final meta = nestedMetaMap ?? metaMap ?? const <String, Object?>{};

    final requestJson = asJsonMap(historyMap?['httpRequestModel']);
    final responseJson = asJsonMap(historyMap?['httpResponseModel']);

    final requestModel = requestJson == null
        ? CliHttpRequest(
            method: parseHttpVerb(meta['method']),
            url: (meta['url'] as String?) ?? '',
          )
        : CliHttpRequest.fromJson(requestJson);

    return CliHistoryEntry(
      id: historyId,
      requestId: (meta['requestId'] as String?) ?? '',
      apiType: parseApiType(meta['apiType']),
      name: (meta['name'] as String?) ?? ((meta['url'] as String?) ?? ''),
      httpRequestModel: requestModel,
      httpResponseModel: responseJson == null
          ? null
          : CliHttpResponse.fromJson(responseJson),
      timeStamp: parseDateTime(meta['timeStamp']),
    );
  }

  CliRequest toCliRequest() {
    return CliRequest(
      id: requestId.isEmpty ? id : requestId,
      name: name,
      apiType: apiType,
      httpRequestModel: httpRequestModel,
      httpResponseModel: httpResponseModel,
    );
  }
}
