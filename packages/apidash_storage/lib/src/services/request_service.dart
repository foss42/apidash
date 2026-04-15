import 'dart:convert';
import 'dart:io';
import 'package:apidash_storage/src/services/folder_service.dart';
import 'package:better_networking/better_networking.dart';
import 'package:path/path.dart' as path;
import 'collection_service.dart';
import 'file_service.dart';

class ResolvedRequestRecord {
  const ResolvedRequestRecord({
    required this.collectionId,
    required this.folderId,
    required this.requestId,
    required this.fileName,
    required this.filePath,
    required this.rawJson,
    required this.requestModel,
  });

  final String collectionId;
  final String? folderId;
  final String requestId;
  final String fileName;
  final String filePath;
  final Map<String, Object?> rawJson;
  final HttpRequestModel requestModel;
}

class RequestService {
  RequestService({
    required this.workspacePath,
    CollectionService? collectionService,
    FileService? fileService,
    FolderServices? folderServices,
  })  : _fileService = fileService ?? const FileService(),
       _collectionService =
           collectionService ?? CollectionService(workspacePath: workspacePath),
       _folderServices =
           folderServices ?? FolderServices(workspacePath: workspacePath);

  final String workspacePath;
  final FileService _fileService;
  final CollectionService _collectionService;
  final FolderServices _folderServices;

  Future<void> saveRequest({
    required String collectionId,
    required String requestId,
    required HttpRequestModel request,
    String? folderId,
    String? requestName,
  }) async {
    final collectionDir = Directory(
      path.join(workspacePath, 'collections', collectionId),
    );

    if (!await collectionDir.exists()) {
      throw Exception('Collection not found: $collectionId');
    }

    final fileName = '$requestId.json';

    late final File requestFile;

    if (folderId != null && folderId.trim().isNotEmpty) {
      final folderDir = Directory(
        path.join(workspacePath, 'collections', collectionId, folderId),
      );
      if (!await folderDir.exists()) {
        throw Exception(
          'Folder not found: $folderId in collection $collectionId',
        );
      }

      requestFile = File(path.join(folderDir.path, fileName));
      await _fileService.writeJsonFile(requestFile, request.toJson());
      await _folderServices.upsertRequestIndexEntry(
        collectionId: collectionId,
        folderId: folderId,
        requestId: requestId,
        method: request.method.name.toUpperCase(),
        url: request.url,
        name: requestName ?? '$request.url',
        file: fileName,
      );
    } else {
      requestFile = File(path.join(collectionDir.path, fileName));
      await _fileService.writeJsonFile(requestFile, request.toJson());
      await _collectionService.upsertRequestIndexEntry(
        collectionId: collectionId,
        requestId: requestId,
        method: request.method.name.toUpperCase(),
        url: request.url,
        name: requestName ?? '$request.url',
        file: fileName,
      );
    }
  }

  Future<HttpRequestModel> readRequest({
    required String collectionId,
    required String requestId,
    String? folderId,
  }) async {
    final requestFile = await _resolveRequestFileInCollection(
      collectionId: collectionId,
      requestId: requestId,
      folderId: folderId,
    );

    if (requestFile == null || !await requestFile.exists()) {
      throw Exception('Request not found: $requestId in $collectionId');
    }

    final json = await _fileService.readJsonFile(requestFile);
    return HttpRequestModel.fromJson(json);
  }

  Future<ResolvedRequestRecord> resolveRequestById({
    required String requestId,
  }) async {
    final normalizedRequestId = requestId.trim();
    if (normalizedRequestId.isEmpty) {
      throw Exception('Request id is required.');
    }

    final collectionsDir = Directory(path.join(workspacePath, 'collections'));
    if (!await collectionsDir.exists()) {
      throw Exception(
        'Collections directory does not exist: ${collectionsDir.path}',
      );
    }

    final entities = await collectionsDir.list(followLinks: false).toList();
    final collectionDirs = entities.whereType<Directory>().toList()
      ..sort(
        (left, right) =>
            path.basename(left.path).compareTo(path.basename(right.path)),
      );

    for (final collectionDir in collectionDirs) {
      final collectionId = path.basename(collectionDir.path);
      final rootFile = File(
        path.join(collectionDir.path, '$normalizedRequestId.json'),
      );
      if (await rootFile.exists()) {
        return _readResolvedRequestFromFile(
          requestFile: rootFile,
          collectionId: collectionId,
          folderId: null,
          requestId: normalizedRequestId,
        );
      }

      final childEntities = await collectionDir
          .list(followLinks: false)
          .toList();
      final folderDirs = childEntities.whereType<Directory>().toList()
        ..sort(
          (left, right) =>
              path.basename(left.path).compareTo(path.basename(right.path)),
        );

      for (final folderDir in folderDirs) {
        final folderId = path.basename(folderDir.path);
        final nestedFile = File(
          path.join(folderDir.path, '$normalizedRequestId.json'),
        );
        if (await nestedFile.exists()) {
          return _readResolvedRequestFromFile(
            requestFile: nestedFile,
            collectionId: collectionId,
            folderId: folderId,
            requestId: normalizedRequestId,
          );
        }
      }
    }

    throw Exception('Request not found by id: $normalizedRequestId');
  }

