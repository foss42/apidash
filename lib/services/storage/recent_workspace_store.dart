import 'app_config_paths.dart';

/// Remembers the last opened workspace folder (desktop). Not settings — just the path.
Future<String?> readRecentWorkspacePath() async {
  final file = await getRecentWorkspaceFile();
  if (!await file.exists()) {
    return null;
  }
  final path = (await file.readAsString()).trim();
  return path.isEmpty ? null : path;
}

Future<void> writeRecentWorkspacePath(String? path) async {
  final file = await getRecentWorkspaceFile();
  if (path == null || path.isEmpty) {
    if (await file.exists()) {
      await file.delete();
    }
    return;
  }
  final parent = file.parent;
  if (!await parent.exists()) {
    await parent.create(recursive: true);
  }
  await file.writeAsString(path);
}

Future<void> clearRecentWorkspacePath() => writeRecentWorkspacePath(null);
