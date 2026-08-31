import 'dart:convert';
import 'dart:io';
import 'package:better_networking/better_networking.dart' show HttpResponse;
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
    stdout.writeln(_enc.convert({
      'status': resp.statusCode,
      'timeMs': timeMs,
      'headers': resp.headers,
      'body': _maybeJson(body),
    }));
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
