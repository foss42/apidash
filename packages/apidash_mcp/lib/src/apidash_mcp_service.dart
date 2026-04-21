import 'dart:io';

import 'package:apidash_cli/models/cli_models.dart';
import 'package:apidash_cli/services/request_executor.dart';
import 'package:apidash_cli/storage/cli_storage.dart';

class ApiDashMcpService {
  bool _storageReady = false;
  String? _storageError;

  bool get storageReady => _storageReady;
  String? get storageError => _storageError;

  Future<void> initialize() async {
    try {
      await CliStorage.init();
      _storageReady = true;
      _storageError = null;
    } on FileSystemException catch (e) {
      _storageReady = false;
      _storageError = _formatStorageError(e);
    } catch (e) {
      _storageReady = false;
      _storageError = 'Failed to initialize API Dash storage: $e';
    }
  }

  Map<String, Object?> status() {
    return {
      'storageReady': _storageReady,
      'storageError': _storageError,
      'note': _storageReady
          ? 'Storage initialized. All tools are available.'
          : 'Storage is unavailable. Close API Dash GUI if lock conflict exists.',
    };
  }

  Future<Map<String, Object?>> runRequest(Map<String, Object?> args) async {
    final directUrl = _readString(args, ['url']);
    final requestId = _readString(args, ['requestId', 'id']);
    final requestName = _readString(args, ['requestName']);
    final label = _readString(args, ['label', 'name']);

    if (directUrl == null && requestId == null && requestName == null) {
      throw ArgumentError(
        'Provide one of: url, requestId, or requestName.',
      );
    }

    late final CliRequest target;

    if (directUrl != null) {
      final method = _parseHttpMethod(_readString(args, ['method']));
      final headers = _parseHeaders(args['headers']);
      final body = _readString(args, ['data', 'body']);

      if (body != null && !method.supportsBody) {
        throw ArgumentError(
          'HTTP ${method.upperName} does not support request body.',
        );
      }

      target = CliRequest(
        id: 'mcp_${DateTime.now().microsecondsSinceEpoch}',
        name: label ?? 'MCP ${method.upperName} $directUrl',
        apiType: CliApiType.rest,
        httpRequestModel: CliHttpRequest(
          method: method,
          url: directUrl,
          headers: headers,
          isHeaderEnabledList: List<bool>.filled(headers.length, true),
          body: body,
        ),
      );
    } else {
      _requireStorage();
      final requests = CliStorage.getAllRequests();

      if (requestId != null) {
        target = requests.firstWhere(
          (r) => r.id == requestId,
          orElse: () => throw ArgumentError('No request found for id: $requestId'),
        );
      } else {
        final query = requestName!.toLowerCase();
        final matches = requests
            .where((r) => r.name.toLowerCase().contains(query))
            .toList();

        if (matches.isEmpty) {
          throw ArgumentError('No request found for name: $requestName');
        }
        if (matches.length > 1) {
          throw ArgumentError(
            'Multiple requests matched "$requestName". Use requestId instead.',
          );
        }
        target = matches.first;
      }
    }

    final runResult = await _executeAndPersist(target);
    return {
      ...runResult,
      'source': directUrl != null ? 'directUrl' : 'savedRequest',
    };
  }

  Future<Map<String, Object?>> rerunHistory(Map<String, Object?> args) async {
    _requireStorage();
    final historyId = _readString(args, ['historyId']);
    if (historyId == null || historyId.isEmpty) {
      throw ArgumentError('historyId is required.');
    }

    final history = await CliStorage.getHistory();
    final entry = history.firstWhere(
      (item) => item.id == historyId,
      orElse: () => throw ArgumentError('No history entry found for id: $historyId'),
    );

    final baseRequest = entry.toCliRequest();
    final overrideUrl = _readString(args, ['url']);
    final overrideMethodRaw = _readString(args, ['method']);
    final overrideBody = _readString(args, ['data', 'body']);
    final overrideLabel = _readString(args, ['label', 'name']);
    final overrideHeadersRaw = args['headers'];

    final method = overrideMethodRaw == null
        ? baseRequest.method
        : _parseHttpMethod(overrideMethodRaw);

    final headers = overrideHeadersRaw == null
        ? baseRequest.httpRequestModel.headers
        : _parseHeaders(overrideHeadersRaw);

    final body = overrideBody ?? baseRequest.httpRequestModel.body;
    if (body != null && body.isNotEmpty && !method.supportsBody) {
      throw ArgumentError(
        'HTTP ${method.upperName} does not support request body.',
      );
    }

    final request = CliRequest(
      id: baseRequest.id,
      name: overrideLabel ?? '${baseRequest.name} (rerun)',
      apiType: baseRequest.apiType,
      httpRequestModel: CliHttpRequest(
        method: method,
        url: overrideUrl ?? baseRequest.url,
        headers: headers,
        params: baseRequest.httpRequestModel.params,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        isParamEnabledList: baseRequest.httpRequestModel.isParamEnabledList,
        bodyContentType: baseRequest.httpRequestModel.bodyContentType,
        body: body,
        query: baseRequest.httpRequestModel.query,
        formData: baseRequest.httpRequestModel.formData,
        authModel: baseRequest.httpRequestModel.authModel,
      ),
      preRequestScript: baseRequest.preRequestScript,
      postRequestScript: baseRequest.postRequestScript,
      aiRequestModel: baseRequest.aiRequestModel,
    );

    final runResult = await _executeAndPersist(request);
    return {
      ...runResult,
      'source': 'historyRerun',
      'originalHistoryId': historyId,
    };
  }

