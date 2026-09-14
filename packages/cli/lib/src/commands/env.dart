import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import '../storage/storage.dart';
import '../utils/substitute.dart';
import '../utils/workspace.dart';

const _enc = JsonEncoder.withIndent('  ');

/// `apidash env <list|show>` — read environments from the shared workspace's
/// `apidash-environments` Hive box (read-only shadow copy).
class EnvCommand extends Command<int> {
  EnvCommand(Logger logger) {
    addSubcommand(EnvListCommand(logger));
    addSubcommand(EnvShowCommand(logger));
  }

  @override
  final name = 'env';
  @override
  final description = 'Inspect saved environments (list, show).';
}

class EnvListCommand extends Command<int> {
  final Logger logger;
  EnvListCommand(this.logger);

  @override
  final name = 'list';
  @override
  final description = 'List environments (name, id, variable count).';

  @override
  Future<int> run() async {
    final json = globalResults?['json'] == true;
    final ws = resolveWorkspace(globalResults);
    final storage = StorageHelper(ws, logger);
    try {
      final envs = await storage.getEnvironments();
      final rows = [
        for (final e in envs)
          {
            'id': e['id'],
            'name': e['name'] ?? '',
            'variables': (e['values'] as List? ?? const []).length,
          },
      ];
      if (json) {
        stdout.writeln(_enc.convert(rows));
        return 0;
      }
      if (rows.isEmpty) {
        logger.info('No environments found (workspace: $ws).');
        return 0;
      }
      for (final r in rows) {
        logger.info('${r['name']}  [${r['id']}]  (${r['variables']} vars)');
      }
      return 0;
    } finally {
      await storage.cleanup();
    }
  }
}

class EnvShowCommand extends Command<int> {
  final Logger logger;
  EnvShowCommand(this.logger);

  @override
  final name = 'show';
  @override
  final description = 'Show an environment\'s variables: show <name|id>';
  @override
  final invocation = 'apidash env show <name|id>';

  @override
  Future<int> run() async {
    final json = globalResults?['json'] == true;
    if (argResults!.rest.isEmpty) {
      throw UsageException('Missing environment name or id.', usage);
    }
    final query = argResults!.rest.first;
    final storage = StorageHelper(resolveWorkspace(globalResults), logger);
    try {
      final envs = await storage.getEnvironments();
      final match = envs.firstWhere(
        (e) => e['id'] == query || e['name'] == query,
        orElse: () => <String, dynamic>{},
      );
      if (match.isEmpty) {
        if (json) {
          stdout.writeln(_enc.convert({'error': 'Environment not found: $query'}));
        } else {
          logger.err('Environment not found: $query');
        }
        return 3;
      }

      final values = (match['values'] as List? ?? const []);
      if (json) {
        stdout.writeln(_enc.convert({
          'id': match['id'],
          'name': match['name'] ?? '',
          'values': [
            for (final v in values)
              {
                'key': (v as Map)['key'],
                'value': v['value'],
                'type': v['type'] ?? 'variable',
                'enabled': v['enabled'] ?? false,
              },
          ],
        }));
        return 0;
      }

      logger.info('${match['name'] ?? ''}  [${match['id']}]');
      if (values.isEmpty) {
        logger.info('(no variables)');
      }
      for (final v in values) {
        final m = v as Map;
        final flag = m['enabled'] == true ? '' : ' (disabled)';
        final secret = m['type'] == 'secret' ? ' [secret]' : '';
        logger.info('  ${m['key']} = ${m['value']}$secret$flag');
      }
      return 0;
    } finally {
      await storage.cleanup();
    }
  }
}

/// Resolves the global `--env <name|id>` flag into a `{key: value}` map.
/// Returns `(vars, errorCode)`; `errorCode` is non-null (3) only when the
/// named environment is not found. Empty map + null when `--env` is absent.
Future<(Map<String, String>, int?)> resolveEnvVars(
    ArgResults? globalResults, Logger logger) async {
  final query = globalResults?['env'] as String?;
  if (query == null || query.isEmpty) return (<String, String>{}, null);
  final storage = StorageHelper(resolveWorkspace(globalResults), logger);
  try {
    final envs = await storage.getEnvironments();
    final match = envs.firstWhere(
      (e) => e['id'] == query || e['name'] == query,
      orElse: () => <String, dynamic>{},
    );
    if (match.isEmpty) {
      logger.err('Environment not found: $query');
      return (<String, String>{}, 3);
    }
    return (envVarMap(match), null);
  } finally {
    await storage.cleanup();
  }
}
