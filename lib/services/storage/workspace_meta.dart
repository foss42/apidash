import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:path/path.dart' as p;

import 'atomic_file_io.dart';

String _workspaceMetaPath(String workspaceRootPath) {
  return p.join(workspaceRootPath, kWorkspaceMetaFile);
}

Future<String?> readWorkspaceName(String workspaceRootPath) async {
  final file = File(_workspaceMetaPath(workspaceRootPath));
  if (!await file.exists()) {
    return null;
  }
  try {
    final decoded = kJsonDecoder.convert(await file.readAsString());
    if (decoded is Map) {
      final name = decoded[kWorkspaceMetaNameKey] as String?;
      if (name != null && name.trim().isNotEmpty) {
        return name.trim();
      }
    }
  } catch (_) {
    return null;
  }
  return null;
}

/// Creates [workspace.json] when missing. Returns the display name to store in prefs.
Future<String> ensureAndReadWorkspaceName(
  String workspaceRootPath, {
  String? preferredName,
}) async {
  final existing = await readWorkspaceName(workspaceRootPath);
  if (existing != null) {
    return existing;
  }
  final trimmed = preferredName?.trim();
  final name = (trimmed != null && trimmed.isNotEmpty)
      ? trimmed
      : p.basename(workspaceRootPath);
  await writeJsonAtomic(
    _workspaceMetaPath(workspaceRootPath),
    {kWorkspaceMetaNameKey: name},
  );
  return name;
}