  Future<Map<String, Object?>> searchRequests(Map<String, Object?> args) async {
    _requireStorage();
    final query = _readString(args, ['query']);
    final method = _readString(args, ['method'])?.toUpperCase();
    final limit = _readInt(args, 'limit') ?? 50;

    var requests = CliStorage.getAllRequests();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      requests = requests
          .where((r) =>
              r.name.toLowerCase().contains(q) ||
              r.url.toLowerCase().contains(q))
          .toList();
    }

    if (method != null && method.isNotEmpty) {
      requests = requests
          .where((r) => r.method.name.toUpperCase() == method)
          .toList();
    }

    final items = requests
        .take(limit <= 0 ? requests.length : limit)
        .map(_requestSummary)
        .toList();

    return {
      'count': items.length,
      'items': items,
    };
  }

  Future<Map<String, Object?>> listHistory(Map<String, Object?> args) async {
    _requireStorage();
    final last = _readInt(args, 'last') ?? 10;
    final includeBodyPreview = _readBool(args, 'includeBodyPreview') ?? false;
    final query = _readString(args, ['query']);
    final method = _readString(args, ['method'])?.toUpperCase();

    var history = (await CliStorage.getHistory()).reversed.toList();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      history = history
          .where((h) =>
              h.name.toLowerCase().contains(q) ||
              h.url.toLowerCase().contains(q))
          .toList();
    }

    if (method != null && method.isNotEmpty) {
      history = history
          .where((h) => h.method.name.toUpperCase() == method)
          .toList();
    }

    final selected = history.take(last <= 0 ? history.length : last).toList();
    final items = selected
        .map((h) => _historySummary(h, includeBodyPreview: includeBodyPreview))
        .toList();

    return {
      'count': items.length,
      'items': items,
    };
  }

  Future<Map<String, Object?>> getHistoryEntry(
    Map<String, Object?> args,
  ) async {
    _requireStorage();
    final historyId = _readString(args, ['historyId']);
    if (historyId == null || historyId.isEmpty) {
      throw ArgumentError('historyId is required.');
    }

    final history = await CliStorage.getHistory();
    final entry = history.firstWhere(
      (h) => h.id == historyId,
      orElse: () => throw ArgumentError('No history entry found for id: $historyId'),
    );

    return {
      'item': {
        ..._historySummary(entry, includeBodyPreview: true),
        'request': _requestSummary(entry.toCliRequest()),
        'response': _responseSummary(entry.httpResponseModel),
      },
    };
  }

  Future<Map<String, Object?>> _executeAndPersist(CliRequest target) async {
    final (resp, dur, err) = await executeCliRequest(target);

    var responseModel = resp;
    if (responseModel == null && err != null) {
      responseModel = CliHttpResponse(statusCode: 0, body: err, time: dur);
    }

    final completed = target.copyWith(httpResponseModel: responseModel);
    var historySaved = false;

    if (_storageReady) {
      await CliStorage.saveToHistory(completed);
      historySaved = true;
    }

    return {
      'ok': err == null,
      'request': _requestSummary(completed),
      'response': _responseSummary(responseModel),
      'durationMs': dur?.inMilliseconds,
      'error': err,
      'historySaved': historySaved,
      'storageReady': _storageReady,
      'storageError': _storageError,
    };
  }

  Map<String, Object?> _requestSummary(CliRequest request) {
    return {
      'id': request.id,
      'name': request.name,
      'apiType': request.apiType.name,
      'method': request.method.upperName,
      'url': request.url,
      'headers': request.httpRequestModel.enabledHeadersMap,
      'body': request.httpRequestModel.body,
    };
  }

  Map<String, Object?> _historySummary(
    CliHistoryEntry entry, {
    required bool includeBodyPreview,
  }) {
    String? bodyPreview;
    if (includeBodyPreview) {
      final body = entry.httpResponseModel?.body;
      if (body != null) {
        bodyPreview = body.length > 400 ? '${body.substring(0, 400)}...' : body;
      }
    }

    return {
      'historyId': entry.id,
      'requestId': entry.requestId,
      'name': entry.name,
      'apiType': entry.apiType.name,
      'method': entry.method.upperName,
      'url': entry.url,
      'statusCode': entry.httpResponseModel?.statusCode,
      'durationMs': entry.httpResponseModel?.time?.inMilliseconds,
      'timestamp': entry.timeStamp?.toIso8601String(),
      ...switch (bodyPreview) {
        final String preview => <String, Object?>{'bodyPreview': preview},
        _ => const <String, Object?>{},
      },
    };
  }

  Map<String, Object?> _responseSummary(CliHttpResponse? response) {
    if (response == null) {
      return {
        'statusCode': null,
        'headers': null,
        'body': null,
        'durationMs': null,
      };
    }

    return {
      'statusCode': response.statusCode,
      'headers': response.headers,
      'body': response.body,
      'durationMs': response.time?.inMilliseconds,
    };
  }

  void _requireStorage() {
    if (_storageReady) {
      return;
    }
    throw StateError(
      _storageError ??
          'API Dash storage is not initialized. Ensure no lock conflicts exist.',
    );
  }

  CliHttpVerb _parseHttpMethod(String? rawMethod) {
    if (rawMethod == null || rawMethod.trim().isEmpty) {
      return CliHttpVerb.get;
    }

    final normalized = rawMethod.trim().toLowerCase();
    for (final verb in CliHttpVerb.values) {
      if (verb.name == normalized) {
        return verb;
      }
    }

    throw ArgumentError(
      'Unsupported HTTP method: $rawMethod. Supported: '
      '${CliHttpVerb.values.map((v) => v.upperName).join(', ')}',
    );
  }

  List<CliNameValue> _parseHeaders(Object? rawHeaders) {
    if (rawHeaders == null) {
      return const <CliNameValue>[];
    }

    final headers = <CliNameValue>[];

    if (rawHeaders is Map) {
      for (final entry in rawHeaders.entries) {
        final key = entry.key.toString().trim();
        final value = entry.value?.toString() ?? '';
        if (key.isNotEmpty) {
          headers.add(CliNameValue(name: key, value: value));
        }
      }
      return headers;
    }

    if (rawHeaders is List) {
      for (final item in rawHeaders) {
        if (item is String) {
          final idx = item.indexOf(':');
          if (idx <= 0) {
            continue;
          }
          final key = item.substring(0, idx).trim();
          final value = item.substring(idx + 1).trim();
          if (key.isNotEmpty) {
            headers.add(CliNameValue(name: key, value: value));
          }
          continue;
        }

        if (item is Map) {
          final key = item['name']?.toString().trim() ?? '';
          final value = item['value']?.toString() ?? '';
          if (key.isNotEmpty) {
            headers.add(CliNameValue(name: key, value: value));
          }
        }
      }
      return headers;
    }

    throw ArgumentError(
      'headers must be an object map, list of strings, or list of {name,value}.',
    );
  }

  String? _readString(Map<String, Object?> map, List<String> keys) {
    for (final key in keys) {
      final raw = map[key];
      if (raw is String) {
        final trimmed = raw.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
      }
    }
    return null;
  }

  int? _readInt(Map<String, Object?> map, String key) {
    final raw = map[key];
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.toInt();
    }
    if (raw is String) {
      return int.tryParse(raw.trim());
    }
    return null;
  }

  bool? _readBool(Map<String, Object?> map, String key) {
    final raw = map[key];
    if (raw is bool) {
      return raw;
    }
    if (raw is String) {
      final normalized = raw.toLowerCase().trim();
      if (normalized == 'true') {
        return true;
      }
      if (normalized == 'false') {
        return false;
      }
    }
    return null;
  }

  String _formatStorageError(FileSystemException e) {
    final path = e.path;
    final code = e.osError?.errorCode;
    final message = e.message;

    final maybeLockConflict = code == 33 ||
        (path != null && path.toLowerCase().contains('.lock'));

    if (maybeLockConflict) {
      return 'API Dash Hive storage is locked by another process. '
          'Close API Dash GUI and retry. '
          'Path: ${path ?? 'unknown'}';
    }

    return 'Storage initialization failed: $message';
  }
}
