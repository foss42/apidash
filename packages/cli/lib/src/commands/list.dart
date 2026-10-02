import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import '../storage/storage.dart';
import '../utils/workspace.dart';

/// `apidash list` — list saved requests from the shared workspace.
/// Human: aligned table. `--json`: an array of {id,name,apiType,method,url}.
class ListCommand extends Command<int> {
  final Logger logger;
  ListCommand(this.logger);

  @override
  final name = 'list';
  @override
  final description = 'List saved requests from the workspace.';

  @override
  Future<int> run() async {
    final json = globalResults?['json'] == true;
    final ws = resolveWorkspace(globalResults);
    final storage = StorageHelper(ws, logger);

    try {
      final rows = [
        for (final r in await storage.getRequests())
          {
            'id': r['id'],
            'name': r['name'] ?? '',
            'apiType': r['apiType'] ?? 'rest',
            'method':
                (r['httpRequestModel']?['method'] ?? 'get').toString().toUpperCase(),
            'url': r['httpRequestModel']?['url'] ?? '',
          },
      ];

      if (json) {
        stdout.writeln(const JsonEncoder.withIndent('  ').convert(rows));
        return 0;
      }

      if (rows.isEmpty) {
        logger.info('No requests found (workspace: $ws).');
        return 0;
      }
      for (final r in rows) {
        final method = r['method'].toString().padRight(6);
        logger.info('$method  ${r['name']}  ->  ${r['url']}  [${r['id']}]');
      }
      return 0;
    } finally {
      await storage.cleanup();
    }
  }
}
