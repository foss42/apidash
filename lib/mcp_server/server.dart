import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:path/path.dart' as p;
import '../mcp/server_core.dart';
import '../mcp/transport.dart';
import 'handlers/resource_handler.dart';
import 'handlers/tool_handler.dart';

class ApidashMcpServer {
  final String hivePath;
  late final ServerCore _serverCore;
  bool _initialized = false;

  ApidashMcpServer({required this.hivePath}) {
    final transport = StdIOTransport();
    _serverCore = ServerCore(transport);
    
    _serverCore.setResourceHandler(HiveResourceHandler());
    _serverCore.setToolHandler(ApidashToolHandler());
  }

  Future<void> _initHive() async {
    if (_initialized) return;
    try {
      stderr.writeln('System-wide Hive initialization...');
      final tempDir = Directory.systemTemp.createTempSync('apidash_mcp_shared_');
      stderr.writeln('Shared temp directory: ${tempDir.path}');
      
      final boxes = ['apidash-data', 'apidash-environments', 'apidash-history-meta', 'apidash-history-lazy'];
      for (final boxName in boxes) {
        final hiveFile = p.join(hivePath, '$boxName.hive');
        final file = File(hiveFile);
        if (file.existsSync()) {
          final size = file.lengthSync();
          stderr.writeln('Copying $boxName.hive ($size bytes) to temp');
          file.copySync(p.join(tempDir.path, '$boxName.hive'));
        } else {
          stderr.writeln('WARN: Source box not found: $hiveFile');
        }
      }

      Hive.init(tempDir.path);
      for (final boxName in boxes) {
        final box = await Hive.openBox(boxName);
        stderr.writeln('Box $boxName opened. Items: ${box.length}');
      }
      stderr.writeln('All Hive boxes opened successfully');
      _initialized = true;
    } catch (e) {
      stderr.writeln('FATAL: Shared Hive initialization failed: $e');
      rethrow;
    }
  }

  Future<void> run() async {
    await _initHive();
    await _serverCore.start();
  }
}
