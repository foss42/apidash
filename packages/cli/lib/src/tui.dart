import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:better_networking/better_networking.dart';
import 'package:mason_logger/mason_logger.dart';
import 'commands/env.dart';
import 'executor.dart';
import 'storage/storage.dart';
import 'utils/workspace.dart';

/// `apidash tui` (and the default when run with no args on a terminal):
/// an interactive "pick and run" loop over the saved requests in the shared
/// workspace, driven entirely with `mason_logger` (chooseOne/prompt) — no
/// full-screen/curses library. TTY-only: `chooseOne` and the inline editor
/// need raw terminal input.
class TuiCommand extends Command<int> {
  final Logger logger;
  TuiCommand(this.logger);

  @override
  final name = 'tui';
  @override
  final description =
      'Interactive mode: browse and run your saved requests (terminal only).';

  @override
  Future<int> run() => runTui(logger, globalResults);
}

/// The interactive loop. Loads saved requests, lets the user pick one, shows
/// its details, and offers Run / edit actions / Generate curl / Back until
/// they choose Quit. Honours the global `--env` and `--workspace`.
Future<int> runTui(Logger logger, ArgResults? globalResults) async {
  final json = globalResults?['json'] == true;
  final ws = resolveWorkspace(globalResults);
  final storage = StorageHelper(ws, logger);

  // Restore the terminal on Ctrl+C so the user's shell isn't left in raw mode.
  // ponytail: exit(130) here skips storage.cleanup() -> a temp shadow-copy dir
  // may leak in systemp on Ctrl+C. Acceptable; the OS reclaims systemp.
  final sigint = ProcessSignal.sigint.watch().listen((_) {
    try {
      stdin
        ..echoMode = true
        ..lineMode = true;
    } catch (_) {}
    stdout.write('\x1b[?25h'); // show cursor
    exit(130);
  });

  try {
    final requests = await storage.getRequests();
    if (requests.isEmpty) {
      logger.info('No saved requests found in $ws.\n'
          'Create some in the API Dash app, or pass --workspace <path>.');
      return 0;
    }

    // Resolve the global --env once (applied to every request we run).
    final (vars, envErr) = await resolveEnvVars(globalResults, logger);
    if (envErr != null) return envErr;

    const quit = 'Quit';
    while (true) {
      // Choices are the entry maps themselves + a Quit sentinel; a `display`
      // callback renders each label, so duplicate names never collide.
      final selected = logger.chooseOne<Object>(
        'Select a request',
        choices: [...requests, quit],
        defaultValue: requests.first,
        display: (c) =>
            c is String ? c : requestChoiceLabel(c as Map<String, dynamic>),
      );
      if (selected == quit) break;

      final entry = selected as Map<String, dynamic>;
      final exit = await _requestMenu(logger, entry, json: json, vars: vars);
      if (exit != null) return exit; // (reserved; menu currently never exits)
    }
    return 0;
  } finally {
    await sigint.cancel();
    await storage.cleanup();
  }
}

