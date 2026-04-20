import 'dart:io';
import 'package:args/command_runner.dart';
import '../storage/cli_storage.dart';
import '../formatters/response_formatter.dart';

void _out(String message) => stdout.writeln(message);

class LogCommand extends Command<void> {
  @override
  String get name => 'log';

  @override
  String get description =>
      'View request history\n'
      'Usage: apidash log\n'
      '       apidash log --last 5\n'
      '       apidash log --id <uuid> --details';

  LogCommand() {
    argParser
      ..addOption('last', abbr: 'l', help: 'Show last N entries', defaultsTo: '10')
      ..addOption('id', abbr: 'i', help: 'Show full details for a specific history entry')
      ..addFlag('details', abbr: 'd', help: 'Show response body for each entry');
  }

  @override
  Future<void> run() async {
    final last = int.tryParse(argResults!['last'] as String) ?? 10;
    final id = argResults!['id'] as String?;
    final details = argResults!['details'] as bool;

    final history = (await CliStorage.getHistory()).reversed.toList();

    if (id != null) {
      final entry = history.firstWhere((r) => r.id == id,
          orElse: () => throw UsageException('No history entry with ID: $id', usage));
      ResponseFormatter.print(entry.toCliRequest(), verbose: true);
      return;
    }

    final entries = history.take(last).toList();
    if (entries.isEmpty) {
      _out('No history yet. Run some requests with: apidash run --name "..."');
      return;
    }

    final separator = '─' * 90;
    _out('\n$separator');
    _out('${'#'.padRight(4)} ${'Name'.padRight(20)} ${'Method'.padRight(7)}'
        ' ${'Status'.padRight(7)} ${'Time(ms)'.padRight(10)} URL');
    _out(separator);

    for (int i = 0; i < entries.length; i++) {
      final r = entries[i];
      final status = r.httpResponseModel?.statusCode?.toString() ?? '—';
      final ms = r.httpResponseModel?.time?.inMilliseconds.toString() ?? '—';
      _out('${(i + 1).toString().padRight(4)}'
          ' ${r.name.padRight(20)}'
          ' ${r.method.name.padRight(7)}'
          ' ${status.padRight(7)}'
          ' ${ms.padRight(10)}'
          ' ${r.url}');
      if (details && r.httpResponseModel?.body != null) {
        final body = r.httpResponseModel!.body!;
        final preview = body.length > 120 ? '${body.substring(0, 120)}…' : body;
        _out('    ↳ $preview');
      }
    }
    _out('$separator\n');
  }
}