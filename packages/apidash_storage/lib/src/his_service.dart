import 'dart:convert';
import 'dart:io';
import 'package:apidash_storage/src/services/folder_service.dart';
import 'package:better_networking/better_networking.dart';
import 'package:path/path.dart' as path;
import 'services/collection_service.dart';
import 'services/request_service.dart';
import 'services/workspace_service.dart';

class HisService {
  HisService({required this.workspacePath})
      : _workspaceService = WorkspaceService(),
        _collectionService = CollectionService(workspacePath: workspacePath),
        _folderServices = FolderServices(workspacePath: workspacePath),
        _requestService = RequestService(workspacePath: workspacePath);

  final String workspacePath;
  final WorkspaceService _workspaceService;
  final CollectionService _collectionService;
  final FolderServices _folderServices;
  final RequestService _requestService;

  Future<void> createWorkspace() async {
    await _workspaceService.createWorkspace(workspacePath);
  }

  Future<void> ensureCollection({
    required String collectionId,
    String? collectionName,
  }) async {
    final collectionDir = Directory(
      path.join(workspacePath, 'collections', collectionId),
    );
    if (!await collectionDir.exists()) {
      await _collectionService.createCollection(
        collectionId: collectionId,
        name: collectionName ?? collectionId,
      );
    }
  }

  Future<void> ensureFolder({
    required String collectionId,
    required String folderId,
    String? folderName,
  }) async {
    final folderDir = Directory(
      path.join(workspacePath, 'collections', collectionId, folderId),
    );
    if (!await folderDir.exists()) {
      await _folderServices.createFolder(
        folderId: folderId,
        name: folderName ?? folderId,
        collectionID: collectionId,
      );
    }
  }

  Future<void> saveRequest({
    required String collectionId,
    required String requestId,
    required HttpRequestModel request,
    String? folderId,
    String? requestName,
  }) async {
    await ensureCollection(collectionId: collectionId);
    if (folderId != null) {
      await ensureFolder(
        collectionId: collectionId,
        folderId: folderId,
      );
    }
    await _requestService.saveRequest(
      collectionId: collectionId,
      requestId: requestId,
      request: request,
      requestName: requestName,
      folderId: folderId,
    );
  }

  Future<HttpRequestModel> readRequest({
    required String collectionId,
    required String requestId,
  }) {
    return _requestService.readRequest(
      collectionId: collectionId,
      requestId: requestId,
    );
  }

  static Future<Map<String, dynamic>> loadCollectionTree(
    String workspacePath,
  ) async {
    final collectionsDir = Directory(path.join(workspacePath, 'collections'));
    final collections = <Map<String, dynamic>>[];
    final requestService = RequestService(workspacePath: workspacePath);

    if (await collectionsDir.exists()) {
      final entities = await collectionsDir.list(followLinks: false).toList();
      final collectionDirs = entities.whereType<Directory>().toList()
        ..sort(
          (left, right) =>
              path.basename(left.path).compareTo(path.basename(right.path)),
        );

      for (final collectionDir in collectionDirs) {
        collections.add(
          await _loadCollectionNode(
            collectionDir,
            workspacePath,
            requestService,
          ),
        );
      }
    }

    return <String, dynamic>{
      'type': 'collection_tree',
      'data': <String, dynamic>{'collections': collections},
    };
  }

  static Future<Map<String, dynamic>> _loadCollectionNode(
    Directory collectionDir,
    String workspacePath,
    RequestService requestService,
  ) async {
    final collectionId = path.basename(collectionDir.path);
    final collectionFile = File(
      path.join(collectionDir.path, 'collection.json'),
    );
    final collectionIndex =
        await _readJsonMap(collectionFile) ?? <String, dynamic>{};
    final collectionNode = <String, dynamic>{
      'id': _readString(collectionIndex['id']) ?? collectionId,
      'name': _readString(collectionIndex['name']) ?? collectionId,
      'active_env': _readString(collectionIndex['active_env']) ?? 'global',
    };

    collectionNode['folders'] = await _loadFolderNodes(
      collectionDir: collectionDir,
      workspacePath: workspacePath,
      collectionId: collectionId,
      requestService: requestService,
    );
    collectionNode['requests'] = await requestService
        .loadRequestNodesForCollection(collectionId: collectionId);

    return collectionNode;
  }

  static Future<List<Map<String, dynamic>>> _loadFolderNodes({
    required Directory collectionDir,
    required String workspacePath,
    required String collectionId,
    required RequestService requestService,
  }) async {
    final folderNodes = <Map<String, dynamic>>[];
    final entities = await collectionDir.list(followLinks: false).toList();
    final folderDirs = entities.whereType<Directory>().toList()
      ..sort(
        (left, right) =>
            path.basename(left.path).compareTo(path.basename(right.path)),
      );

    for (final folderDir in folderDirs) {
      final folderId = path.basename(folderDir.path);
      final folderFile = File(path.join(folderDir.path, 'folder.json'));
      final folderIndex = await _readJsonMap(folderFile) ?? <String, dynamic>{};
      final folderNode = <String, dynamic>{
        'id': _readString(folderIndex['id']) ?? folderId,
        'name': _readString(folderIndex['name']) ?? folderId,
      };
      folderNode['requests'] = await requestService.loadRequestNodesForFolder(
        collectionId: collectionId,
        folderId: folderId,
      );

      folderNodes.add(folderNode);
    }

    return folderNodes;
  }

  static Future<Map<String, dynamic>?> _readJsonMap(File file) async {
    if (!await file.exists()) {
      return null;
    }

    try {
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  static String? _readString(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return null;
  }
}
