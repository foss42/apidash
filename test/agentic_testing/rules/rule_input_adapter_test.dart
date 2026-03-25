import 'package:apidash/agentic_testing/rules/rule_input_adapter.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RuleInputAdapter', () {
    const adapter = RuleInputAdapter();

    test('maps method/url/body and enabled headers', () {
      final request = RequestModel(
        id: 'r1',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.example.com/register',
          headers: [
            NameValueModel(name: 'Content-Type', value: 'application/json'),
            NameValueModel(name: 'Authorization', value: 'Bearer token'),
            NameValueModel(name: 'X-Disabled', value: 'x'),
          ],
          isHeaderEnabledList: [true, true, false],
          body: '{"email":"x@y.com"}',
        ),
      );

      final input = adapter.fromRequestModel(request);

      expect(input.method, 'POST');
      expect(input.url, 'https://api.example.com/register');
      expect(input.body, '{"email":"x@y.com"}');
      expect(input.headers.containsKey('Content-Type'), isTrue);
      expect(input.headers.containsKey('Authorization'), isTrue);
      expect(input.headers.containsKey('X-Disabled'), isFalse);
    });

    test('flags protected endpoint when auth model is set', () {
      final request = RequestModel(
        id: 'r2',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/me',
          authModel: AuthModel(
            type: APIAuthType.bearer,
            bearer: AuthBearerModel(token: 'abc'),
          ),
        ),
      );

      final input = adapter.fromRequestModel(request);

      expect(input.endpointLikelyProtected, isTrue);
    });

    test('respects explicit endpointLikelyProtected override', () {
      final request = RequestModel(
        id: 'r3',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/public',
        ),
      );

      final input = adapter.fromRequestModel(
        request,
        endpointLikelyProtected: true,
      );

      expect(input.endpointLikelyProtected, isTrue);
    });
  });
}