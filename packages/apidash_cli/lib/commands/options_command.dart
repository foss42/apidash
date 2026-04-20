import 'dart:io';

import 'package:args/command_runner.dart';

typedef CommandExecutor = Future<void> Function(List<String> args);

void _out(String message) => stdout.writeln(message);

class OptionsCommand extends Command<void> {
  OptionsCommand({required this.executeArgs});

  final CommandExecutor executeArgs;

  @override
  String get name => 'options';

  @override
  String get description =>
      'Interactive options mode to navigate CLI commands';

  @override
  Future<void> run() async {
    if (!stdin.hasTerminal) {
      throw UsageException(
        'The options command requires an interactive terminal.',
        usage,
      );
    }

    _out('API Dash CLI - Options Mode');
    _out('Choose a number to run a command.');

    while (true) {
      _printMenu();
      final choice = _readLine('Select option');
      switch (choice) {
        case '1':
          await _guidedRunSavedRequest();
          break;
        case '2':
          await _guidedRunDirectUrl();
          break;
        case '3':
          await _guidedSearchSavedRequests();
          break;
        case '4':
          await _guidedViewHistory();
          break;
        case '5':
          await _guidedViewHistoryDetails();
          break;
        case '6':
          await _customCommandMode();
          break;
        case '7':
          await _runCommand(const ['--help']);
          break;
        case '0':
          _out('Exiting options mode.');
          return;
        default:
          _out('Invalid option. Enter a number from the list.');
      }
    }
  }

  void _printMenu() {
    _out('');
    _out('1) Run a saved request');
    _out('2) Run a direct URL');
    _out('3) Search saved requests');
    _out('4) View history list');
    _out('5) View history details by ID');
    _out('6) Enter custom command');
    _out('7) Show CLI help');
    _out('0) Exit');
  }

  Future<void> _guidedRunSavedRequest() async {
    final mode = _readLine('Run by (n)ame or (i)d', defaultValue: 'n')
        .toLowerCase();

    final byId = mode == 'i' || mode == 'id';
    final value = _readLine(byId ? 'Enter request ID' : 'Enter request name');
    if (value.isEmpty) {
      _out('Cancelled. No value provided.');
      return;
    }

    final args = <String>['run', byId ? '--id' : '--name', value];
    if (_yesNo('Verbose output')) {
      args.add('--verbose');
    }

    await _runCommand(args);
  }

  Future<void> _guidedRunDirectUrl() async {
    final url = _readLine('Enter URL');
    if (url.isEmpty) {
      _out('Cancelled. URL is required.');
      return;
    }

    final method = _readLine('HTTP method', defaultValue: 'GET').toUpperCase();
    final label = _readLine('Optional request label (press Enter to skip)');
    final data = _readLine('Optional body payload (press Enter to skip)');

    final headers = <String>[];
    _out('Add headers one by one in "Key: Value" format.');
    while (true) {
      final header = _readLine('Header (blank to continue)');
      if (header.isEmpty) {
        break;
      }
      headers.add(header);
    }

    final args = <String>['run', '--url', url, '--method', method];
    if (label.isNotEmpty) {
      args.addAll(['--name', label]);
    }
    for (final header in headers) {
      args.addAll(['--header', header]);
    }
    if (data.isNotEmpty) {
      args.addAll(['--data', data]);
    }
    if (_yesNo('Verbose output')) {
      args.add('--verbose');
    }

    await _runCommand(args);
  }

  Future<void> _guidedSearchSavedRequests() async {
    final query =
        _readLine('Search text (name or URL, blank for all requests)');
    final method = _readLine('Optional HTTP method filter (blank to skip)');

    final args = <String>['search'];
    if (method.isNotEmpty) {
      args.addAll(['--method', method]);
    }
    if (_yesNo('Output as JSON')) {
      args.add('--json');
    }
    if (query.isNotEmpty) {
      args.add(query);
    }

    await _runCommand(args);
  }

  Future<void> _guidedViewHistory() async {
    final last = _readLine('Show last N entries', defaultValue: '10');

    final args = <String>['log', '--last', last];
    if (_yesNo('Include response body preview')) {
      args.add('--details');
    }

    await _runCommand(args);
  }

  Future<void> _guidedViewHistoryDetails() async {
    final id = _readLine('Enter history ID');
    if (id.isEmpty) {
      _out('Cancelled. History ID is required.');
      return;
    }

    await _runCommand(['log', '--id', id, '--details']);
  }

  Future<void> _customCommandMode() async {
    _out('Example: run --url https://httpbin.org/get --method GET');
    final line = _readLine('Enter command (without "apidash")');
    if (line.isEmpty) {
      _out('Cancelled.');
      return;
    }

    late final List<String> args;
    try {
      args = _splitCommandLine(line);
    } on FormatException catch (e) {
      _out('Unable to parse command: ${e.message}');
      return;
    }

    if (args.isEmpty) {
      _out('Cancelled.');
      return;
    }
    if (args.first == 'options') {
      _out('You are already inside options mode.');
      return;
    }

    await _runCommand(args);
  }

  Future<void> _runCommand(List<String> args) async {
    _out('');
    _out('Running: apidash ${args.join(' ')}');
    try {
      await executeArgs(args);
    } on UsageException catch (e) {
      _out(e.message);
      _out(e.usage);
    } catch (e) {
      _out('Command failed: $e');
    }
  }

  String _readLine(String label, {String? defaultValue}) {
    if (defaultValue != null && defaultValue.isNotEmpty) {
      stdout.write('$label [$defaultValue]: ');
    } else {
      stdout.write('$label: ');
    }

    final line = stdin.readLineSync();
    if (line == null) {
      return defaultValue ?? '';
    }

    final trimmed = line.trim();
    if (trimmed.isEmpty && defaultValue != null) {
      return defaultValue;
    }
    return trimmed;
  }

  bool _yesNo(String label, {bool defaultValue = false}) {
    final suffix = defaultValue ? '[Y/n]' : '[y/N]';
    final value = _readLine('$label $suffix').toLowerCase();
    if (value.isEmpty) {
      return defaultValue;
    }
    return value == 'y' || value == 'yes';
  }

  List<String> _splitCommandLine(String input) {
    final args = <String>[];
    final current = StringBuffer();

    var inSingleQuote = false;
    var inDoubleQuote = false;
    var escaped = false;

    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);

      if (escaped) {
        current.write(char);
        escaped = false;
        continue;
      }

      if (char == r'\') {
        escaped = true;
        continue;
      }

      if (char == "'" && !inDoubleQuote) {
        inSingleQuote = !inSingleQuote;
        continue;
      }

      if (char == '"' && !inSingleQuote) {
        inDoubleQuote = !inDoubleQuote;
        continue;
      }

      if (char.trim().isEmpty && !inSingleQuote && !inDoubleQuote) {
        if (current.isNotEmpty) {
          args.add(current.toString());
          current.clear();
        }
        continue;
      }

      current.write(char);
    }

    if (escaped) {
      current.write(r'\');
    }

    if (inSingleQuote || inDoubleQuote) {
      throw const FormatException('Unclosed quote in command input.');
    }

    if (current.isNotEmpty) {
      args.add(current.toString());
    }

    return args;
  }
}