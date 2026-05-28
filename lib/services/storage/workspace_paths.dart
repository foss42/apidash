import 'package:apidash/consts.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String?> resolveWorkspaceRoot({
  required bool useDesktopPath,
  String? desktopPath,
}) async {
  if (useDesktopPath) {
    if (desktopPath == null || desktopPath.isEmpty) {
      return null;
    }
    return desktopPath;
  }
  final documents = await getApplicationDocumentsDirectory();
  return p.join(documents.path, kDefaultMobileWorkspaceSubpath);
}
