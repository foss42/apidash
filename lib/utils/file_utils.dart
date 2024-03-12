import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:mime_dart/mime_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

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
  return f.last;
}

String getTempFileName() {
  return getNewUuid();
}

Future<FilePickerResult?> pickFile() async {
  FilePickerResult? pickedResult = await FilePicker.platform.pickFiles();
  return pickedResult;
}
