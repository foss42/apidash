import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

/// BaseCommand defines the contract every CLI command must follow.
/// - Enforces consistency across all commands
abstract class BaseCommand extends Command<void> {
  /// Every command must declare its name (the keyword user types)
  /// e.g. 'run', 'list', 'init', etc.
  @override
  String get name;

  /// Every command must provide a human-readable description
  /// shown in `apidash help`
  @override
  String get description;

  Future<void> execute();

  Logger get log => Logger();

  @override
  Future<void> run() => execute();

}