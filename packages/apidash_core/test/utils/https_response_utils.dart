import 'package:apidash_core/utils/http_response_utils.dart';
import 'package:apidash_core/utils/string_utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';

void main() {
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

  group("Testing getMediaTypeFromHeaders", () {
    test('Testing getMediaTypeFromHeaders for basic case', () {
      Map<String, String> header1 = {
        "content-length": "4506",
        "cache-control": "private",
        "content-type": "application/json"
      };
      MediaType mediaType1Expected = MediaType("application", "json");
      expect(getMediaTypeFromHeaders(header1).toString(),
          mediaType1Expected.toString());
    });
    test('Testing getMediaTypeFromHeaders for null header', () {
      expect(getMediaTypeFromHeaders(null), null);
    });
    test('Testing getMediaTypeFromHeaders for incomplete header value', () {
      Map<String, String> header2 = {"content-length": "4506"};
      expect(getMediaTypeFromHeaders(header2), null);
    });
    test('Testing getMediaTypeFromHeaders for empty header value', () {
      Map<String, String> header3 = {"content-type": ""};
      expect(getMediaTypeFromHeaders(header3), null);
    });
    test(
        'Testing getMediaTypeFromHeaders for erroneous header value - missing type',
        () {
      Map<String, String> header4 = {"content-type": "/json"};
      expect(getMediaTypeFromHeaders(header4), null);
    });
    test(
        'Testing getMediaTypeFromHeaders for erroneous header value - missing subtype',
        () {
      Map<String, String> header5 = {"content-type": "application"};
      expect(getMediaTypeFromHeaders(header5), null);
    });
    test('Testing getMediaTypeFromHeaders for header6', () {
      Map<String, String> header6 = {"content-type": "image/svg+xml"};
      MediaType mediaType6Expected = MediaType("image", "svg+xml");
      expect(getMediaTypeFromHeaders(header6).toString(),
          mediaType6Expected.toString());
    });
  });

  group("Testing formatBody", () {
    test('Testing formatBody for null values', () {
      expect(formatBody(null, null), null);
    });
    test('Testing formatBody for null body values', () {
      MediaType mediaType1 = MediaType("application", "xml");
      expect(formatBody(null, mediaType1), null);
    });
    test('Testing formatBody for null MediaType values', () {
      String body1 = '''
  {
    "text":"The Chosen One";
  }
''';
      expect(formatBody(body1, null), null);
    });
    test('Testing formatBody for json subtype values', () {
      String body2 = '''{"data":{"area":9831510.0,"population":331893745}}''';
      MediaType mediaType2 = MediaType("application", "json");
      String result2Expected = '''{
  "data": {
    "area": 9831510.0,
    "population": 331893745
  }
}''';
      expect(formatBody(body2, mediaType2), result2Expected);
    });
    test('Testing formatBody for xml subtype values', () {
      String body3 = '''
<breakfast_menu>
<food>
<name>Belgian Waffles</name>
<price>5.95 USD</price>
<description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
<calories>650</calories>
</food>
</breakfast_menu>
''';
      MediaType mediaType3 = MediaType("application", "xml");
      String result3Expected = '''<breakfast_menu>
  <food>
    <name>Belgian Waffles</name>
    <price>5.95 USD</price>
    <description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
    <calories>650</calories>
  </food>
</breakfast_menu>''';
      expect(formatBody(body3, mediaType3), result3Expected);
    });
    group("Testing formatBody for html", () {
      MediaType mediaTypeHtml = MediaType("text", "html");
      test('Testing formatBody for html subtype values', () {
        String body4 = '''<html>
<body>
<h1>My First Heading</h1>
<p>My first paragraph.</p>
</body>
</html>''';
        expect(formatBody(body4, mediaTypeHtml), body4);
      });

      test('Testing formatBody for html subtype values with random values', () {
        String body5 =
            '''<html>${RandomStringGenerator.getRandomStringLines(100, 10000)}</html>''';
        expect(formatBody(body5, mediaTypeHtml), null);
      });
      test(
          'Testing formatBody for html subtype values with random values within limit',
          () {
        String body6 =
            '''<html>${RandomStringGenerator.getRandomStringLines(100, 190)}</html>''';
        expect(formatBody(body6, mediaTypeHtml), body6);
      });
    });
  });
}
