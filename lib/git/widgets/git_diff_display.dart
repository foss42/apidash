import 'dart:convert';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/git/models/git_models.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:path/path.dart' as p;

Future<String> resolveGitDiffTitle(
  String workspacePath,
  GitChange change,
) async {
  final fileName = change.path.split('/').last;
  final file = File(p.join(workspacePath, change.path));
  if (!await file.exists()) return fileName;

  try {
    final json = jsonDecode(await file.readAsString());
    if (json is! Map) return fileName;

    if (fileName == kWorkspaceRequestIndexFile) {
      final name = json[kWorkspaceCollectionNameKey]?.toString().trim();
      if (name != null && name.isNotEmpty) return name;
    }
    if (fileName == kWorkspaceRequestFile) {
      final name = json['name']?.toString().trim();
      if (name != null && name.isNotEmpty) return name;
      final http = json['httpRequestModel'];
      if (http is Map) {
        final url = http['url']?.toString().trim();
        if (url != null && url.isNotEmpty) return url;
        final method = http['method']?.toString().trim();
        if (method != null && method.isNotEmpty) {
          return method;
        }
      }
      final parent = p.basename(p.dirname(change.path));
      if (parent.isNotEmpty && parent != kWorkspaceCollectionsDir) {
        return parent;
      }
    }
    if (_isUnderWorkspaceDir(change.path, kWorkspaceWorkflowsDir) &&
        fileName.endsWith(kJsonFileExtension) &&
        fileName != kWorkspaceWorkflowsIndexFile) {
      final name = json['name']?.toString().trim();
      if (name != null && name.isNotEmpty) return name;
      if (fileName.endsWith(kJsonFileExtension)) {
        return fileName.substring(
          0,
          fileName.length - kJsonFileExtension.length,
        );
      }
    }
    if (change.path.contains('/$kWorkspaceCollectionsDir/') &&
        fileName == kWorkspaceCollectionsIndexFile) {
      return 'Collections index';
    }
    if (_isUnderWorkspaceDir(change.path, kWorkspaceEnvironmentsDir) &&
        fileName == kWorkspaceEnvironmentIndexFile) {
      return 'Environments index';
    }
    if (_isUnderWorkspaceDir(change.path, kWorkspaceWorkflowsDir) &&
        fileName == kWorkspaceWorkflowsIndexFile) {
      return 'Workflows index';
    }
  } catch (_) {}

  return fileName;
}

GitDiffChangeKind gitDiffChangeKind(GitChangeType type) {
  return switch (type) {
    GitChangeType.added || GitChangeType.untracked => GitDiffChangeKind.added,
    GitChangeType.deleted => GitDiffChangeKind.removed,
    GitChangeType.modified => GitDiffChangeKind.modified,
    GitChangeType.renamed => GitDiffChangeKind.renamed,
  };
}

bool _isUnderWorkspaceDir(String changePath, String dirName) {
  return changePath == dirName || changePath.startsWith('$dirName/');
}
