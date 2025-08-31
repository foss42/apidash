import 'dart:io';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:mime_dart/mime_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

const uuid = Uuid();

String getNewUuid() {
  return uuid.v1();
}

String? getFileExtension(String? mimeType) {
  if (mimeType == null) {
    return null;
  }
  return Mime.getExtensionsFromType(mimeType)?[0];
}

Future<String?> getFileDownloadpath(String? name, String? ext) async {
  final Directory? downloadsDir = await getDownloadsDirectory();
  if (downloadsDir != null) {
    name = name ?? getTempFileName();
    ext = (ext != null) ? ".$ext" : "";
    String path = '${downloadsDir.path}/$name$ext';
    int num = 1;
    while (await File(path).exists()) {
      path = '${downloadsDir.path}/$name (${num++})$ext';
    }
    return path;
  }
  return null;
}

Future<String?> getApplicationSupportDirectoryFilePath(
    String name, String? ext) async {
  final Directory tempDir = await getApplicationSupportDirectory();
  name = name;
  ext = (ext != null) ? ".$ext" : "";
  String path = '${tempDir.path}/$name$ext';
  int num = 1;
  while (await File(path).exists()) {
    path = '${tempDir.path}/$name (${num++})$ext';
  }
  return path;
}

Future<void> saveFile(String path, Uint8List content) async {
  final file = File(path);
  await file.writeAsBytes(content);
}

String getShortPath(String path) {
  var f = p.split(path);
  if (f.length > 2) {
    f = f.sublist(f.length - 2);
    return p.join("...", p.joinAll(f));
  }
  return path;
}

String getFilenameFromPath(String path) {
  var f = p.split(path);
  return f.lastOrNull ?? "";
}

String getTempFileName() {
  return getNewUuid();
}

Future<XFile?> pickFile() async {
  XFile? pickedResult = await openFile();
  return pickedResult;
}

Future<File?> loadFileFromPath(String filePath) async {
  try {
    final file = File(filePath);
    if (!await file.exists()) {
      return null;
    }
    return file;
  } catch (e) {
    return null;
  }
}

Future<bool> deleteFileFromPath(String filePath) async {
  try {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}
