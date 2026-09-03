import 'dart:convert';
import 'package:apidash_cli/apidash_cli.dart';
import 'package:better_networking/better_networking.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/interface.dart'
    show ModelAPIProvider, kModelProvidersMap;
import 'package:test/test.dart';

// Ponytail: one runnable check on the load-bearing logic — that a saved
// request's stored JSON round-trips back into a real HttpRequestModel the
// engine can send, and that HTTP-verb parsing matches the enum.
void main() {
  test('stored request JSON rebuilds an HttpRequestModel', () {
    final stored = {
      'method': 'post',
      'url': 'https://api.apidash.dev/case/lower',
      'headers': [
        {'name': 'Content-Type', 'value': 'application/json'}
      ],
      'body': '{"text":"HELLO"}',
      'bodyContentType': 'json',
    };
    // The CLI cleans Hive maps via a JSON round-trip before fromJson.
    final clean = jsonDecode(jsonEncode(stored)) as Map<String, Object?>;
    final model = HttpRequestModel.fromJson(clean);

    expect(model.method, HTTPVerb.post);
    expect(model.url, 'https://api.apidash.dev/case/lower');
    expect(model.enabledHeadersMap['Content-Type'], 'application/json');
    expect(model.body, '{"text":"HELLO"}');
  });

  test('every HTTP method name maps to an HTTPVerb', () {
    for (final m in ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS']) {
      final verb = HTTPVerb.values
          .firstWhere((v) => v.name.toUpperCase() == m);
      expect(verb.name.toUpperCase(), m);
    }
  });

  test('{{key}} substituter replaces known tokens and leaves unknown ones', () {
    final vars = {'path': 'case/lower', 'token': 'abc123'};
    expect(substitute('https://api.apidash.dev/{{path}}', vars),
        'https://api.apidash.dev/case/lower');
    expect(substitute('Bearer {{token}}', vars), 'Bearer abc123');
    // Unknown token untouched.
    expect(substitute('{{missing}}/{{path}}', vars), '{{missing}}/case/lower');

    // applyEnv rewrites url, header value and body.
    final model = HttpRequestModel(
      method: HTTPVerb.get,
      url: 'https://api.apidash.dev/{{path}}',
      headers: const [NameValueModel(name: 'Authorization', value: 'Bearer {{token}}')],
      body: '{"p":"{{path}}"}',
    );
    final out = applyEnv(model, vars);
    expect(out.url, 'https://api.apidash.dev/case/lower');
    expect(out.headers!.first.value, 'Bearer abc123');
    expect(out.body, '{"p":"case/lower"}');
  });

  test('envVarMap includes only enabled non-secret variables', () {
    final env = {
      'id': 'e1',
      'name': 'Dev',
      'values': [
        {'key': 'path', 'value': 'case/lower', 'type': 'variable', 'enabled': true},
        {'key': 'off', 'value': 'x', 'type': 'variable', 'enabled': false},
        {'key': 'secret', 'value': 's', 'type': 'secret', 'enabled': true},
      ],
    };
    expect(envVarMap(env), {'path': 'case/lower'});
  });

  test('a GraphQL request model produces a {"query": ...} body', () {
    final model = HttpRequestModel(
      method: HTTPVerb.post,
      url: 'https://countries.trevorblades.com/',
      query: '{ countries { code name } }',
    );
    expect(model.hasQuery, isTrue);
    // The same wrapper the engine applies for APIType.graphql.
    final body = getGraphQLBody(model);
    expect(body, isNotNull);
    final decoded = jsonDecode(body!) as Map;
    expect(decoded['query'], '{ countries { code name } }');
  });

  test('AIRequestModel -> createRequest yields a real HttpRequestModel', () {
    final model = kModelProvidersMap[ModelAPIProvider.openai]!
        .defaultAIRequestModel
        .copyWith(model: 'gpt-4o-mini', apiKey: 'sk-test', userPrompt: 'Hi');
    // `.httpRequestModel` == provider.createRequest(model).
    final http = model.httpRequestModel;
    expect(http, isNotNull);
    expect(http!.method, HTTPVerb.post);
    expect(http.url, 'https://api.openai.com/v1/chat/completions');
    final body = jsonDecode(http.body!) as Map;
    expect(body['model'], 'gpt-4o-mini');
    // The provider's response parser extracts the answer text.
    final answer = model.getFormattedOutput({
      'choices': [
        {
          'message': {'content': 'hello there'}
        }
      ]
    });
    expect(answer, 'hello there');
  });

  test('a saved AI request JSON rebuilds into a sendable AIRequestModel', () {
    // This is exactly what `run` does for an apiType==ai entry.
    final stored = {
      'modelApiProvider': 'openai',
      'url': 'https://api.openai.com/v1/chat/completions',
      'model': 'gpt-4o-mini',
      'apiKey': 'sk-test',
      'user_prompt': 'hi',
      'model_configs': <Object?>[],
    };
    final clean = jsonDecode(jsonEncode(stored)) as Map<String, Object?>;
    final model = AIRequestModel.fromJson(clean);

    expect(model.modelApiProvider, ModelAPIProvider.openai);
    expect(model.userPrompt, 'hi');
    // Non-null httpRequestModel => the provider adapter can build the request.
    expect(model.httpRequestModel, isNotNull);
    expect(model.httpRequestModel!.method, HTTPVerb.post);
  });
}
