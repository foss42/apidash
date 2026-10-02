import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:better_networking/better_networking.dart';
import 'package:mason_logger/mason_logger.dart';
import '../output.dart';
import '../utils/substitute.dart';
import 'env.dart';

/// `apidash graphql <url> --query "<gql>"` — ad-hoc GraphQL request.
///
/// Reuses the same engine as `send`: with no `--variables` it hands the query
/// to `better_networking` as `APIType.graphql` (which wraps it via
/// `getGraphQLBody` into `{"query": ...}`, exactly like the GUI). Because that
/// helper is query-only, `--variables` instead builds the full
/// `{"query", "variables"}` JSON body and POSTs it as a normal REST request.
class GraphqlCommand extends Command<int> {
  final Logger logger;
  GraphqlCommand(this.logger) {
    argParser
      ..addOption('query',
          abbr: 'q',
          help: 'GraphQL query string. Use "-" to read the query from stdin.')
      ..addOption('variables',
          help: 'GraphQL variables as a JSON object, e.g. \'{"id":1}\'.')
      ..addMultiOption('header',
          abbr: 'H', help: 'Request header "Key: Value" (repeatable).');
  }

  @override
  final name = 'graphql';
  @override
  final description = 'Send an ad-hoc GraphQL query: graphql <url> --query "<gql>"';
  @override
  final invocation =
      'apidash graphql <url> --query "<gql>" [--variables <json>] [-H "K: V"]';

  @override
  Future<int> run() async {
    final json = globalResults?['json'] == true;
    final rest = argResults!.rest;
    if (rest.isEmpty) {
      throw UsageException('Expected: graphql <url>', usage);
    }
    final url = rest.first;

    var query = argResults!['query'] as String?;
    if (query == '-') {
      query = (await stdin.transform(utf8.decoder).join()).trim();
    }
    if (query == null || query.isEmpty) {
      throw UsageException('Missing --query (the GraphQL document).', usage);
    }

    final varsRaw = argResults!['variables'] as String?;
    Object? parsedVars;
    if (varsRaw != null && varsRaw.isNotEmpty) {
      try {
        parsedVars = jsonDecode(varsRaw);
      } catch (_) {
        throw UsageException('--variables must be valid JSON: $varsRaw', usage);
      }
    }

    final headers = _parseHeaders(argResults!['header'] as List<String>);

    // No variables: use the model's `query` field + APIType.graphql (mirrors
    // the GUI). With variables: the shared getGraphQLBody is query-only, so
    // build the full body and POST it as REST.
    final HttpRequestModel model;
    final APIType apiType;
    if (parsedVars == null) {
      model = HttpRequestModel(
        method: HTTPVerb.post,
        url: url,
        headers: headers.isEmpty ? null : headers,
        query: query,
      );
      apiType = APIType.graphql;
    } else {
      model = HttpRequestModel(
        method: HTTPVerb.post,
        url: url,
        headers: headers.isEmpty ? null : headers,
        body: jsonEncode({'query': query, 'variables': parsedVars}),
        bodyContentType: ContentType.json,
      );
      apiType = APIType.rest;
    }

    // Global --env: substitute {{key}} tokens before sending.
    final (vars, envErr) = await resolveEnvVars(globalResults, logger);
    if (envErr != null) return envErr;
    final withEnv = applyEnv(model, vars);

    final (resp, dur, err) = await sendHttpRequest(
      'cli-gql-${DateTime.now().microsecondsSinceEpoch}',
      apiType,
      withEnv,
    );
    return printResponse(logger, resp, dur, err, json: json);
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
}
