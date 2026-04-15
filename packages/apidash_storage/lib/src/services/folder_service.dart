import 'dart:io';
import 'package:apidash_storage/src/services/file_service.dart';
import 'package:path/path.dart' as path;

class FolderServices {
  FolderServices({required this.workspacePath, FileService? fileService})
    : _fileService = fileService ?? const FileService();

  final String workspacePath;
  final FileService _fileService;

  Future<void> createFolder({
    required String folderId,
    required String name,
    required String collectionID,
  }) async {
    final folderDir = Directory(
      path.join(workspacePath, 'collections', collectionID, folderId),
    );

    await _fileService.isDirExists(folderDir);

    await _fileService.writeJsonFile(
      File(path.join(folderDir.path, 'folder.json')),
      <String, Object?>{'id': folderId, 'name': name},
    );
  }

  Future<void> upsertRequestIndexEntry({
    required String collectionId,
    required String folderId,
    required String requestId,
    required String method,
    required String url,
    required String name,
    required String file,
  }) async {
    final folderFile = File(
      path.join(
        workspacePath,
        'collections',
        collectionId,
        folderId,
        'folder.json',
      ),
    );

    if (!await folderFile.exists()) {
      throw Exception(
        'Folder not found: $folderId in collection $collectionId',
      );
    }

    final index = await _fileService.readJsonFile(folderFile);
    final currentRequests = (index['requests'] as List?) ?? <Object?>[];

    final updatedRequests = List<Map<String, Object?>>.from(
      currentRequests
          .whereType<Map>()
          .map((e) => Map<String, Object?>.from(e))
          .where((entry) => entry['id'] != requestId),
    );

    updatedRequests.add(<String, Object?>{
      'id': requestId,
      'name': name,
      'method': method,
      'url': url,
      'file': file,
    });

    index['requests'] = updatedRequests;
    await _fileService.writeJsonFile(folderFile, index);
  }
}