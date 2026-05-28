import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<Directory> getAppConfigDirectory() async {
  final support = await getApplicationSupportDirectory();
  final dir = Directory(p.join(support.path, kAppConfigDirName));
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  return dir;
}

Future<File> getRecentWorkspaceFile() async {
  final dir = await getAppConfigDirectory();
  return File(p.join(dir.path, kRecentWorkspaceFileName));
}
