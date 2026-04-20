import 'dart:convert';
import 'dart:io';
import '../models/cli_models.dart';

class ResponseFormatter {
  static void print(CliRequest request, {bool verbose = false}) {
    final res = request.httpResponseModel;
    if (res == null) {
      dartPrint('✗ No response received');
      return;
    }

    final statusCode = res.statusCode ?? 0;
    final emoji = statusCode >= 200 && statusCode < 300 ? '✓' : '✗';
    final ms = res.time?.inMilliseconds ?? 0;

    dartPrint('\n$emoji HTTP $statusCode  |  ${ms}ms');

    if (verbose) {
      dartPrint('\n── Request Headers ──');
      for (final h in request.enabledHeaders) {
        dartPrint('  ${h.name}: ${h.value}');
      }

      dartPrint('\n── Response Headers ──');
      res.headers?.forEach((k, v) => dartPrint('  $k: $v'));
    }

    dartPrint('\n── Body ──');
    final body = res.body ?? '';
    try {
      final decoded = jsonDecode(body);
      dartPrint(const JsonEncoder.withIndent('  ').convert(decoded));
    } catch (_) {
      dartPrint(body);
    }
  }

  // Alias to avoid conflict with Command.print()
  static void dartPrint(String msg) => stdout.writeln(msg);
}