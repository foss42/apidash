import 'package:test/test.dart';
import 'package:http_parser/http_parser.dart';
import 'package:apidash/utils/http_utils.dart';

void main() {
  group("Testing getRequestTitleFromUrl function", () {
    String titleUntitled = "untitled";
    test('Testing getRequestTitleFromUrl using url1', () {
      String url1 = "";
      expect(getRequestTitleFromUrl(url1), titleUntitled);
    });

    test('Testing getRequestTitleFromUrl using url2', () {
      String url2 = " ";
      expect(getRequestTitleFromUrl(url2), titleUntitled);
    });

    test('Testing getRequestTitleFromUrl using url3', () {
      String url3 = "https://api.foss42.com/country/codes";
      String title3Expected = "api.foss42.com/country/codes";
      expect(getRequestTitleFromUrl(url3), title3Expected);
    });

    test('Testing getRequestTitleFromUrl using url4', () {
      String url4 = "api.foss42.com/country/data";
      String title4Expected = "api.foss42.com/country/data";
      expect(getRequestTitleFromUrl(url4), title4Expected);
    });

    test('Testing getRequestTitleFromUrl using url5', () {
      String url5 = "http://";
      expect(getRequestTitleFromUrl(url5), titleUntitled);
    });

    test('Testing getRequestTitleFromUrl for null value', () {
      expect(getRequestTitleFromUrl(null), titleUntitled);
    });
  });

  group("Testing getContentTypeFromHeaders function", () {
    test('Testing getContentTypeFromHeaders for header1', () {
      Map<String, String> header1 = {
        "content-type": "application/json",
      };
      String contentType1Expected = "application/json";
      expect(getContentTypeFromHeaders(header1), contentType1Expected);
    });
    test('Testing getContentTypeFromHeaders for null headers', () {
      expect(getContentTypeFromHeaders(null), null);
    });
    test(
        'Testing getContentTypeFromHeaders when header keys are in header case',
        () {
      Map<String, String> header2 = {
        "Content-Type": "application/json",
      };
      expect(getContentTypeFromHeaders(header2), null);
    });
  });

  group('Testing getMediaTypeFromContentType function', () {
    test('Testing getMediaTypeFromContentType for json type', () {
      String contentType1 = "application/json";
      MediaType mediaType1Expected = MediaType("application", "json");
      expect(getMediaTypeFromContentType(contentType1).toString(),
          mediaType1Expected.toString());
    });
    test('Testing getMediaTypeFromContentType for null', () {
      expect(getMediaTypeFromContentType(null), null);
    });
    test('Testing getMediaTypeFromContentType for image svg+xml type', () {
      String contentType3 = "image/svg+xml";
      MediaType mediaType3Expected = MediaType("image", "svg+xml");
      expect(getMediaTypeFromContentType(contentType3).toString(),
          mediaType3Expected.toString());
    });
    test('Testing getMediaTypeFromContentType for incorrect content type', () {
      String contentType4 = "text/html : charset=utf-8";
      expect(getMediaTypeFromContentType(contentType4), null);
    });
    test('Testing getMediaTypeFromContentType for text/css type', () {
      String contentType5 = "text/css; charset=utf-8";
      MediaType mediaType5Expected =
          MediaType("text", "css", {"charset": "utf-8"});
      expect(getMediaTypeFromContentType(contentType5).toString(),
          mediaType5Expected.toString());
    });
    test('Testing getMediaTypeFromContentType for incorrect with double ;', () {
      String contentType6 =
          "application/xml; charset=utf-16be ; date=21/03/2023";
      expect(getMediaTypeFromContentType(contentType6), null);
    });
    test('Testing getMediaTypeFromContentType for empty content type', () {
      expect(getMediaTypeFromContentType(""), null);
    });
    test('Testing getMediaTypeFromContentType for missing subtype', () {
      String contentType7 = "audio";
      expect(getMediaTypeFromContentType(contentType7), null);
    });
    test('Testing getMediaTypeFromContentType for missing Type', () {
      String contentType8 = "/html";
      expect(getMediaTypeFromContentType(contentType8), null);
    });
  });
}