/// The per-request action menu. Edits are in-memory only (the workspace is a
/// read-only shadow copy). Returns null to loop back to the request list.
Future<int?> _requestMenu(
  Logger logger,
  Map<String, dynamic> entry, {
  required bool json,
  required Map<String, String> vars,
}) async {
  final apiType = entry['apiType'] as String? ?? 'rest';
  final isAi = apiType == 'ai';
  // Local, editable copy of the HTTP model (rest/graphql only).
  var model = isAi ? null : _modelOf(entry);
  var edited = false;

  const back = 'Back';
  const run = 'Run';
  const curl = 'Generate curl';

  while (true) {
    logger.info('');
    logger.info(requestSummary(entry, model: model));

    final actions = isAi
        ? [run, curl, back]
        : [run, 'Edit URL', 'Edit Method', 'Edit Headers', 'Edit Body/Params',
            curl, back];
    final action = logger.chooseOne<String>('Action',
        choices: actions, defaultValue: run);

    switch (action) {
      case run:
        logger.info('');
        if (edited) {
          logger.info(styleDim.wrap(
              'Note: edits are in-memory only — not saved back to the '
              'workspace (write-back is a future feature).')!);
        }
        await executeSavedRequest(entry,
            logger: logger,
            json: json,
            vars: vars,
            overrideModel: isAi ? null : model);
        return null; // back to the request list after a run

      case curl:
        logger.info('');
        logger.info(isAi
            ? '(curl export not available for AI requests)'
            : buildCurl(model!, apiType: apiType));
        break;

      case 'Edit URL':
        model = model!.copyWith(url: interactiveEdit('URL', model.url));
        edited = true;
        break;

      case 'Edit Method':
        final verb = logger.chooseOne<HTTPVerb>('Method',
            choices: HTTPVerb.values,
            defaultValue: model!.method,
            display: (v) => v.name.toUpperCase());
        model = model.copyWith(method: verb);
        edited = true;
        break;

      case 'Edit Headers':
        final name = logger.prompt('Header name (empty to cancel)');
        if (name.isNotEmpty) {
          final value = logger.prompt('Value for "$name" (empty to remove)');
          model = model!.copyWith(headers: _upsert(model.headers, name, value));
          edited = true;
        }
        break;

      case 'Edit Body/Params':
        if (apiType == 'graphql') {
          model =
              model!.copyWith(query: interactiveEdit('Query', model.query ?? ''));
          edited = true;
        } else {
          final what = logger.chooseOne<String>('Edit what?',
              choices: ['Body', 'Add/Update param', back], defaultValue: 'Body');
          if (what == 'Body') {
            model = model!.copyWith(body: interactiveEdit('Body', model.body ?? ''));
            edited = true;
          } else if (what == 'Add/Update param') {
            final name = logger.prompt('Param name (empty to cancel)');
            if (name.isNotEmpty) {
              final value = logger.prompt('Value for "$name" (empty to remove)');
              model = model!.copyWith(params: _upsert(model.params, name, value));
              edited = true;
            }
          }
        }
        break;

      case back:
        return null;
    }
  }
}

HttpRequestModel? _modelOf(Map<String, dynamic> entry) {
  final m = entry['httpRequestModel'];
  return m == null
      ? null
      : HttpRequestModel.fromJson(m as Map<String, Object?>);
}

/// Upserts (or removes, when [value] is empty) a name/value row by name
/// (case-insensitive). Used for header/param edits.
List<NameValueModel> _upsert(
    List<NameValueModel>? rows, String name, String value) {
  final list = [...?rows];
  final i = list.indexWhere((r) => r.name.toLowerCase() == name.toLowerCase());
  if (value.isEmpty) {
    if (i >= 0) list.removeAt(i);
  } else if (i >= 0) {
    list[i] = list[i].copyWith(value: value);
  } else {
    list.add(NameValueModel(name: name, value: value));
  }
  return list;
}

/// One-line label for a request in the picker, e.g.
/// `GET    Get user   (https://…)` or `[graphql] Search  (…)`.
String requestChoiceLabel(Map<String, dynamic> entry) {
  final apiType = entry['apiType'] as String? ?? 'rest';
  final name = (entry['name'] as String?)?.trim();
  final label = (name == null || name.isEmpty) ? '(unnamed)' : name;

  if (apiType == 'ai') {
    final m = (entry['aiRequestModel'] as Map?)?['model'] as String?;
    return '[ai] $label${m == null ? '' : '  ($m)'}';
  }

  final http = entry['httpRequestModel'] as Map?;
  final url = (http?['url'] as String?) ?? '';
  final tail = url.isEmpty ? '' : '  (${_short(url)})';
  if (apiType == 'rest') {
    final method = ((http?['method'] as String?) ?? 'get').toUpperCase();
    return '${method.padRight(6)} $label$tail';
  }
  return '[$apiType] $label$tail';
}

