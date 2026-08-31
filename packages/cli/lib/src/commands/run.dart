import 'package:args/command_runner.dart';
import 'package:better_networking/better_networking.dart';
import 'package:mason_logger/mason_logger.dart';
import '../output.dart';
import '../storage/storage.dart';
import '../utils/workspace.dart';

/// `apidash run <name|id>` — load a saved request from the shared workspace
/// and send it through the same better_networking engine as `send`.
class RunCommand extends Command<int> {
  final Logger logger;
  RunCommand(this.logger);

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

      final apiType = APIType.values.firstWhere(
        (t) => t.name == match['apiType'],
        orElse: () => APIType.rest,
      );
      if (apiType == APIType.ai) {
        logger.err('AI requests are not supported in the CLI MVP.');
        return 2;
      }
      final httpMap = match['httpRequestModel'];
      if (httpMap == null) {
        logger.err('Request "$query" has no HTTP request model.');
        return 2;
      }

      final model = HttpRequestModel.fromJson(httpMap as Map<String, Object?>);
      final (resp, dur, err) = await sendHttpRequest(
        'cli-${DateTime.now().microsecondsSinceEpoch}',
        apiType,
        model,
      );
      return printResponse(logger, resp, dur, err, json: json);
    } finally {
      await storage.cleanup();
    }
  }
}