  Future<Map<String, dynamic>> executeStoredRequestById({
    required String requestId,
  }) async {
    final startedAt = DateTime.now().toUtc();
    final resolved = await resolveRequestById(requestId: requestId);
    final runtimeRequestId =
        'mcp_${resolved.requestId}_${startedAt.microsecondsSinceEpoch}';

    // Add default headers before sending request to bypass CDN/Cloudflare blocks
    final defaultHeaders = <String, String>{
      'User-Agent': 'Mozilla/5.0',
      'Accept': '*/*',
      'Cache-Control': 'no-cache, no-store, max-age=0',
      'Pragma': 'no-cache',
    };

    final existingHeadersMap = rowsToMap(resolved.requestModel.headers) ?? {};
    final mergedHeadersMap = {...defaultHeaders, ...existingHeadersMap};

    // Convert headers to List<NameValueModel>
    final mergedHeadersList = mapToRows(mergedHeadersMap);

    final requestModelWithHeaders = resolved.requestModel.copyWith(
      headers: mergedHeadersList,
    );

    final (resp, dur, err) = await sendHttpRequest(
      runtimeRequestId,
      APIType.rest,
      requestModelWithHeaders,
    );

    if (err != null || resp == null) {
      return <String, dynamic>{
        'ok': false,
        'id': resolved.requestId,
        'request': _buildRequestMeta(resolved),
        'error': err ?? 'Failed to execute request',
        'executedAt': startedAt.toIso8601String(),
        'nonce': startedAt.microsecondsSinceEpoch.toString(),
      };
    }

    final responseModel = const HttpResponseModel().fromResponse(
      response: resp,
      time: dur,
    );
    final responseMap = responseModel.toJson();
    final bodyBytes = responseModel.bodyBytes;
    final contentLength =
        responseModel.headers?[HttpHeaders.contentLengthHeader];
    final parsedSize = int.tryParse(contentLength ?? '');

    return <String, dynamic>{
      'ok': true,
      'id': resolved.requestId,
      'request': _buildRequestMeta(resolved),
      'response': responseMap,
      'render': <String, dynamic>{
        'contentType': responseModel.contentType,
        'bodyBase64': bodyBytes == null ? null : base64Encode(bodyBytes),
        'sizeBytes':
            parsedSize ??
            bodyBytes?.length ??
            (responseModel.body?.length ?? 0),
      },
      'executedAt': startedAt.toIso8601String(),
      'nonce': startedAt.microsecondsSinceEpoch.toString(),
    };
  }

  Future<List<Map<String, dynamic>>> loadRequestNodesForCollection({
    required String collectionId,
  }) async {
    final collectionDir = Directory(
      path.join(workspacePath, 'collections', collectionId),
    );
    final indexById = await _readIndexRequests(
      File(path.join(collectionDir.path, 'collection.json')),
    );

    return _loadRequestNodesFromDirectory(
      directory: collectionDir,
      indexById: indexById,
      collectionId: collectionId,
      folderId: null,
      indexFileName: 'collection.json',
    );
  }

  Future<List<Map<String, dynamic>>> loadRequestNodesForFolder({
    required String collectionId,
    required String folderId,
  }) async {
    final folderDir = Directory(
      path.join(workspacePath, 'collections', collectionId, folderId),
    );
    final indexById = await _readIndexRequests(
      File(path.join(folderDir.path, 'folder.json')),
    );

    return _loadRequestNodesFromDirectory(
      directory: folderDir,
      indexById: indexById,
      collectionId: collectionId,
      folderId: folderId,
      indexFileName: 'folder.json',
    );
  }

  Future<File?> _resolveRequestFileInCollection({
    required String collectionId,
    required String requestId,
    String? folderId,
  }) async {
    if (folderId != null && folderId.trim().isNotEmpty) {
      final nested = File(
        path.join(
          workspacePath,
          'collections',
          collectionId,
          folderId,
          '$requestId.json',
        ),
      );
      if (await nested.exists()) {
        return nested;
      }
      return null;
    }

    final root = File(
      path.join(workspacePath, 'collections', collectionId, '$requestId.json'),
    );
    if (await root.exists()) {
      return root;
    }

    final collectionDir = Directory(
      path.join(workspacePath, 'collections', collectionId),
    );
    if (!await collectionDir.exists()) {
      return null;
    }

    final entities = await collectionDir.list(followLinks: false).toList();
    for (final folderDir in entities.whereType<Directory>()) {
      final nested = File(path.join(folderDir.path, '$requestId.json'));
      if (await nested.exists()) {
        return nested;
      }
    }
    return null;
  }

