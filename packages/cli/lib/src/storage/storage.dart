import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

class StorageHelper {
  final String dataDir;
  final Logger logger;
  late final String tempPath;

  StorageHelper(this.dataDir, this.logger) {
    tempPath = p.join(Directory.systemTemp.path, 'apidash_cli_temp_${DateTime.now().millisecondsSinceEpoch}');
  }

  Future<void> init() async {
    if (!Directory(dataDir).existsSync()) return;
    
    final dir = Directory(tempPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    Hive.init(tempPath);
  }

  Future<Box> _safeOpenBox(String boxName) async {
    final sourceFile = File(p.join(dataDir, '$boxName.hive'));
    if (!sourceFile.existsSync()) {
      throw Exception("Box file not found: ${sourceFile.path}");
    }

    final targetFile = File(p.join(tempPath, '$boxName.hive'));
    sourceFile.copySync(targetFile.path);

    return await Hive.openBox(boxName);
  }

  Future<List<Map<String, dynamic>>> getRequests() async {
    if (!Directory(dataDir).existsSync()) return [];
    try {
      final box = await _safeOpenBox('apidash-data');
      final ids = box.get('ids') as List<dynamic>?;
      if (ids == null) return [];

      final requests = <Map<String, dynamic>>[];
      for (final id in ids) {
        final data = box.get(id);
        if (data != null) {
          requests.add(Map<String, dynamic>.from(data));
        }
      }
      return requests;
    } catch (e) {
      logger.err("Failed to read requests: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getRequest(String id) async {
    if (!Directory(dataDir).existsSync()) return null;
    try {
      final box = await _safeOpenBox('apidash-data');
      final data = box.get(id);
      return data != null ? Map<String, dynamic>.from(data) : null;
    } catch (e) {
      logger.err("Failed to read request $id: $e");
      return null;
    }
  }

  Future<void> cleanup() async {
    try {
      await Future.delayed(Duration(milliseconds: 100));
      if (Directory(tempPath).existsSync()) {
        Directory(tempPath).deleteSync(recursive: true);
      }
    } catch (_) {}
  }
}
