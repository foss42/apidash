import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

void main() {
  group('getMediaTypeFromContentType', () {
    test('Parses valid content type', () {
      final mediaType = getMediaTypeFromContentType('application/json');
      expect(mediaType, isNotNull);
      expect(mediaType!.type, 'application');
      expect(mediaType.subtype, 'json');
    });

    test('Returns null on invalid content type', () {
      final mediaType = getMediaTypeFromContentType('not-a-valid-header');
      expect(mediaType, isNull);
    });

    test('Returns null when input is null', () {
      final mediaType = getMediaTypeFromContentType(null);
      expect(mediaType, isNull);
    });
  });

  group('getContentTypeFromMediaType', () {
    test('Returns json content type for application/json', () {
      final mediaType = MediaType.parse('application/json');
      expect(getContentTypeFromMediaType(mediaType), ContentType.json);
    });

    test('Returns formdata for multipart/form-data', () {
      final mediaType = MediaType.parse('multipart/form-data');
      expect(getContentTypeFromMediaType(mediaType), ContentType.formdata);
    });

    test('Returns text for other types', () {
      final mediaType = MediaType.parse('text/html');
      expect(getContentTypeFromMediaType(mediaType), ContentType.text);
    });

    test('Returns null for null mediaType', () {
      expect(getContentTypeFromMediaType(null), isNull);
    });
  });

  group('getMediaTypeFromHeaders', () {
    test('Extracts MediaType from headers map', () {
      final headers = {"Content-Type": "application/json"};
      final mediaType = getMediaTypeFromHeaders(headers);
      expect(mediaType, isNotNull);
      expect(mediaType!.type, 'application');
      expect(mediaType.subtype, 'json');
    });

    test('Returns null if Content-Type is missing', () {
      final headers = {"Accept": "application/json"};
      expect(getMediaTypeFromHeaders(headers), isNull);
    });
  });

  group('getContentTypeFromHeadersMap', () {
    test('Returns ContentType.json from headers map', () {
      final headers = {"content-type": "application/json"};
      expect(getContentTypeFromHeadersMap(headers), ContentType.json);
    });

    test('Returns ContentType.formdata from headers map', () {
      final headers = {"Content-Type": "multipart/form-data"};
      expect(getContentTypeFromHeadersMap(headers), ContentType.formdata);
    });

    test('Returns null when headers map is null', () {
      expect(getContentTypeFromHeadersMap(null), isNull);
    });

    test('Returns null when Content-Type is missing', () {
      final headers = {"Accept": "application/json"};
      expect(getContentTypeFromHeadersMap(headers), isNull);
    });
  });

  group('getContentTypeFromContentTypeStr', () {
    test('Correctly parses string into ContentType', () {
      expect(
        getContentTypeFromContentTypeStr('application/json'),
        ContentType.json,
      );
      expect(
        getContentTypeFromContentTypeStr('multipart/form-data'),
        ContentType.formdata,
      );
    });

    test('Returns null for invalid string', () {
      expect(getContentTypeFromContentTypeStr('invalid-content-type'), isNull);
    });

    test('Returns null for null input', () {
      expect(getContentTypeFromContentTypeStr(null), isNull);
    });
  });
}