/// Multi-line details shown before the action menu. When [model] is given, its
/// (possibly edited) values are shown instead of the stored ones.
String requestSummary(Map<String, dynamic> entry, {HttpRequestModel? model}) {
  final apiType = entry['apiType'] as String? ?? 'rest';
  final name = (entry['name'] as String?)?.trim();
  final b = StringBuffer()
    ..writeln('Name:     ${name == null || name.isEmpty ? '(unnamed)' : name}')
    ..writeln('Type:     $apiType');

  if (apiType == 'ai') {
    final ai = entry['aiRequestModel'] as Map?;
    b
      ..writeln('Provider: ${ai?['modelApiProvider'] ?? ''}')
      ..writeln('Model:    ${ai?['model'] ?? ''}')
      ..write('URL:      ${ai?['url'] ?? ''}');
    return b.toString();
  }

  final http = entry['httpRequestModel'] as Map?;
  final method =
      (model?.method.name ?? (http?['method'] as String?) ?? 'get').toUpperCase();
  final url = model?.url ?? (http?['url'] as String?) ?? '';
  final headers =
      model?.headers?.length ?? (http?['headers'] as List?)?.length ?? 0;
  b
    ..writeln('Method:   $method')
    ..writeln('URL:      $url')
    ..write('Headers:  $headers');
  return b.toString();
}

/// Builds a runnable `curl` command from a (possibly edited) [HttpRequestModel].
/// Reflects local edits. For GraphQL it emits the wrapped `{"query": …}` body
/// the engine would send. ponytail: hand-rolled builder (no model→curl util is
/// reachable — the CLI can't import apidash_core); covers method/url/params/
/// headers/body — not multipart form-data or auth flags.
String buildCurl(HttpRequestModel model, {String apiType = 'rest'}) {
  final b = StringBuffer('curl');
  final method = model.method.name.toUpperCase();
  if (method != 'GET') b.write(' -X $method');
  b.write(' ${_sq(_urlWithParams(model))}');

  final headers = Map<String, String>.from(model.enabledHeadersMap);
  final String? body;
  if (apiType == 'graphql') {
    body = getGraphQLBody(model);
    headers.putIfAbsent('Content-Type', () => 'application/json');
  } else {
    body = model.body;
  }

  headers.forEach((k, v) => b.write(" \\\n  -H ${_sq('$k: $v')}"));
  if (body != null && body.isNotEmpty) {
    b.write(" \\\n  --data ${_sq(body)}");
  }
  return b.toString();
}

String _urlWithParams(HttpRequestModel m) {
  final params = m.enabledParamsMap;
  if (params.isEmpty) return m.url;
  final qs = params.entries
      .map((e) =>
          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
      .join('&');
  return m.url.contains('?') ? '${m.url}&$qs' : '${m.url}?$qs';
}

/// Safe single-quoting for a shell token: wraps in '…' and escapes any inner '.
String _sq(String s) => "'${s.replaceAll("'", r"'\''")}'";

String _short(String url, [int max = 48]) =>
    url.length <= max ? url : '${url.substring(0, max - 1)}…';

/// Raw-mode inline field editor (ported from the CLI PoC). Shows `prompt: ` and
/// the current value pre-filled, supports typing + Backspace, Enter to accept,
/// Ctrl+C to abort. TTY-only. Returns the edited string.
String interactiveEdit(String prompt, String initialValue) {
  stdout.write('$prompt: ');
  final originalEchoMode = stdin.echoMode;
  final originalLineMode = stdin.lineMode;
  try {
    stdin
      ..echoMode = false
      ..lineMode = false;

    var buffer = initialValue;
    stdout.write(buffer);

    while (true) {
      final charCode = stdin.readByteSync();
      if (charCode == 10 || charCode == 13) {
        break; // Enter
      } else if (charCode == 127 || charCode == 8) {
        if (buffer.isNotEmpty) {
          buffer = buffer.substring(0, buffer.length - 1);
          stdout.write('\b \b'); // Backspace
        }
      } else if (charCode >= 32 && charCode <= 126) {
        final char = String.fromCharCode(charCode);
        buffer += char;
        stdout.write(char);
      } else if (charCode == 3) {
        exit(130); // Ctrl+C
      } else if (charCode == -1) {
        break; // EOF
      }
    }
    stdout.write('\n');
    return buffer;
  } finally {
    stdin
      ..echoMode = originalEchoMode
      ..lineMode = originalLineMode;
  }
}
