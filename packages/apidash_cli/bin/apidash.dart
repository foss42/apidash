import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:apidash_cli/commands/options_command.dart';
import 'package:apidash_cli/commands/run_command.dart';
import 'package:apidash_cli/commands/search_command.dart';
import 'package:apidash_cli/commands/log_command.dart';
import 'package:apidash_cli/storage/cli_storage.dart';

Future<void> main(List<String> args) async {
  try {
    // Init the same Hive storage the Flutter GUI uses
    await CliStorage.init();

    late final CommandRunner<void> runner;
    runner = CommandRunner<void>(
      'apidash',
      'API Dash CLI - run, search, and view API request history',
    )
      ..addCommand(RunCommand())
      ..addCommand(SearchCommand())
      ..addCommand(LogCommand())
      ..addCommand(
        OptionsCommand(
          executeArgs: (selectedArgs) async {
            await runner.run(selectedArgs);
          },
        ),
      );

    if (args.isEmpty) {
      final fallbackArgs = stdin.hasTerminal
          ? const <String>['options']
          : const <String>['--help'];
      await runner.run(fallbackArgs);
      return;
    }

    await runner.run(args);
  } on FileSystemException catch (e) {
    if (_isHiveLockError(e)) {
      _printHiveLockGuidance(e.path);
      exitCode = 1;
      return;
    }
    rethrow;
  }
}

bool _isHiveLockError(FileSystemException error) {
  final path = error.path?.toLowerCase() ?? '';
  final message = error.message.toLowerCase();
  final osErrorCode = error.osError?.errorCode;

  final mentionsLockFile = path.endsWith('.lock') || path.contains('.lock');
  final mentionsLocked = message.contains('locked') || message.contains('lock');
  return osErrorCode == 33 || (mentionsLockFile && mentionsLocked);
}

void _printHiveLockGuidance(String? lockPath) {
  stderr.writeln('API Dash storage is locked by another process.');
  stderr.writeln(
    'Close the API Dash GUI (or any other apidash_cli process) and try again.',
  );
  if (lockPath != null && lockPath.trim().isNotEmpty) {
    stderr.writeln('Lock file: $lockPath');
  }
  stderr.writeln(
    'On Windows, only one process can open the same Hive files at a time.',
  );
}