import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('CurlFileImport Tests', () {
    late CurlIO curlImport;

    setUp(() {
      curlImport = CurlIO();
    });

    test('should parse simple GET request', () {
      const curl = 'curl https://api.apidash.dev/users';
      final result = curlImport.getHttpRequestModelList(curl);

      expect(
          result?[0],
          const HttpRequestModel(
              method: HTTPVerb.get,
              url: 'https://api.apidash.dev/users',
              headers: [],
              params: [],
              body: '',
              bodyContentType: ContentType.text,
              formData: []));
    });

    test('should parse POST request with JSON body and headers', () {
      const curl = '''
        curl -X POST https://api.apidash.dev/users 
        -H "Content-Type: application/json" 
        -H "Authorization: Bearer token123" 
        -d '{"name": "John", "age": 30}'
      ''';

      final result = curlImport.getHttpRequestModelList(curl);

      expect(
        result?[0],
        const HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.apidash.dev/users',
          headers: [
            NameValueModel(name: 'Content-Type', value: 'application/json'),
            NameValueModel(name: 'Authorization', value: 'Bearer token123'),
          ],
          params: [],
          body: '{"name": "John", "age": 30}',
          bodyContentType: ContentType.json,
          formData: [],
        ),
      );
    });

    test(
        'should parse form data request and file set to '
        ' so that user can select it.', () {
      const curl = '''
        curl -X POST https://api.apidash.dev/upload 
        -F "file=@photo.jpg" 
        -F "description=My Photo"
      ''';

      final result = curlImport.getHttpRequestModelList(curl);

      expect(
          result?[0],
          const HttpRequestModel(
            method: HTTPVerb.post,
            url: 'https://api.apidash.dev/upload',
            headers: [
              NameValueModel(name: "Content-Type", value: "multipart/form-data")
            ],
            params: [],
            body: '',
            bodyContentType: ContentType.formdata,
            formData: [
              FormDataModel(name: 'file', value: '', type: FormDataType.file),
              FormDataModel(
                  name: 'description',
                  value: 'My Photo',
                  type: FormDataType.text),
            ],
          ));
    });

    test('should return null for invalid curl command', () {
      const curl = 'invalid curl command';
      final result = curlImport.getHttpRequestModelList(curl);

      expect(result, isNull);
    });

    test('should parse multiple curl commands', () {
      const curl = '''
        curl https://api.apidash.dev/users

        curl -X POST https://api.apidash.dev/create 
        -H "Content-Type: application/json" 
        -d '{"title": "Test"}'
        
        curl https://api.apidash.dev/status
      ''';

      final result = curlImport.getHttpRequestModelList(curl);

      expect(result?.length, 3);
      expect(result?[0].method, HTTPVerb.get);
      expect(result?[0].url, 'https://api.apidash.dev/users');
      expect(result?[1].method, HTTPVerb.post);
      expect(result?[1].url, 'https://api.apidash.dev/create');
      expect(result?[2].method, HTTPVerb.get);
      expect(result?[2].url, 'https://api.apidash.dev/status');
    });

    test('should skip invalid curl commands and parse valid ones', () {
      const curl = '''
        curl https://api.apidash.dev/valid1
        
        not a curl command
        
        curl -X POST https://api.apidash.dev/valid2 -d "data"
      ''';

      final result = curlImport.getHttpRequestModelList(curl);

      expect(result?.length, 2);
      expect(result?[0].url, 'https://api.apidash.dev/valid1');
      expect(result?[1].url, 'https://api.apidash.dev/valid2');
    });

    test('should return null if all curl commands are invalid', () {
      const curl = '''
        invalid command 1
        also invalid
        still not valid
      ''';

      final result = curlImport.getHttpRequestModelList(curl);

      expect(result, isNull);
    });

    test('should return null for empty string', () {
      const curl = '';
      final result = curlImport.getHttpRequestModelList(curl);
      expect(result, isNull);
    });

    test('should return null for whitespace-only string', () {
      const curl = '   \n  \t  ';
      final result = curlImport.getHttpRequestModelList(curl);
      expect(result, isNull);
    });

    test('should parse curl with query parameters in URL', () {
      const curl =
          'curl "https://api.apidash.dev/search?q=flutter&page=1"';
      final result = curlImport.getHttpRequestModelList(curl);

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result[0].url, 'https://api.apidash.dev/search');
      expect(result[0].params?.length, 2);
    });

    test('should parse curl with PUT method', () {
      const curl = '''
        curl -X PUT https://api.apidash.dev/users/1 
        -H "Content-Type: application/json" 
        -d '{"name": "updated"}'
      ''';

      final result = curlImport.getHttpRequestModelList(curl);

      expect(result, isNotNull);
      expect(result![0].method, HTTPVerb.put);
      expect(result[0].url, 'https://api.apidash.dev/users/1');
      expect(result[0].body, '{"name": "updated"}');
    });

    test('should parse curl with DELETE method', () {
      const curl = 'curl -X DELETE https://api.apidash.dev/users/1';
      final result = curlImport.getHttpRequestModelList(curl);

      expect(result, isNotNull);
      expect(result![0].method, HTTPVerb.delete);
      expect(result[0].url, 'https://api.apidash.dev/users/1');
    });

    test('should parse curl with PATCH method', () {
      const curl = '''
        curl -X PATCH https://api.apidash.dev/users/1 
        -H "Content-Type: application/json" 
        -d '{"status": "active"}'
      ''';

      final result = curlImport.getHttpRequestModelList(curl);

      expect(result, isNotNull);
      expect(result![0].method, HTTPVerb.patch);
    });

    test('should parse curl with multiple headers', () {
      const curl = '''
        curl https://api.apidash.dev/data 
        -H "Accept: application/json" 
        -H "Authorization: Bearer mytoken" 
        -H "X-Custom-Header: customvalue"
      ''';

      final result = curlImport.getHttpRequestModelList(curl);

      expect(result, isNotNull);
      expect(result![0].headers?.length, 3);
    });

    test('should handle curl with --data flag instead of -d', () {
      const curl = '''
        curl -X POST https://api.apidash.dev/data 
        --data '{"key": "value"}'
      ''';

      final result = curlImport.getHttpRequestModelList(curl);

      expect(result, isNotNull);
      expect(result![0].method, HTTPVerb.post);
      expect(result[0].body, '{"key": "value"}');
    });
  });
}
