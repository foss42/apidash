// lib/commands/run_command.dart
import 'dart:io';
import 'package:args/command_runner.dart';
import '../storage/cli_storage.dart';
import '../formatters/response_formatter.dart';
import '../models/cli_models.dart';
import '../services/request_executor.dart';

void _out(String message) => stdout.writeln(message);

class RunCommand extends Command<void> {
  @override
  String get name => 'run';

  @override
  String get description =>
      'Run a saved API request by name/ID or run a direct URL\n'
      'Usage: apidash run --name "Get Users"\n'
      '       apidash run --id <uuid>\n'
      '       apidash run --url https://api.example.com/users\n'
      '       apidash run https://api.example.com/users --method POST --data "{"name":"Ada"}"';

  RunCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help:
            'Saved request name (partial match). In --url mode this is the history label',
      )
      ..addOption('id', abbr: 'i', help: 'Exact request UUID')
      ..addOption(
        'url',
        abbr: 'u',
        help: 'Direct URL to run without requiring a saved request',
      )
      ..addOption(
        'method',
        abbr: 'm',
        help: 'HTTP method for --url mode (GET, POST, PUT...)',
      )
      ..addMultiOption(
        'header',
        abbr: 'H',
        help:
            'Header for --url mode, repeatable. Example: -H "Authorization: Bearer token"',
      )
      ..addOption(
        'data',
        abbr: 'd',
        help: 'Request body payload for --url mode',
      )
      ..addFlag('verbose', abbr: 'v', help: 'Show full headers & metadata')
      ..addOption('env', abbr: 'e', help: 'Environment name to use');
  }

  @override
  Future<void> run() async {
    final name = argResults!['name'] as String?;
    final id = argResults!['id'] as String?;
    final urlOption = argResults!['url'] as String?;
    final methodOption = argResults!['method'] as String?;
    final headerOptions =
        (argResults!['header'] as List<String>?) ?? const <String>[];
    final dataOption = argResults!['data'] as String?;
    final verbose = argResults!['verbose'] as bool;
    final positionalArgs = argResults!.rest;

    if (urlOption != null && positionalArgs.isNotEmpty) {
      throw UsageException(
        'Provide URL using either --url or positional argument, not both.',
        usage,
      );
    }

    String? directUrl = urlOption;
    if (directUrl == null && positionalArgs.isNotEmpty) {
      if (positionalArgs.length != 1) {
        throw UsageException('Provide exactly one positional URL.', usage);
      }
      directUrl = positionalArgs.first;
    }

    final hasDirectOnlyFlags =
        methodOption != null || headerOptions.isNotEmpty || dataOption != null;

    if (directUrl == null && hasDirectOnlyFlags) {
      throw UsageException(
        '--method, --header, and --data require --url or a positional URL.',
        usage,
      );
    }

    if (directUrl != null && id != null) {
      throw UsageException('Cannot combine --id with --url.', usage);
    }

    if (name == null && id == null && directUrl == null) {
      printUsage();
      return;
    }

    late final CliRequest target;

    if (directUrl != null) {
      final trimmedUrl = directUrl.trim();
      if (trimmedUrl.isEmpty) {
        throw UsageException('URL cannot be empty.', usage);
      }

      final method = _parseHttpMethod(methodOption);
      final headers = _parseHeaders(headerOptions);
      final body = dataOption != null && dataOption.trim().isEmpty
          ? null
          : dataOption;

      if (body != null && !method.supportsBody) {
        throw UsageException(
          'HTTP ${method.upperName} does not support --data payloads.',
          usage,
        );
      }

      target = CliRequest(
        id: _newDirectRequestId(),
        name: _resolveDirectRequestName(name, method, trimmedUrl),
        apiType: CliApiType.rest,
        httpRequestModel: CliHttpRequest(
          method: method,
          url: trimmedUrl,
          headers: headers,
          isHeaderEnabledList: List<bool>.filled(headers.length, true),
          body: body,
        ),
      );
    } else {
      // Find matching request from the saved Hive box
      final requests = CliStorage.getAllRequests();

      if (id != null) {
        target = requests.firstWhere(
          (r) => r.id == id,
          orElse: () => throw UsageException('No request with ID: $id', usage),
        );
      } else {
        final matches = requests
            .where((r) => r.name.toLowerCase().contains(name!.toLowerCase()))
            .toList();
        if (matches.isEmpty) {
          throw UsageException('No request matching: "$name"', usage);
        }
        if (matches.length > 1) {
          _out('Multiple matches found:');
          for (final m in matches) {
            _out('  [${m.id}] ${m.name} — ${m.method.name} ${m.url}');
          }
          _out('Use --id to specify one.');
          return;
        }
        target = matches.first;
      }
    }

    _out('▶ Running: ${target.name} [${target.method.name} ${target.url}]');

    if (target.apiType == CliApiType.ai) {
      throw UsageException(
        'AI requests are not supported by the CLI runner yet.',
        usage,
      );
    }

    final (resp, dur, err) = await executeCliRequest(target);

    CliHttpResponse? responseModel = resp;
    if (responseModel == null && err != null) {
      responseModel = CliHttpResponse(statusCode: 0, body: err, time: dur);
    }

    // Save to history
    final completed = target.copyWith(httpResponseModel: responseModel);
    await CliStorage.saveToHistory(completed);

    // Format and print
    ResponseFormatter.print(completed, verbose: verbose);

    if (err != null && responseModel?.statusCode == 0) {
      _out('Request error: $err');
    }
  }

  CliHttpVerb _parseHttpMethod(String? rawMethod) {
    if (rawMethod == null || rawMethod.trim().isEmpty) {
      return CliHttpVerb.get;
    }

    final normalized = rawMethod.trim().toLowerCase();
    for (final verb in CliHttpVerb.values) {
      if (verb.name == normalized) {
        return verb;
      }
    }

    throw UsageException(
      'Unsupported HTTP method: $rawMethod. Use one of: ${CliHttpVerb.values.map((v) => v.upperName).join(', ')}',
      usage,
    );
  }

  List<CliNameValue> _parseHeaders(List<String> rawHeaders) {
    final headers = <CliNameValue>[];

    for (final raw in rawHeaders) {
      final separatorIndex = raw.indexOf(':');
      if (separatorIndex <= 0) {
        throw UsageException(
          'Invalid --header value: "$raw". Use "Key: Value".',
          usage,
        );
      }

      final key = raw.substring(0, separatorIndex).trim();
      final value = raw.substring(separatorIndex + 1).trim();
      if (key.isEmpty) {
        throw UsageException(
          'Invalid --header value: "$raw". Header key cannot be empty.',
          usage,
        );
      }

      headers.add(CliNameValue(name: key, value: value));
    }

    return headers;
  }

  String _resolveDirectRequestName(
    String? providedName,
    CliHttpVerb method,
    String url,
  ) {
    final trimmedName = providedName?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      return trimmedName;
    }
    return 'CLI ${method.upperName} $url';
  }

  String _newDirectRequestId() {
    return 'cli_${DateTime.now().microsecondsSinceEpoch}';
  }
}
