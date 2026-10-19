import 'package:test/test.dart';
import 'package:har/har.dart' as har;
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

  group('HarParserIO harRequestToHttpRequestModel request body', () {
    late HarParserIO harParser;

    setUp(() {
      harParser = HarParserIO();
    });

    HttpRequestModel parseWithPostData(har.PostData postData) =>
        harParser.harRequestToHttpRequestModel(
          har.Request(
            method: 'POST',
            url: 'https://example.com/items',
            postData: postData,
          ),
        );

    test('keeps a JSON body whose mimeType carries a charset parameter', () {
      final model = parseWithPostData(
        har.PostData(
          mimeType: 'application/json; charset=UTF-8',
          text: '{"name":"apidash"}',
        ),
      );

      expect(model.bodyContentType, ContentType.json);
      expect(model.body, '{"name":"apidash"}');
    });

    test('keeps a JSON body with no mimeType parameters as before', () {
      final model = parseWithPostData(
        har.PostData(mimeType: 'application/json', text: '{"a":1}'),
      );

      expect(model.bodyContentType, ContentType.json);
      expect(model.body, '{"a":1}');
    });

    test('imports a url-encoded body whose mimeType carries a charset', () {
      final model = parseWithPostData(
        har.PostData(
          mimeType: 'application/x-www-form-urlencoded; charset=utf-8',
          text: 'tag=red&page=2',
        ),
      );

      expect(model.bodyContentType, ContentType.formdata);
      expect(model.body, isNull);
      expect(
        model.formData?.map((field) => '${field.name}=${field.value}'),
        ['tag=red', 'page=2'],
      );
    });

    test('imports a multipart body whose mimeType carries a boundary', () {
      final model = parseWithPostData(
        har.PostData(
          mimeType: 'multipart/form-data; boundary=----WebKitFormBoundaryabc',
          params: [
            har.Param(
              name: 'note',
              value: 'hello',
              contentType: 'text/plain; charset=utf-8',
            ),
            har.Param(
              name: 'avatar',
              fileName: 'avatar.png',
              contentType: 'image/png',
            ),
          ],
        ),
      );

      expect(model.bodyContentType, ContentType.formdata);
      expect(model.body, isNull);
      expect(model.formData?.length, 2);
      expect(model.formData?[0].name, 'note');
      expect(model.formData?[0].value, 'hello');
      expect(model.formData?[0].type, FormDataType.text);
      expect(model.formData?[1].name, 'avatar');
      expect(model.formData?[1].value, 'avatar.png');
      expect(model.formData?[1].type, FormDataType.file);
    });

    test('keeps a plain-text body instead of dropping it', () {
      final model = parseWithPostData(
        har.PostData(mimeType: 'text/plain', text: 'raw payload'),
      );

      expect(model.bodyContentType, ContentType.text);
      expect(model.body, 'raw payload');
    });

    test('keeps an xml body as text', () {
      final model = parseWithPostData(
        har.PostData(
          mimeType: 'application/xml; charset=utf-8',
          text: '<item/>',
        ),
      );

      expect(model.bodyContentType, ContentType.text);
      expect(model.body, '<item/>');
    });
  });
}
