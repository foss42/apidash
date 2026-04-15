import 'dart:io';
import 'package:path/path.dart' as path;
import 'file_service.dart';

class WorkspaceService {
  WorkspaceService({FileService? fileService})
      : _fileService = fileService ?? FileService();

  final FileService _fileService;

  static const String envWorkspacePath = 'APIDASH_WORKSPACE_PATH';

  Future<void> createWorkspace(String workspacePath) async {
    final root = Directory(workspacePath);
    final apidashDir = Directory(path.join(workspacePath, '.apidash'));
    final collectionsDir = Directory(path.join(workspacePath, 'collections'));
    final environmentsDir = Directory(path.join(workspacePath, 'environments'));

// Ensuring all directories exist
    await _fileService.isDirExists(root);
    await _fileService.isDirExists(apidashDir);
    await _fileService.isDirExists(collectionsDir);
    await _fileService.isDirExists(environmentsDir);

    await _fileService.writeJsonFile(
      File(path.join(apidashDir.path, 'meta.json')),
      <String, Object?>{'his_schema_version': '0.1.0'},
    );

    await _fileService.writeJsonFile(
      File(path.join(apidashDir.path, 'workspace.json')),
      <String, Object?>{'active_env': 'global', 'recently_opened': <Object?>[]},
    );

    await _fileService.writeJsonFile(
      File(path.join(environmentsDir.path, 'global.json')),
      <String, Object?>{'name': 'global', 'variables': <Object?>[]},
    );
  }

  Future<String?> resolveWorkspacePath() async {
    final envPath = Platform.environment[envWorkspacePath];
    if (envPath != null && envPath.isNotEmpty) {
      return envPath;
    }
    return null;
  }

  static String shellExportCommand(String workspacePath) {
    return 'export $envWorkspacePath="$workspacePath"';
  }
}
