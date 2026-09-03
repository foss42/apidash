import 'package:args/command_runner.dart';
import 'package:better_networking/better_networking.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:mason_logger/mason_logger.dart';
import '../output.dart';
import '../storage/storage.dart';
import '../utils/substitute.dart';
import '../utils/workspace.dart';
import 'ai.dart';
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

      final apiType = APIType.values.firstWhere(
        (t) => t.name == match['apiType'],
        orElse: () => APIType.rest,
      );

      // Global --env: substitute {{key}} tokens before sending.
      final (vars, envErr) = await resolveEnvVars(globalResults, logger);
      if (envErr != null) return envErr;

      if (apiType == APIType.ai) {
        final aiMap = match['aiRequestModel'];
        if (aiMap == null) {
          logger.err('Request "$query" has no AI request model.');
          return 2;
        }
        var aiModel = AIRequestModel.fromJson(aiMap as Map<String, Object?>);
        // Saved keys are often blank/secret — fall back to an env var.
        if (aiModel.apiKey == null || aiModel.apiKey!.isEmpty) {
          final envKey = aiKeyFromEnv(aiModel.modelApiProvider?.name ?? '');
          if (envKey != null) aiModel = aiModel.copyWith(apiKey: envKey);
        }
        return runAiRequest(logger, aiModel, json: json, vars: vars);
      }

      final httpMap = match['httpRequestModel'];
      if (httpMap == null) {
        logger.err('Request "$query" has no HTTP request model.');
        return 2;
      }

      var model = HttpRequestModel.fromJson(httpMap as Map<String, Object?>);
      model = applyEnv(model, vars);

      final requestId = 'cli-${DateTime.now().microsecondsSinceEpoch}';
      if (argResults!['stream'] == true) {
        final stream = await streamHttpRequest(requestId, apiType, model);
        return printStream(logger, stream, json: json);
      }

      final (resp, dur, err) = await sendHttpRequest(requestId, apiType, model);
      return printResponse(logger, resp, dur, err, json: json);
    } finally {
      await storage.cleanup();
    }
  }
}
