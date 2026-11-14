import 'dart:convert';

import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('HarParserIO parseFormData', () {
    late HarParserIO harParser;

    setUp(() {
      harParser = HarParserIO();
    });

    test('parses a simple key-value pair', () {
      expect(harParser.parseFormData('name=apidash'), {'name': 'apidash'});
    });

    test('keeps values containing a trailing = (base64)', () {
      expect(
        harParser.parseFormData('token=YWJjZA=='),
        {'token': 'YWJjZA=='},
      );
    });

    test('keeps values containing = in the middle', () {
      expect(
        harParser.parseFormData('filter=a=b'),
        {'filter': 'a=b'},
      );
    });

    test('preserves all pairs when a value contains =', () {
      expect(
        harParser.parseFormData('user=deepak&token=abc==&role=admin'),
        {'user': 'deepak', 'token': 'abc==', 'role': 'admin'},
      );
    });

    test('decodes percent-encoded keys and values', () {
      expect(
        harParser.parseFormData('full%20name=John%20Doe'),
        {'full name': 'John Doe'},
      );
    });

    test('decodes plus signs as spaces in form data', () {
      expect(
        harParser.parseFormData('full+name=John+Doe'),
        {'full name': 'John Doe'},
      );
    });

    test('handles an empty value', () {
      expect(harParser.parseFormData('key='), {'key': ''});
    });

    test('returns an empty map for null or empty input', () {
      expect(harParser.parseFormData(null), {});
      expect(harParser.parseFormData(''), {});
    });
  });

  group('HarParserIO request body with mimeType parameters', () {
    HttpRequestModel importPostData(Map<String, dynamic> postData) {
      final content = jsonEncode({
        'log': {
          'entries': [
            {
              'request': {
                'method': 'POST',
                'url': 'https://api.apidash.dev/case/lower',
                'postData': postData,
              },
            },
          ],
        },
      });
      return HarParserIO().getHttpRequestModelList(content)!.single.$2;
    }

    test('keeps a JSON body when mimeType has a charset', () {
      final request = importPostData({
        'mimeType': 'application/json; charset=utf-8',
        'text': '{"text": "API"}',
      });
      expect(request.bodyContentType, ContentType.json);
      expect(request.body, '{"text": "API"}');
    });

    test('keeps url-encoded fields when mimeType has a charset', () {
      final request = importPostData({
        'mimeType': 'application/x-www-form-urlencoded; charset=UTF-8',
        'text': 'text=API&times=3',
      });
      expect(request.bodyContentType, ContentType.formdata);
      expect(request.formData, const [
        FormDataModel(name: 'text', value: 'API', type: FormDataType.text),
        FormDataModel(name: 'times', value: '3', type: FormDataType.text),
      ]);
    });

    test('keeps multipart fields when mimeType has a boundary', () {
      final request = importPostData({
        'mimeType': 'multipart/form-data; boundary=----WebKitFormBoundary7MA4',
        'params': [
          {'name': 'text', 'value': 'API', 'contentType': 'text/plain'},
        ],
      });
      expect(request.bodyContentType, ContentType.formdata);
      expect(request.formData, const [
        FormDataModel(name: 'text', value: 'API', type: FormDataType.text),
      ]);
    });

    test('keeps a plain text body', () {
      final request = importPostData({
        'mimeType': 'text/plain; charset=utf-8',
        'text': 'hello',
      });
      expect(request.bodyContentType, ContentType.text);
      expect(request.body, 'hello');
    });
  });
}
