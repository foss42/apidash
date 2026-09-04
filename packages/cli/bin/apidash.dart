import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:apidash_cli/apidash_cli.dart';

/// apidash CLI — reuses API Dash's own better_networking engine.
///
/// Exit codes: 0 ok, 1 network/send error, 2 unsupported request,
/// 3 not found, 64 usage error, 70 unexpected error.
Future<void> main(List<String> args) async {
  final logger = Logger();
  final runner =
      CommandRunner<int>('apidash', 'API Dash CLI — send and run API requests.')
        ..argParser.addFlag(
          'json',
          negatable: false,
          help: 'Structured JSON output (for agents/pipes).',
        )
        ..argParser.addOption(
          'workspace',
          abbr: 'w',
          help: 'Override the API Dash data dir (defaults to the desktop app\'s).',
        )
        ..argParser.addOption(
          'env',
          help: 'Apply an environment (by name or id): {{key}} substitution '
              'on url/headers/body before sending.',
        )
        ..addCommand(SendCommand(logger))
        ..addCommand(GraphqlCommand(logger))
        ..addCommand(AiCommand(logger))
        ..addCommand(ListCommand(logger))
        ..addCommand(RunCommand(logger))
        ..addCommand(EnvCommand(logger))
        ..addCommand(TuiCommand(logger));

  // No args on a terminal → launch the interactive TUI ("pick and run").
  // No args without a TTY → keep today's behavior: print usage, exit 64.
  if (args.isEmpty) {
    if (stdout.hasTerminal) {
      try {
        exit(await runTui(logger, runner.parse(const [])));
      } catch (e) {
        logger.err(e.toString());
        exit(70);
      }
    }
    logger.info(runner.usage);
    exit(64);
  }

  try {
    final code = await runner.run(args);
    exit(code ?? 0);
  } on UsageException catch (e) {
    logger.err(e.message);
    logger.info('');
    logger.info(e.usage);
    exit(64);
  } catch (e) {
    logger.err(e.toString());
    exit(70);
  }
}
