import 'package:apidash/importer/curl/curl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  late CurlFileImport curlImport;

  setUp(() {
    curlImport = CurlFileImport();
  });

  group('CurlFileImport Tests', () {
    test('should parse basic GET request', () {
      const curl = 'curl http://example.com';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.method, equals(HTTPVerb.get));
      expect(result.url, equals('http://example.com'));
      expect(result.headers, isNull);
      expect(result.params, isEmpty);
      expect(result.body, isNull);
      expect(result.bodyContentType, equals(ContentType.json));
    });

    test('should parse POST request with JSON body and content-type header',
        () {
      const curl = '''
        curl -X POST http://example.com/api 
        -H "Content-Type: application/json" 
        -d '{"key": "value"}'
      ''';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.method, equals(HTTPVerb.post));
      expect(result.url, equals('http://example.com/api'));
      expect(result.headers!.length, equals(1));
      expect(result.headers!.first.name, equals('Content-Type'));
      expect(result.headers!.first.value, equals('application/json'));
      expect(result.body, equals('{"key": "value"}'));
      expect(result.bodyContentType, equals(ContentType.json));
    });

    test(
        'should parse POST request with url-encoded form data without content-type',
        () {
      const curl = '''
    curl -X POST http://example.com/upload 
    -d "param1=value1&param2=value2" 
  ''';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.method, equals(HTTPVerb.post));
      expect(result.bodyContentType, equals(ContentType.formdata));
      expect(
          result.formDataList,
          equals([
            const FormDataModel(
                name: 'param1', value: 'value1', type: FormDataType.text),
            const FormDataModel(
                name: 'param2', value: 'value2', type: FormDataType.text),
          ]));
    });

    test('should parse POST request with form-data', () {
      const curl = '''
       curl -X POST https://example.com/upload \\
  -F "file=@/path/to/image.jpg" \\
  -F "username=john"

      ''';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.method, equals(HTTPVerb.post));
      expect(result.bodyContentType, equals(ContentType.formdata));
      expect(result.formDataList.length, equals(2));
      expect(result.formDataList[0].name, equals('file'));
      expect(result.formDataList[0].value, equals('/path/to/image.jpg'));
      expect(result.formDataList[0].type, equals(FormDataType.file));
    });

    test('should parse request with query parameters', () {
      const curl = 'curl "http://example.com/api?param1=value1&param2=value2"';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.params!.length, equals(2));
      expect(result.params![0].name, equals('param1'));
      expect(result.params![0].value, equals('value1'));
      expect(result.params![1].name, equals('param2'));
      expect(result.params![1].value, equals('value2'));
    });

    test('should detect JSON body without content-type header', () {
      const curl = '''
        curl -X POST http://example.com/api 
        -d '{"key": "value"}'
      ''';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.bodyContentType, equals(ContentType.json));
      expect(result.body, equals('{"key": "value"}'));
    });

    test('should detect text body when JSON is invalid', () {
      const curl = '''
        curl -X POST http://example.com/api 
        -d 'invalid json data'
      ''';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.bodyContentType, equals(ContentType.text));
      expect(result.body, equals('invalid json data'));
    });

    test('should handle text/plain content-type', () {
      const curl = '''
        curl -X POST http://example.com/api 
        -H "Content-Type: text/plain" 
        -d 'Hello World'
      ''';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.bodyContentType, equals(ContentType.text));
      expect(result.body, equals('Hello World'));
    });

    test('should handle multiple headers', () {
      const curl = '''
        curl http://example.com/api 
        -H "Authorization: Bearer token123" 
        -H "Accept: application/json"
      ''';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.headers!.length, equals(2));
      expect(result.headers![0].name, equals('Authorization'));
      expect(result.headers![0].value, equals('Bearer token123'));
      expect(result.headers![1].name, equals('Accept'));
      expect(result.headers![1].value, equals('application/json'));
    });

    test('should parse URL-encoded form data', () {
      const curl = '''
        curl -X POST http://example.com/upload 
        -d "name=john&age=25&description=test%20value" 
      ''';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNotNull);
      expect(result!.method, equals(HTTPVerb.post));
      expect(result.bodyContentType, equals(ContentType.formdata));
      expect(result.formData, isNotNull);
      expect(result.formData!.length, equals(3));

      expect(result.formData![0].name, equals('name'));
      expect(result.formData![0].value, equals('john'));
      expect(result.formData![0].type, equals(FormDataType.text));

      expect(result.formData![1].name, equals('age'));
      expect(result.formData![1].value, equals('25'));
      expect(result.formData![1].type, equals(FormDataType.text));

      expect(result.formData![2].name, equals('description'));
      expect(result.formData![2].value, equals('test value')); // URL decoded
      expect(result.formData![2].type, equals(FormDataType.text));
    });

    test('should return null for invalid curl command', () {
      const curl = 'invalid curl command';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNull);
    });

    test('should handle empty content', () {
      const curl = '';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNull);
    });

    test('should handle whitespace-only content', () {
      const curl = '   \n   \t   ';
      final result = curlImport.getHttpRequestModel(curl);

      expect(result, isNull);
    });
  });
}
