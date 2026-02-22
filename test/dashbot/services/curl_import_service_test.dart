import 'package:apidash/dashbot/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('Curl.tryParse returns null', () {
    test('invalid returns null', () {
      expect(Curl.tryParse('echo not a curl'), isNull);
    });
  });

  group('CurlImportService.buildResponseFromParsed', () {
    test('converts curl to json message with actions', () {
      final curl = Curl.parse(
          'curl -u user:pass "https://api.apidash.dev/items?size=10" -H "X-Test: 1" --data "{"name":"X"}"');
      final parsedCurl = convertCurlToHttpRequestModel(curl).toJson();
      final result = CurlImportService.buildResponseFromParsed(parsedCurl);

      expect(result.jsonMessage, isNotNull);
      expect(result.actions, hasLength(2));
      expect(result.actions.first['action'], 'apply_curl');

      // Verify the payload contains expected data
      final payload = result.actions.first['value'] as Map<String, dynamic>;
      expect(payload['method'].toString().toUpperCase(), 'POST');
      expect(payload['headers'], isA<List<Map>>());
      expect(payload['body'], contains('name'));
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
    test(
        'formData mapping & json/text body type detection in summaryForPayload',
        () {
      // Create a payload with form data to test summary generation
      final payload = {
        'method': 'POST',
        'url': 'https://api.apidash.dev/upload',
        'headers': <String, String>{},
        'params': <String, String>{},
        'form': true,
        'formData': [
          {'name': 'field1', 'value': 'val1'},
          {'name': 'field2', 'value': 'val2'}
        ],
      };
      final current = {
        'method': 'GET',
        'url': 'https://api.apidash.dev/',
        'headers': <String, String>{},
        'params': <String, String>{},
        'form': true,
        'formData': null,
      };
      final diff = CurlImportService.diffWithCurrent(payload, current);
      expect(diff, '''~ method: "GET" → "POST"
~ url: "https://api.apidash.dev/" → "https://api.apidash.dev/upload"
~ formData: null → [{"name":"field1","value":"val1"},{"name":"field2","value":"val2"}]''');
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
      final diff = CurlImportService.diffWithCurrent(newPayload, current);
      expect(diff, '''~ method: "GET" → "post"
~ url: "https://api.apidash.dev/a?x=1&y=2" → "https://api.apidash.dev/b"
~ headers: {"X-A":"1","X-Remove":"gone"} → {"X-A":"2","X-New":"n"}
~ params: {"x":"1","y":"2"} → {"x":"2","z":"3"}
~ body: "{"a":1}" → "{"a":1,"b":2}"''');

      final msg = CurlImportService.buildActionMessageFromPayload(
        newPayload,
        current: current,
        note: 'note here',
        insights: 'extra insights',
      );
      // note & insights included
      expect(msg['note'], 'note here');
      final expl = msg['explanation'] as String;
      expect(expl, contains('extra insights'));
      // diff narrative lines
      expect(expl, contains('apply the changes?')); // diff section
    });
  });
}