  Future<ResolvedRequestRecord> _readResolvedRequestFromFile({
    required File requestFile,
    required String collectionId,
    required String? folderId,
    required String requestId,
  }) async {
    final raw = await _fileService.readJsonFile(requestFile);
    final model = HttpRequestModel.fromJson(raw);
    return ResolvedRequestRecord(
      collectionId: collectionId,
      folderId: folderId,
      requestId: requestId,
      fileName: path.basename(requestFile.path),
      filePath: requestFile.path,
      rawJson: raw,
      requestModel: model,
    );
  }

  Future<Map<String, Map<String, Object?>>> _readIndexRequests(
    File indexFile,
  ) async {
    if (!await indexFile.exists()) {
      return <String, Map<String, Object?>>{};
    }

    try {
      final index = await _fileService.readJsonFile(indexFile);
      final requestList = index['requests'];
      if (requestList is! List) {
        return <String, Map<String, Object?>>{};
      }

      final mapped = <String, Map<String, Object?>>{};
      for (final item in requestList) {
        if (item is! Map) {
          continue;
        }
        final entry = Map<String, Object?>.from(item);
        final id = _readString(entry['id']);
        if (id == null) {
          continue;
        }
        mapped[id] = entry;
      }
      return mapped;
    } catch (_) {
      return <String, Map<String, Object?>>{};
    }
  }

  Future<List<Map<String, dynamic>>> _loadRequestNodesFromDirectory({
    required Directory directory,
    required Map<String, Map<String, Object?>> indexById,
    required String collectionId,
    required String? folderId,
    required String indexFileName,
  }) async {
    if (!await directory.exists()) {
      return <Map<String, dynamic>>[];
    }

    final entities = await directory.list(followLinks: false).toList();
    final requestFiles =
        entities.whereType<File>().where((file) {
          final name = path.basename(file.path);
          return name.endsWith('.json') && name != indexFileName;
        }).toList()..sort(
          (left, right) =>
              path.basename(left.path).compareTo(path.basename(right.path)),
        );

    final nodes = <Map<String, dynamic>>[];

    for (final requestFile in requestFiles) {
      final requestJson = await _safeReadJsonMap(requestFile);
      if (requestJson == null) {
        continue;
      }

      final fallbackId = path.basenameWithoutExtension(requestFile.path);
      final requestId = _readString(requestJson['id']) ?? fallbackId;
      final indexEntry = indexById[requestId];
      final requestModel = _safeParseRequestModel(requestJson);

      final method =
          requestModel?.method.name.toUpperCase() ??
          _readString(requestJson['method']) ??
          'GET';
      final url = requestModel?.url ?? _readString(requestJson['url']) ?? '';
      final name = _deriveRequestName(
        method: method,
        url: url,
        requestId: requestId,
      );

      final sanitizedIndexEntry = indexEntry == null
          ? null
          : (() {
              final entry = Map<String, Object?>.from(indexEntry);
              entry.remove('url');
              return entry;
            })();

      final node = <String, dynamic>{
        ...?sanitizedIndexEntry,
        'id': requestId,
        'name': name,
        'method': method,
        'url': url,
        'file': path.basename(requestFile.path),
        'collectionId': collectionId,
        if (folderId != null) 'folderId': folderId,
        'data': requestJson,
      };
      nodes.add(node);
    }

    return nodes;
  }

  Future<Map<String, Object?>?> _safeReadJsonMap(File file) async {
    try {
      return await _fileService.readJsonFile(file);
    } catch (_) {
      return null;
    }
  }

  HttpRequestModel? _safeParseRequestModel(Map<String, Object?> requestJson) {
    try {
      return HttpRequestModel.fromJson(requestJson);
    } catch (_) {
      return null;
    }
  }

  String _deriveRequestName({
    required String method,
    required String url,
    required String requestId,
  }) {
    final normalizedMethod = method.trim().toUpperCase();
    final normalizedUrl = url.trim();
    if (normalizedMethod.isNotEmpty && normalizedUrl.isNotEmpty) {
      return '$normalizedMethod $normalizedUrl';
    }
    if (normalizedUrl.isNotEmpty) {
      return normalizedUrl;
    }
    return requestId;
  }

  String? _readString(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return null;
  }

  Map<String, dynamic> _buildRequestMeta(ResolvedRequestRecord resolved) {
    return <String, dynamic>{
      'id': resolved.requestId,
      'collectionId': resolved.collectionId,
      'folderId': resolved.folderId,
      'file': resolved.fileName,
      'path': resolved.filePath,
      'data': resolved.rawJson,
      'method': resolved.requestModel.method.name.toUpperCase(),
      'url': resolved.requestModel.url,
    };
  }
}
