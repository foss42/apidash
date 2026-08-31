import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:better_networking/better_networking.dart';
import 'package:mason_logger/mason_logger.dart';
import '../output.dart';

/// `apidash send <METHOD> <url>` — ad-hoc request, no workspace needed.
/// Builds an [HttpRequestModel] and sends it through better_networking's
/// engine (the same code path the desktop GUI uses).
class SendCommand extends Command<int> {
  final Logger logger;
  SendCommand(this.logger) {
    argParser
      ..addMultiOption('header',
          abbr: 'H', help: 'Request header "Key: Value" (repeatable).')
      ..addOption('body', abbr: 'd', help: 'Request body data.');
  }

  @override
  final name = 'send';
  @override
  final description = 'Send an ad-hoc request: send <METHOD> <url>';
  @override
  final invocation = 'apidash send <METHOD> <url> [-H "K: V"] [-d <body>]';

  @override
  Future<int> run() async {
    final json = globalResults?['json'] == true;
    final rest = argResults!.rest;
    if (rest.length < 2) {
      throw UsageException('Expected: send <METHOD> <url>', usage);
    }

    final method = _parseVerb(rest[0]);
    final url = rest[1];
    final headers = _parseHeaders(argResults!['header'] as List<String>);
    final body = argResults!['body'] as String?;

    final model = HttpRequestModel(
      method: method,
      url: url,
      headers: headers.isEmpty ? null : headers,
      body: (body != null && body.isNotEmpty) ? body : null,
      bodyContentType: _detectContentType(body),
    );

    if (!json && stdout.hasTerminal) {
      logger.detail('Sending ${method.name.toUpperCase()} $url');
    }

    final (resp, dur, err) = await sendHttpRequest(
      'cli-${DateTime.now().microsecondsSinceEpoch}',
      APIType.rest,
      model,
    );
    return printResponse(logger, resp, dur, err, json: json);
  }

  HTTPVerb _parseVerb(String m) {
    final u = m.toUpperCase();
    return HTTPVerb.values.firstWhere(
      (v) => v.name.toUpperCase() == u,
      orElse: () => throw UsageException(
        'Unknown HTTP method: $m (expected one of '
        '${HTTPVerb.values.map((v) => v.name.toUpperCase()).join(", ")})',
        usage,
      ),
    );
  }

  List<NameValueModel> _parseHeaders(List<String> raw) {
    final out = <NameValueModel>[];
    for (final h in raw) {
      final i = h.indexOf(':');
      if (i <= 0) {
        throw UsageException('Bad header (expected "Key: Value"): $h', usage);
      }
      out.add(NameValueModel(
        name: h.substring(0, i).trim(),
        value: h.substring(i + 1).trim(),
      ));
    }
    return out;
  }

  // No content-type header + a body: mirror the GUI, which sets the
  // content-type from bodyContentType. JSON body -> json, else text.
  ContentType _detectContentType(String? body) {
    if (body == null || body.isEmpty) return ContentType.json;
    try {
      jsonDecode(body);
      return ContentType.json;
    } catch (_) {
      return ContentType.text;
    }
  }
}
