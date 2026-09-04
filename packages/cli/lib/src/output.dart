import 'dart:convert';
import 'dart:io';
import 'package:better_networking/better_networking.dart'
    show HttpResponse, HttpStreamOutput;
import 'package:mason_logger/mason_logger.dart';

const _enc = JsonEncoder.withIndent('  ');

/// Prints the result of a send/run. Returns the process exit code
/// (0 ok, 1 network/send error). `json` forces structured output.
int printResponse(
  Logger logger,
  HttpResponse? resp,
  Duration? dur,
  String? err, {
  required bool json,
}) {
  if (err != null || resp == null) {
    final message = err ?? 'No response';
    if (json) {
      stdout.writeln(_enc.convert({'error': message}));
    } else {
      logger.err('Request failed: $message');
    }
    return 1;
  }

  final timeMs = dur?.inMilliseconds ?? 0;
  final body = resp.body;

  if (json) {
    stdout.writeln(_enc.convert(responseToMap(resp, dur, err)));
    return 0;
  }

  // Human output.
  final tty = stdout.hasTerminal;
  final statusLine =
      'Status: ${resp.statusCode} ${resp.reasonPhrase ?? ''}'.trim();
  final color = resp.statusCode >= 200 && resp.statusCode < 300
      ? lightGreen
      : (resp.statusCode >= 400 ? lightRed : lightYellow);
  logger.info(tty ? color.wrap(statusLine)! : statusLine);
  logger.info('Time:   ${timeMs}ms');
  logger.info('Size:   ${resp.bodyBytes.length} bytes');
  if (body.isNotEmpty) {
    logger.info('');
    logger.info(_pretty(body));
  }
  return 0;
}

/// Consumes a `--stream` response (from `streamHttpRequest`) and prints it as
/// it arrives. Human mode writes each chunk's body live to stdout; `--json`
/// mode emits one compact JSON object per chunk (JSONL:
/// `{streaming,status,timeMs,body}`). Returns the exit code (0 ok, 1 if any
/// chunk carried an error). A non-streaming endpoint yields a single chunk
/// with the full body, so this prints it once.
Future<int> printStream(
  Logger logger,
  Stream<HttpStreamOutput> stream, {
  required bool json,
}) async {
  var sawError = false;
  var wroteBody = false;
  await for (final out in stream) {
    if (out == null) continue;
    final (streaming, resp, dur, err) = out;
    if (err != null) {
      sawError = true;
      if (json) {
        stdout.writeln(jsonEncode({'error': err}));
      } else {
        logger.err('${wroteBody ? '\n' : ''}Stream error: $err');
      }
      break;
    }
    if (resp == null) continue;
    if (json) {
      stdout.writeln(jsonEncode({
        'streaming': streaming ?? false,
        'status': resp.statusCode,
        'timeMs': dur?.inMilliseconds ?? 0,
        'body': _maybeJson(resp.body),
      }));
    } else {
      stdout.write(resp.body);
      // Flush per chunk so a piped/redirected live tail actually streams
      // (Dart fully-buffers non-TTY stdout otherwise). Ignore a broken pipe.
      try {
        await stdout.flush();
      } catch (_) {}
      wroteBody = true;
    }
  }
  if (!json && wroteBody) stdout.write('\n');
  return sawError ? 1 : 0;
}

/// The `--json` shape of a send/run result — `{status,timeMs,headers,body}`
/// or `{error}`. Used by [printResponse] and by `import --run --json` (which
/// collects these into a single array).
Map<String, dynamic> responseToMap(
    HttpResponse? resp, Duration? dur, String? err) {
  if (err != null || resp == null) return {'error': err ?? 'No response'};
  return {
    'status': resp.statusCode,
    'timeMs': dur?.inMilliseconds ?? 0,
    'headers': resp.headers,
    'body': _maybeJson(resp.body),
  };
}

/// Returns decoded JSON if the string is valid JSON, else the raw string.
dynamic _maybeJson(String s) {
  try {
    return jsonDecode(s);
  } catch (_) {
    return s;
  }
}

String _pretty(String s) {
  try {
    return _enc.convert(jsonDecode(s));
  } catch (_) {
    return s;
  }
}
