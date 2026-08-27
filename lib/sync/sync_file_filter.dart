import 'package:apidash/consts.dart';
import 'package:path/path.dart' as p;

const _ignoredSyncBasenames = {'.DS_Store', 'Thumbs.db'};

/// Whether a workspace-relative path should be included in LAN sync manifests.
///
bool isSyncablePath(String relativePath) {
  final path = relativePath.replaceAll('\\', '/');
  if (path.isEmpty) {
    return false;
  }
  if (path == '.git' || path.startsWith('.git/')) {
    return false;
  }
  if (path == '.gitignore') {
    return false;
  }
  if (path == '.apidash' || path.startsWith('.apidash/')) {
    return false;
  }
  if (_ignoredSyncBasenames.contains(p.basename(path))) {
    return false;
  }
  if (path.startsWith('history/')) {
    return false;
  }
  if (path.endsWith('.tmp')) {
    return false;
  }
  if (path == 'oauth2_credentials.json' || path == 'oauth1_credentials.json') {
    return false;
  }
  if (path.startsWith('$kWorkspaceEnvironmentsDir/') &&
      path.endsWith('.local.json')) {
    return false;
  }
  return path.startsWith('$kWorkspaceCollectionsDir/') ||
      path.startsWith('$kWorkspaceEnvironmentsDir/') ||
      path.startsWith('$kWorkspaceWorkflowsDir/');
}
