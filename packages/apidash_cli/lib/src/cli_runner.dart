import 'package:args/command_runner.dart';

import 'commands/exec_command.dart';
import 'commands/init_command.dart';
import 'commands/list_command.dart';
import 'commands/run_command.dart';

/// CliRunner wires commands and global flags.
class CliRunner extends CommandRunner<void> {
  CliRunner()
    : super(
        'apidash',
        'API Dash CLI - run and inspect HTTP requests from your terminal.',
      ) {
    argParser
      ..addFlag(
        'version',
        abbr: 'v',
        negatable: false,
        help: 'Print the current CLI version.',
      )
      ..addFlag(
        'verbose',
        negatable: false,
        help: 'Print detailed output including request/response headers.',
      )
      ..addFlag('quiet', negatable: false, help: 'Suppress non-error output.');

    addCommand(InitCommand());
    addCommand(ListCommand());
    addCommand(ExecCommand());
    addCommand(RunCommand());
  }

  @override
  Future<void> run(Iterable<String> args) async {
    final argResults = parse(args);

    if (argResults['version'] == true) {
      print('apidash_cli v0.0.1');
      return;
    }

    if (argResults['verbose'] == true && argResults['quiet'] == true) {
      throw UsageException('Cannot use --verbose and --quiet together.', usage);
    }

    await super.run(args);
  }
}
