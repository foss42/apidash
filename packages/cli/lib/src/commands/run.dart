import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import '../executor.dart';
import '../storage/storage.dart';
import '../utils/workspace.dart';
import 'env.dart';

/// `apidash run <name|id>` — load a saved request from the shared workspace
/// and send it through the same better_networking engine as `send`.
///
/// Routes by the saved `apiType`: `rest`/`graphql` go through the HTTP engine
/// (GraphQL requests carry their `query` and are sent as `APIType.graphql`),
/// and `ai` requests are rebuilt into an [AIRequestModel] and answered.
class RunCommand extends Command<int> {
  final Logger logger;
  RunCommand(this.logger) {
    argParser.addFlag('stream',
        negatable: false,
        help: 'Stream the response, printing each chunk live (ignored for AI). '
            '--json emits one JSON object per chunk (JSONL).');
  }

  @override
  final name = 'run';
  @override
  final description = 'Run a saved request by name or id.';
  @override
  final invocation = 'apidash run <name|id>';

  @override
  Future<int> run() async {
    final json = globalResults?['json'] == true;
    if (argResults!.rest.isEmpty) {
      throw UsageException('Missing request name or id.', usage);
    }
    final query = argResults!.rest.first;
    final storage = StorageHelper(resolveWorkspace(globalResults), logger);

    try {
      final requests = await storage.getRequests();
      final match = requests.firstWhere(
        (r) => r['id'] == query || r['name'] == query,
        orElse: () => {},
      );
      if (match.isEmpty) {
        logger.err('Request not found in workspace: $query');
        return 3;
      }

      // Global --env: substitute {{key}} tokens before sending.
      final (vars, envErr) = await resolveEnvVars(globalResults, logger);
      if (envErr != null) return envErr;

      // Single execution path shared with the interactive TUI.
      return executeSavedRequest(
        match,
        logger: logger,
        json: json,
        vars: vars,
        stream: argResults!['stream'] == true,
      );
    } finally {
      await storage.cleanup();
    }
  }
}
