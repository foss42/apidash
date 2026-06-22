import 'package:apidash/apitoolgen/request_consolidator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('APIDashRequestDescription Tests', () {
    test('generateREQDATA generates correct string for basic request', () {
      final req = APIDashRequestDescription(
        endpoint: 'https://api.test.com',
        method: 'GET',
      );
      final result = req.generateREQDATA;
      expect(result, contains('METHOD: GET'));
      expect(result, contains('ENDPOINT: https://api.test.com'));
      expect(result, contains('HEADERS: {}'));
    });

    test('generateREQDATA handles query parameters', () {
      final req = APIDashRequestDescription(
        endpoint: 'https://api.test.com',
        method: 'GET',
        queryParams: {'q': 'test'},
      );
      final result = req.generateREQDATA;
      expect(result, contains('QUERY_PARAMETERS: {'));
      expect(result, contains('q: test <String>'));
    });

    test('generateREQDATA handles headers', () {
      final req = APIDashRequestDescription(
        endpoint: 'https://api.test.com',
        method: 'GET',
        headers: {'Authorization': 'Bearer token'},
      );
      final result = req.generateREQDATA;
      expect(result, contains('HEADERS: {'));
      expect(result, contains('Authorization: Bearer token <String>'));
    });

    test('generateREQDATA handles text body', () {
      final req = APIDashRequestDescription(
        endpoint: 'https://api.test.com',
        method: 'POST',
        bodyTXT: 'Hello World',
      );
      final result = req.generateREQDATA;
      expect(result, contains('BODY_TYPE: TEXT'));
      expect(result, contains('BODY_TEXT:Hello World'));
    });

    test('generateREQDATA handles JSON body', () {
      final req = APIDashRequestDescription(
        endpoint: 'https://api.test.com',
        method: 'POST',
        bodyJSON: {
          'key': 'value',
          'nested': {'inner': 1},
        },
      );
      final result = req.generateREQDATA;
      expect(result, contains('BODY_TYPE: JSON'));
      expect(result, contains('key: TYPE: <String>'));
      expect(result, contains('nested: TYPE: <\t{\tinner: TYPE: int'));
      expect(result, contains('}>'));
    });

    test('generateREQDATA handles form data', () {
      final req = APIDashRequestDescription(
        endpoint: 'https://api.test.com',
        method: 'POST',
        formData: [
          {'name': 'file', 'type': 'file', 'value': 'path'},
        ],
      );
      final result = req.generateREQDATA;
      expect(result, contains('BODY_TYPE: FORM-DATA'));
      expect(result, contains('{name: file, type: file, value: path}'));
    });

    test('generateREQDATA handles response details', () {
      final req = APIDashRequestDescription(
        endpoint: 'https://api.test.com',
        method: 'GET',
        responseType: 'JSON',
        response: '{"status":"ok"}',
      );
      final result = req.generateREQDATA;
      expect(result, contains('-----RESPONSE_DETAILS-----'));
      expect(result, contains('RESPONSE_TYPE: JSON'));
      expect(result, contains('RESPONSE_BODY: {"status":"ok"}'));
    });
  });
}
