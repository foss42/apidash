import 'dart:convert';

import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('PostmanIO request body', () {
    HttpRequestModel importBody(Map<String, dynamic> body) {
      final content = jsonEncode({
        'info': {'name': 'test'},
        'item': [
          {
            'name': 'form',
            'request': {
              'method': 'POST',
              'url': {'raw': 'https://api.apidash.dev/io/form'},
              'body': body,
            },
          },
        ],
      });
      return PostmanIO().getHttpRequestModelList(content)!.single.$2;
    }

    test('imports urlencoded fields', () {
      final request = importBody({
        'mode': 'urlencoded',
        'urlencoded': [
          {'key': 'text', 'value': 'API', 'type': 'text'},
          {'key': 'times', 'value': '3', 'type': 'text'},
        ],
      });
      expect(request.bodyContentType, ContentType.formdata);
      expect(request.formData, const [
        FormDataModel(name: 'text', value: 'API', type: FormDataType.text),
        FormDataModel(name: 'times', value: '3', type: FormDataType.text),
      ]);
    });

    test('skips disabled urlencoded fields', () {
      final request = importBody({
        'mode': 'urlencoded',
        'urlencoded': [
          {'key': 'text', 'value': 'API', 'type': 'text'},
          {'key': 'times', 'value': '3', 'type': 'text', 'disabled': true},
        ],
      });
      expect(request.formData, const [
        FormDataModel(name: 'text', value: 'API', type: FormDataType.text),
      ]);
    });

    test('still imports formdata fields', () {
      final request = importBody({
        'mode': 'formdata',
        'formdata': [
          {'key': 'text', 'value': 'API', 'type': 'text'},
        ],
      });
      expect(request.bodyContentType, ContentType.formdata);
      expect(request.formData, const [
        FormDataModel(name: 'text', value: 'API', type: FormDataType.text),
      ]);
    });
  });
}
