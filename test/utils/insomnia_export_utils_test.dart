import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/utils/insomnia_export_utils.dart';
import '../models/request_models.dart';

void main() {
  group('Testing Insomnia Export Utils', () {
    group('collectionToInsomnia', () {
      test('returns valid Insomnia v4 structure with null collection', () {
        final result = collectionToInsomnia(null);
        expect(result['_type'], 'export');
        expect(result['__export_format'], 4);
        expect(result['__export_source'], 'apidash');
        expect(result['resources'], isNotNull);

        final resources = result['resources'] as List;
        expect(resources.length, 2); // workspace + request_group
        expect(resources.any((r) => r['_type'] == 'workspace'), isTrue);
        expect(resources.any((r) => r['_type'] == 'request_group'), isTrue);
      });

      test('returns valid Insomnia v4 structure with empty collection', () {
        final result = collectionToInsomnia([]);
        expect(result['_type'], 'export');
        expect(result['__export_format'], 4);
        final resources = result['resources'] as List;
        expect(resources.length, 2);
      });

      test('custom collection name is used', () {
        final result = collectionToInsomnia(
          [],
          collectionName: 'My Custom Collection',
        );
        final resources = result['resources'] as List;
        final workspace = resources.firstWhere((r) => r['_type'] == 'workspace');
        expect(workspace['name'], 'My Custom Collection');
      });

      test('exports basic GET request', () {
        final result = collectionToInsomnia([requestModelGet1]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        expect(requests.length, 1);

        final request = requests[0] as Map<String, dynamic>;
        expect(request['method'], 'GET');
        expect(request['url'], contains('api.apidash.dev'));
        expect(request['name'], 'https://api.apidash.dev');
      });

      test('exports GET request with query params', () {
        final result = collectionToInsomnia([requestModelGet2]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        expect(requests.length, 1);

        final request = requests[0] as Map<String, dynamic>;
        expect(request['parameters'], isNotNull);
        final params = request['parameters'] as List;
        expect(params.length, 1);
        expect(params[0]['name'], 'code');
        expect(params[0]['value'], 'US');
      });

      test('exports GET request with headers', () {
        final result = collectionToInsomnia([requestModelGet5]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        expect(requests.length, 1);

        final request = requests[0] as Map<String, dynamic>;
        expect(request['headers'], isNotNull);
        final headers = request['headers'] as List;
        expect(headers.length, 1);
        expect(headers[0]['name'], 'User-Agent');
        expect(headers[0]['value'], 'Test Agent');
      });

      test('exports GET request with some params disabled', () {
        final result = collectionToInsomnia([requestModelGet9]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        final request = requests[0] as Map<String, dynamic>;
        final params = request['parameters'] as List;

        expect(params.length, 4);
        expect(params[0]['name'], 'num');
        expect(params[0]['disabled'], isNot(true));
        expect(params[1]['name'], 'digits');
        expect(params[1]['disabled'], true);
        expect(params[2]['name'], 'system');
        expect(params[2]['disabled'], true);
        expect(params[3]['name'], 'add_space');
        expect(params[3]['disabled'], isNot(true));
      });

      test('exports POST request with JSON body', () {
        final result = collectionToInsomnia([requestModelPost2]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        final request = requests[0] as Map<String, dynamic>;

        expect(request['method'], 'POST');
        expect(request['body'], isNotNull);
        final body = request['body'] as Map<String, dynamic>;
        expect(body['mimeType'], contains('json'));
        expect(body['text'], isNotNull);
      });

      test('exports POST request with form data', () {
        final result = collectionToInsomnia([requestModelPost4]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        final request = requests[0] as Map<String, dynamic>;

        expect(request['method'], 'POST');
        final body = request['body'] as Map<String, dynamic>;
        expect(body['params'], isNotNull);
        final formdata = body['params'] as List;
        expect(formdata.length, 3);
        expect(formdata[0]['name'], 'text');
        expect(formdata[0]['value'], 'API');
        expect(formdata[0]['type'], 'text');
      });

      test('exports POST request with mixed form data (text + file)', () {
        final result = collectionToInsomnia([requestModelPost6]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        final request = requests[0] as Map<String, dynamic>;

        final body = request['body'] as Map<String, dynamic>;
        final formdata = body['params'] as List;
        expect(formdata.length, 2);
        expect(formdata[0]['name'], 'token');
        expect(formdata[0]['value'], 'xyz');
        expect(formdata[0]['type'], 'text');
        expect(formdata[1]['name'], 'imfile');
        expect(formdata[1]['type'], 'file');
        expect(formdata[1]['fileName'], '1.png');
      });

      test('exports multiple requests', () {
        final result = collectionToInsomnia([
          requestModelGet6,
          requestModelGet11,
          requestModelPost3,
        ]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        expect(requests.length, 3);
      });

      test('uses URL as item name when request name is empty', () {
        final result = collectionToInsomnia([requestModelGet1]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        final request = requests[0] as Map<String, dynamic>;
        expect(request['name'], 'https://api.apidash.dev');
      });

      test('exports DELETE request without body', () {
        final result = collectionToInsomnia([requestModelDelete1]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        final request = requests[0] as Map<String, dynamic>;

        expect(request['method'], 'DELETE');
        final body = request['body'] as Map<String, dynamic>;
        expect(body.isEmpty, isTrue);
      });

      test('exports HEAD request', () {
        final result = collectionToInsomnia([requestModelHead1]);
        final resources = result['resources'] as List;
        final requests = resources.where((r) => r['_type'] == 'request').toList();
        final request = requests[0] as Map<String, dynamic>;
        expect(request['method'], 'HEAD');
      });
    });

    group('insomniaCollectionToJsonString', () {
      test('produces valid JSON string', () {
        final collection = collectionToInsomnia([requestModelGet1]);
        final jsonStr = insomniaCollectionToJsonString(collection);
        expect(jsonStr, isNotNull);
        expect(jsonStr.contains('"_type"'), isTrue);
        expect(jsonStr.contains('"resources"'), isTrue);
      });

      test('produces indented JSON', () {
        final collection = collectionToInsomnia([requestModelGet1]);
        final jsonStr = insomniaCollectionToJsonString(collection);
        expect(jsonStr.contains('\n'), isTrue);
        expect(jsonStr.contains('  '), isTrue);
      });
    });
  });
}
