import 'package:better_networking/better_networking.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:mason_logger/mason_logger.dart';
import 'commands/ai.dart';
import 'output.dart';
import 'utils/substitute.dart';

/// Executes ONE saved request entry (a `RequestModel.toJson()` map from the
/// workspace) through the same better_networking / genai path the desktop app
/// uses. This is the single execution path shared by `apidash run` and the
/// interactive TUI — routing by the stored `apiType`:
///
/// * `rest` / `graphql` → rebuilt into an [HttpRequestModel] and sent via
///   [sendHttpRequest] (or [streamHttpRequest] when [stream] is true).
/// * `ai` → rebuilt into an [AIRequestModel] and answered via [runAiRequest]
///   (with an env-var API-key fallback when the saved key is blank).
///
/// `vars` applies `{{key}}` env substitution before sending. Pass
/// [overrideModel] to run an in-memory edited request (the TUI's edit actions)
/// instead of rebuilding it from [entry] — only for `rest`/`graphql`.
/// Returns the process exit code (0 ok, 1 send error, 2 unsupported/no model).
Future<int> executeSavedRequest(
  Map<String, dynamic> entry, {
  required Logger logger,
  required bool json,
  Map<String, String> vars = const {},
  bool stream = false,
  HttpRequestModel? overrideModel,
}) async {
  final apiType = APIType.values.firstWhere(
    (t) => t.name == entry['apiType'],
    orElse: () => APIType.rest,
  );

  if (apiType == APIType.ai) {
    final aiMap = entry['aiRequestModel'];
    if (aiMap == null) {
      logger.err('Request has no AI request model.');
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

  HttpRequestModel model;
  if (overrideModel != null) {
    model = overrideModel;
  } else {
    final httpMap = entry['httpRequestModel'];
    if (httpMap == null) {
      logger.err('Request has no HTTP request model.');
      return 2;
    }
    model = HttpRequestModel.fromJson(httpMap as Map<String, Object?>);
  }
  model = applyEnv(model, vars);

  final requestId = 'cli-${DateTime.now().microsecondsSinceEpoch}';
  if (stream) {
    final s = await streamHttpRequest(requestId, apiType, model);
    return printStream(logger, s, json: json);
  }
  final (resp, dur, err) = await sendHttpRequest(requestId, apiType, model);
  return printResponse(logger, resp, dur, err, json: json);
}
