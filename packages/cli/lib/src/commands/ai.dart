import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:better_networking/better_networking.dart';
// Narrow, Flutter-free genai imports (never the genai.dart barrel — it exports
// widgets that drag in Flutter and would break `dart compile`).
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/interface.dart'
    show ModelAPIProvider, kModelProvidersMap;
import 'package:mason_logger/mason_logger.dart';
import '../utils/substitute.dart';

const _enc = JsonEncoder.withIndent('  ');

/// Sends an [AIRequestModel] through the exact path the desktop app uses:
/// `provider.createRequest` (via the model's `httpRequestModel` getter) →
/// `sendHttpRequest` → `getFormattedOutput` (the provider's response parser),
/// and prints the model's answer. Returns the process exit code.
///
/// `vars` applies `{{key}}` env substitution to the generated HTTP request.
Future<int> runAiRequest(
  Logger logger,
  AIRequestModel model, {
  required bool json,
  Map<String, String> vars = const {},
}) async {
  var httpModel = model.httpRequestModel; // = provider.createRequest(model)
  if (httpModel == null) {
    final msg = 'Unknown/unsupported AI provider: ${model.modelApiProvider?.name}';
    if (json) {
      stdout.writeln(_enc.convert({'error': msg}));
    } else {
      logger.err(msg);
    }
    return 2;
  }
  httpModel = applyEnv(httpModel, vars);

  final (resp, dur, err) = await sendHttpRequest(
    'cli-ai-${DateTime.now().microsecondsSinceEpoch}',
    APIType.ai,
    httpModel,
  );

  if (err != null || resp == null) {
    final msg = err ?? 'No response';
    if (json) {
      stdout.writeln(_enc.convert({'error': msg}));
    } else {
      logger.err('Request failed: $msg');
    }
    return 1;
  }

  if (resp.statusCode != 200) {
    if (json) {
      stdout.writeln(_enc.convert({'status': resp.statusCode, 'error': resp.body}));
    } else {
      logger.err('AI provider returned ${resp.statusCode}:');
      logger.err(resp.body);
    }
    return 1;
  }

  String? answer;
  try {
    answer = model.getFormattedOutput(jsonDecode(resp.body) as Map);
  } catch (_) {
    // Fall through to raw body.
  }
  answer ??= resp.body;

  if (json) {
    stdout.writeln(_enc.convert({
      'status': resp.statusCode,
      'timeMs': dur?.inMilliseconds ?? 0,
      'provider': model.modelApiProvider?.name,
      'model': model.model,
      'answer': answer,
    }));
  } else {
    stdout.writeln(answer);
  }
  return 0;
}

/// Looks up an API key from the environment: `<PROVIDER>_API_KEY`, falling back
/// to `OPENAI_API_KEY`. Returns null when neither is set.
String? aiKeyFromEnv(String provider) =>
    Platform.environment['${provider.toUpperCase()}_API_KEY'] ??
    Platform.environment['OPENAI_API_KEY'];

/// `apidash ai --provider <id> --model <name> -m "<prompt>"` — ad-hoc AI call.
class AiCommand extends Command<int> {
  final Logger logger;
  AiCommand(this.logger) {
    final providers = ModelAPIProvider.values.map((e) => e.name).join(', ');
    argParser
      ..addOption('provider',
          abbr: 'p', help: 'AI provider: $providers.')
      ..addOption('model', help: 'Model name, e.g. gpt-4o-mini.')
      ..addMultiOption('message',
          abbr: 'm', help: 'User prompt (repeatable; lines are joined).')
      ..addOption('system', help: 'Optional system prompt.')
      ..addOption('key',
          help: 'API key. Falls back to <PROVIDER>_API_KEY / OPENAI_API_KEY.')
      ..addOption('url', help: 'Override the provider endpoint URL.');
  }

  @override
  final name = 'ai';
  @override
  final description = 'Send an ad-hoc AI prompt to a provider.';
  @override
  final invocation =
      'apidash ai --provider <id> --model <name> -m "<prompt>" [--key <k>]';

  @override
  Future<int> run() async {
    final json = globalResults?['json'] == true;

    final providerStr = argResults!['provider'] as String?;
    if (providerStr == null || providerStr.isEmpty) {
      throw UsageException('Missing --provider.', usage);
    }
    final ModelAPIProvider provider;
    try {
      provider = ModelAPIProvider.values.byName(providerStr);
    } catch (_) {
      throw UsageException(
        'Unknown provider: $providerStr (expected one of '
        '${ModelAPIProvider.values.map((e) => e.name).join(", ")})',
        usage,
      );
    }

    final modelName = argResults!['model'] as String?;
    if (modelName == null || modelName.isEmpty) {
      throw UsageException('Missing --model.', usage);
    }

    final messages = argResults!['message'] as List<String>;
    if (messages.isEmpty) {
      throw UsageException('Missing -m/--message (the prompt).', usage);
    }
    final prompt = messages.join('\n');

    final key = (argResults!['key'] as String?) ?? aiKeyFromEnv(providerStr);
    // Ollama runs locally and needs no key; every hosted provider does.
    if ((key == null || key.isEmpty) && provider != ModelAPIProvider.ollama) {
      final msg = 'No API key. Pass --key or set '
          '${providerStr.toUpperCase()}_API_KEY.';
      if (json) {
        stdout.writeln(_enc.convert({'error': msg}));
      } else {
        logger.err(msg);
      }
      return 1;
    }

    // The provider's defaultAIRequestModel already carries the right url,
    // modelApiProvider and model configs (temperature/top_p/max_tokens).
    var model = kModelProvidersMap[provider]!.defaultAIRequestModel.copyWith(
      model: modelName,
      apiKey: key,
      userPrompt: prompt,
    );
    final system = argResults!['system'] as String?;
    if (system != null) model = model.copyWith(systemPrompt: system);
    final urlOverride = argResults!['url'] as String?;
    if (urlOverride != null && urlOverride.isNotEmpty) {
      model = model.copyWith(url: urlOverride);
    }

    return runAiRequest(logger, model, json: json);
  }
}
