import 'package:apidash/consts.dart';

bool isApidashWorkspaceGitPath(String relativePath) {
  final path = relativePath.replaceAll('\\', '/');
  if (path.startsWith('$kWorkspaceCollectionsDir/') ||
      path == kWorkspaceCollectionsDir) {
    return true;
  }
  if (path.startsWith('$kWorkspaceEnvironmentsDir/') ||
      path == kWorkspaceEnvironmentsDir) {
    return !path.endsWith('.local.json');
  }
  if (path.startsWith('$kWorkspaceWorkflowsDir/') ||
      path == kWorkspaceWorkflowsDir) {
    return true;
  }
  return false;
}
