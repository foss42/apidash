import 'package:apidash/dashbot/core/services/curl_import_service.dart';
import 'package:curl_parser/curl_parser.dart';
import 'package:test/test.dart';

void main() {
  group('CurlImportService.tryParseCurl', () {
    test('valid curl parses', () {
      final c = CurlImportService.tryParseCurl(
          "curl -X POST https://api.apidash.dev/v1/users -H 'User-Agent: UA' -d '{\"name\":\"John\"}'");
      expect(c, isNotNull);
      expect(c!.method.toUpperCase(), 'POST');
    });

    test('invalid returns null', () {
      expect(CurlImportService.tryParseCurl('echo not a curl'), isNull);
    });
  });

  group('CurlImportService.buildActionPayloadFromCurl', () {
    test('maps auth, headers, body, params', () {
      final curl = Curl.parse(
          'curl -u user:pass "https://api.apidash.dev/items?size=10" -H "X-Test: 1" --data "{\"name\":\"X\"}"');
      final p = CurlImportService.buildActionPayloadFromCurl(curl);
      // Because of --data flag, method becomes POST implicitly
      expect(p['method'].toString().toUpperCase(), 'POST');
      expect(p['url'], startsWith('https://api.apidash.dev/items'));
      final headers = (p['headers'] as Map).cast<String, dynamic>();
      expect(headers.containsKey('Authorization'), true);
      expect(headers['X-Test'], '1');
      expect(p['body'], contains('name'));
      expect(p['params'], containsPair('size', '10'));
    });
  });

  group('CurlImportService.buildActionMessageFromPayload', () {
    test('produces two apply actions and meta diff', () {
      final payload = {
        'method': 'GET',
        'url': 'https://api.apidash.dev/v1/users?limit=5',
        'headers': {'Accept': 'application/json'},
        'body': null,
      };
      final msg = CurlImportService.buildActionMessageFromPayload(payload);
      final actions = (msg['actions'] as List).cast<Map<String, dynamic>>();
      expect(actions.length, 2);
      expect(actions.first['action'], 'apply_curl');
      expect(msg['meta'], isA<Map>());
    });
  });

  group('CurlImportService.processPastedCurl', () {
    test('success path returns json & actions', () {
      final input =
          "curl https://api.apidash.dev/v1/users -H 'Accept: application/json'";
      final res = CurlImportService.processPastedCurl(input,
          current: {'method': 'POST'});
      expect(res.error, isNull);
      expect(res.jsonMessage, isNotNull);
      expect(res.actions, isNotNull);
    });

    test('failure path returns error', () {
      final res = CurlImportService.processPastedCurl('not curl');
      expect(res.error, isNotNull);
      expect(res.jsonMessage, isNull);
    });
  });

  group('CurlImportService additional coverage', () {
    test('setIfMissing early return (null values)', () {
      // No cookie, referer, user-agent flags so underlying values are null.
      final curl = Curl.parse('curl https://api.apidash.dev/simple');
      final payload = CurlImportService.buildActionPayloadFromCurl(curl);
      // Still builds basic payload; exercising null value path in setIfMissing.
      expect(payload['headers'], isA<Map>());
    });

    test('setIfMissing adds missing headers for cookie referer user-agent', () {
      final curl = Curl.parse(
          "curl -b 'a=1' -e 'https://ref.example' -A 'MyAgent' https://api.apidash.dev/hdr");
      final payload = CurlImportService.buildActionPayloadFromCurl(curl);
      final headers = (payload['headers'] as Map).cast<String, dynamic>();
      expect(headers['Cookie'], contains('a=1'));
      expect(headers['User-Agent'], contains('MyAgent'));
      expect(headers['Referer'], contains('ref.example'));
    });

    test(
        'formData mapping & json/text body type detection in summaryForPayload',
        () {
      final curl = Curl.parse(
          "curl -F 'field1=val1' -F 'field2=val2' https://api.apidash.dev/upload");
      final payload = CurlImportService.buildActionPayloadFromCurl(curl);
      // Force JSON-looking body to exercise looksLikeJson; supply manual body override.
      payload['body'] = '{"x":1}';
      final summary = CurlImportService.summaryForPayload(payload);
      expect(summary, contains('Method'));
      expect(summary, contains('Headers'));
    });

    test('diffForPayload full diff (method,url,headers,params,body)', () {
      final current = {
        'method': 'GET',
        'url': 'https://api.apidash.dev/a?x=1&y=2',
        'headers': {'X-A': '1', 'X-Remove': 'gone'},
        'params': {'x': '1', 'y': '2'},
        'body': '{"a":1}',
      };
      final newPayload = {
        'method': 'post', // change method
        'url':
            'https://api.apidash.dev/b', // change url removes query params from url but we provide custom params below
        'headers': {
          'X-A': '2',
          'X-New': 'n'
        }, // update + add, removal of X-Remove
        'params': {'x': '2', 'z': '3'}, // add z, update x, remove y
        'body': '{"a":1,"b":2}', // size & maybe body diff triggers diff['body']
      };
      final diff = CurlImportService.diffForPayload(newPayload, current);
      expect(diff.keys,
          containsAll(['method', 'url', 'headers', 'params', 'body']));
      final msg = CurlImportService.buildActionMessageFromPayload(
        newPayload,
        current: current,
        note: 'note here',
        insights: 'extra insights',
      );
      // note & insights included
      expect(msg['note'], 'note here');
      final expl = msg['explnation'] as String;
      expect(expl, contains('extra insights'));
      expect(expl, contains('Method: GET'));
      // diff narrative lines
      expect(
          expl, contains('If applied to the selected request')); // diff section
    });

    test('_looksLikeJson negative path (invalid JSON -> text)', () {
      final payload = {
        'method': 'GET',
        'url': 'https://api.apidash.dev/x',
        'headers': {},
        'body': '{invalid', // invalid JSON
      };
      final summary = CurlImportService.summaryForPayload(payload);
      // Should classify as text or none (not json)
      expect(summary, isNot(contains('json (')));
    });
  });
}
