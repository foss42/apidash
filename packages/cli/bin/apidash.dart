import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:hive_ce/hive.dart';
import 'package:apidash_cli/apidash_cli.dart';

void main(List<String> args) async {
  final logger = Logger();
  
  final runner = CommandRunner("apidash", "Apidash CLI tool ")
    ..argParser.addOption(
      'data-dir',
      abbr: 'd',
      help: 'Directory where Apidash Hive files are stored.',
      defaultsTo: detectWorkspacePath() ?? getDefaultDataDir(),
    )
    ..addCommand(ListCommand(logger))
    ..addCommand(RunCommand(logger))
    ..addCommand(EnvCommand(logger))
    ..addCommand(CodeCommand(logger))
    ..addCommand(ExportCommand(logger));

  try {
    await runner.run(args);
  } catch (e) {
    if (e is UsageException) {
      logger.err(e.message);
      logger.info('');
      logger.info(runner.usage);
    } else {
      logger.err(e.toString());
    }
  } finally {
    await Hive.close();
    exit(0);
  }
}
