import 'package:apidash/workflow/models/workflow_request_codec.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('decodeWorkflowRequest', () {
    test('reads slim Dashbot {method,url} into HttpRequestModel', () {
      final model = decodeWorkflowRequest({
        'method': 'GET',
        'url': 'https://apidash.dev/users',
      });
      expect(model.httpRequestModel?.method, HTTPVerb.get);
      expect(model.httpRequestModel?.url, 'https://apidash.dev/users');
    });

    test('reads nested httpRequestModel', () {
      final model = decodeWorkflowRequest({
        'id': 'req1',
        'httpRequestModel': {
          'method': 'post',
          'url': 'https://api.example.com/login',
        },
      });
      expect(model.id, 'req1');
      expect(model.httpRequestModel?.method, HTTPVerb.post);
      expect(model.httpRequestModel?.url, 'https://api.example.com/login');
    });
  });
}
