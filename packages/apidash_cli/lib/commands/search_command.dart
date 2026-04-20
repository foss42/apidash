import 'dart:io';
import 'package:args/command_runner.dart';
import '../storage/cli_storage.dart';

void _out(String message) => stdout.writeln(message);

class SearchCommand extends Command<void> {
  @override
  String get name => 'search';

  @override
  String get description =>
      'Search saved requests by name, URL, or method\n'
      'Usage: apidash search "users"\n'
      '       apidash search --method POST';

  SearchCommand() {
    argParser
      ..addOption('method', abbr: 'm', help: 'Filter by HTTP method (GET, POST…)')
      ..addFlag('json', help: 'Output as JSON');
  }

  @override
  Future<void> run() async {
    final query = argResults!.rest.isNotEmpty ? argResults!.rest.join(' ') : null;
    final method = argResults!['method'] as String?;
    final asJson = argResults!['json'] as bool;

    var requests = CliStorage.getAllRequests();

    if (query != null) {
      final q = query.toLowerCase();
      requests = requests
          .where((r) =>
              r.name.toLowerCase().contains(q) ||
              r.url.toLowerCase().contains(q))
          .toList();
    }

    if (method != null) {
      requests = requests
          .where((r) => r.method.name.toUpperCase() == method.toUpperCase())
          .toList();
    }

    if (requests.isEmpty) {
      _out('No requests found.');
      return;
    }

    if (asJson) {
      // Print as JSON array for scripting/piping
      _out('[');
      for (int i = 0; i < requests.length; i++) {
        final r = requests[i];
        _out('  { "id": "${r.id}", "name": "${r.name}", '
            '"method": "${r.method.name}", "url": "${r.url}" }'
            '${i < requests.length - 1 ? ',' : ''}');
      }
      _out(']');
    } else {
      // Pretty table output
      final separator = '─' * 80;
      _out('\n$separator');
      _out(
          '${'ID'.padRight(36)} ${'Name'.padRight(20)} ${'Method'.padRight(7)} URL');
      _out(separator);
      for (final r in requests) {
        _out('${r.id.padRight(36)} '
            '${r.name.padRight(20)} '
            '${r.method.name.padRight(7)} '
            '${r.url}');
      }
      _out('$separator\n');
      _out('${requests.length} result(s) found.');
    }
  }
}