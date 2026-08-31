import 'dart:convert';
import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

/// Reads the SAME `apidash-data` Hive box the desktop GUI writes.
/// Copies the box to a temp dir and opens it there, so it works even while
/// the desktop app has the original open/locked (shadow-copy, read-only).
class StorageHelper {
  final String dataDir;
  final Logger logger;
  late final String tempPath;

  StorageHelper(this.dataDir, this.logger) {
    tempPath = p.join(Directory.systemTemp.path,
        'apidash_cli_${DateTime.now().microsecondsSinceEpoch}');
  }

  bool get exists =>
      File(p.join(dataDir, 'apidash-data.hive')).existsSync();

  Future<Box> _open() async {
    Directory(tempPath).createSync(recursive: true);
    Hive.init(tempPath);
    File(p.join(dataDir, 'apidash-data.hive'))
        .copySync(p.join(tempPath, 'apidash-data.hive'));
    return Hive.openBox('apidash-data');
  }

  /// All saved requests as JSON-clean maps (RequestModel.toJson shape).
  Future<List<Map<String, dynamic>>> getRequests() async {
    if (!exists) return [];
    final box = await _open();
    final ids = box.get('ids') as List?;
    if (ids == null) return [];
    return [
      for (final id in ids)
        if (box.get(id) != null) _clean(box.get(id)),
    ];
  }

  /// One saved request by id, JSON-clean; null if absent.
  Future<Map<String, dynamic>?> getRequest(String id) async {
    if (!exists) return null;
    final box = await _open();
    final data = box.get(id);
    return data == null ? null : _clean(data);
  }

  // Hive returns Map<dynamic,dynamic> with nested dynamic maps; the values
  // originate from *.toJson() so a JSON round-trip yields clean String keys
  // that freezed's fromJson accepts.
  Map<String, dynamic> _clean(dynamic v) =>
      jsonDecode(jsonEncode(v)) as Map<String, dynamic>;

  Future<void> cleanup() async {
    try {
      await Hive.close();
      final d = Directory(tempPath);
      if (d.existsSync()) d.deleteSync(recursive: true);
    } catch (_) {}
  }
}
