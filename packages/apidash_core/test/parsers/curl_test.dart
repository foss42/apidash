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
              headers: null,
              params: [],
              body: null,
              bodyContentType: ContentType.text,
              formData: null));
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
          formData: null,
        ),
      );
    });

    test('should parse form data request', () {
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
            body: null,
            bodyContentType: ContentType.formdata,
            formData: [
              FormDataModel(
                  name: 'file', value: 'photo.jpg', type: FormDataType.file),
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
  });
}
