import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

class EnvCommand extends Command {
  final Logger logger;
  EnvCommand(this.logger);
  @override final name = "env";
  @override final description = "Environment management.";
}

class CodeCommand extends Command {
  final Logger logger;
  CodeCommand(this.logger);
  @override final name = "code";
  @override final description = "Generate code snippets.";
}

class ExportCommand extends Command {
  final Logger logger;
  ExportCommand(this.logger);
  @override final name = "export";
  @override final description = "Export collection.";
}
