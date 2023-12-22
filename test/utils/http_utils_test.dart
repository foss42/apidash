import 'package:test/test.dart';
import 'package:http_parser/http_parser.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:apidash/models/name_value_model.dart';
import 'package:apidash/consts.dart';
import '../test_utilities.dart';

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

  group("Testing getUriScheme", () {
    test('Testing getUriScheme for https', () {
      Uri uri1 = Uri(
          scheme: 'https',
          host: 'dart.dev',
          path: 'guides/libraries/library-tour',
          fragment: 'numbers');
      String uriScheme1Expected = 'https';
      expect(getUriScheme(uri1), (uriScheme1Expected, true));
    });
    test('Testing getUriScheme for mailto scheme value', () {
      Uri uri2 = Uri(scheme: 'mailto');
      String uriScheme2Expected = 'mailto';
      expect(getUriScheme(uri2), (uriScheme2Expected, false));
    });
    test('Testing getUriScheme for empty scheme value', () {
      Uri uri3 = Uri(scheme: '');
      expect(getUriScheme(uri3), (null, false));
    });
    test('Testing getUriScheme for null scheme value', () {
      Uri uri4 = Uri(scheme: null);
      expect(getUriScheme(uri4), (null, false));
    });
  });

  group("Testing getValidRequestUri", () {
    test('Testing getValidRequestUri for normal values', () {
      String url1 = "https://api.foss42.com/country/data";
      const kvRow1 = NameValueModel(name: "code", value: "US");
      Uri uri1Expected = Uri(
          scheme: 'https',
          host: 'api.foss42.com',
          path: 'country/data',
          queryParameters: {'code': 'US'});
      expect(getValidRequestUri(url1, [kvRow1]), (uri1Expected, null));
    });
    test('Testing getValidRequestUri for null url value', () {
      const kvRow2 = NameValueModel(name: "code", value: "US");
      expect(getValidRequestUri(null, [kvRow2]), (null, "URL is missing!"));
    });
    test('Testing getValidRequestUri for empty url value', () {
      const kvRow3 = NameValueModel(name: "", value: "");
      expect(getValidRequestUri("", [kvRow3]), (null, "URL is missing!"));
    });
    test('Testing getValidRequestUri when https is not provided in url', () {
      String url4 = "api.foss42.com/country/data";
      const kvRow4 = NameValueModel(name: "code", value: "US");
      Uri uri4Expected = Uri(
          scheme: 'https',
          host: 'api.foss42.com',
          path: 'country/data',
          queryParameters: {'code': 'US'});
      expect(getValidRequestUri(url4, [kvRow4]), (uri4Expected, null));
    });
    test('Testing getValidRequestUri when url has fragment', () {
      String url5 = "https://dart.dev/guides/libraries/library-tour#numbers";
      Uri uri5Expected = Uri(
          scheme: 'https',
          host: 'dart.dev',
          path: '/guides/libraries/library-tour');
      expect(getValidRequestUri(url5, null), (uri5Expected, null));
    });
    test('Testing getValidRequestUri when uri scheme is not supported', () {
      String url5 = "mailto:someone@example.com";
      expect(getValidRequestUri(url5, null),
          (null, "Unsupported URL Scheme (mailto)"));
    });
    test('Testing getValidRequestUri when query params in both url and kvrow',
        () {
      String url6 = "api.foss42.com/country/data?code=IND";
      const kvRow6 = NameValueModel(name: "code", value: "US");
      Uri uri6Expected = Uri(
          scheme: 'https',
          host: 'api.foss42.com',
          path: 'country/data',
          queryParameters: {'code': 'US'});
      expect(getValidRequestUri(url6, [kvRow6]), (uri6Expected, null));
    });
    test('Testing getValidRequestUri when kvrow is null', () {
      String url7 = "api.foss42.com/country/data?code=US";
      Uri uri7Expected = Uri(
          scheme: 'https',
          host: 'api.foss42.com',
          path: 'country/data',
          queryParameters: {'code': 'US'});
      expect(getValidRequestUri(url7, null), (uri7Expected, null));
    });
  });

  group("Testing getResponseBodyViewOptions", () {
    test('Testing getResponseBodyViewOptions for application/json', () {
      MediaType mediaType1 = MediaType("application", "json");
      var result1 = getResponseBodyViewOptions(mediaType1);
      expect(result1.$1, kPreviewRawBodyViewOptions);
      expect(result1.$2, "json");
    });
    test('Testing getResponseBodyViewOptions for application/xml', () {
      MediaType mediaType2 = MediaType("application", "xml");
      var result2 = getResponseBodyViewOptions(mediaType2);
      expect(result2.$1, kCodeRawBodyViewOptions);
      expect(result2.$2, "xml");
    });
    test(
        'Testing getResponseBodyViewOptions for message/news a format currently not supported',
        () {
      MediaType mediaType3 = MediaType("message", "news");
      var result3 = getResponseBodyViewOptions(mediaType3);
      expect(result3.$1, kNoBodyViewOptions);
      expect(result3.$2, null);
    });
    test('Testing getResponseBodyViewOptions for application/calendar+json',
        () {
      MediaType mediaType4 = MediaType("application", "calendar+json");
      var result4 = getResponseBodyViewOptions(mediaType4);
      expect(result4.$1, kPreviewRawBodyViewOptions);
      expect(result4.$2, "json");
    });
    test('Testing getResponseBodyViewOptions for image/svg+xml', () {
      MediaType mediaType5 = MediaType("image", "svg+xml");
      var result5 = getResponseBodyViewOptions(mediaType5);
      expect(result5.$1, kPreviewRawBodyViewOptions);
      expect(result5.$2, "xml");
    });
    test('Testing getResponseBodyViewOptions for application/xhtml+xml', () {
      MediaType mediaType6 = MediaType("application", "xhtml+xml");
      var result6 = getResponseBodyViewOptions(mediaType6);
      expect(result6.$1, kCodeRawBodyViewOptions);
      expect(result6.$2, "xml");
    });
    test(
        'Testing getResponseBodyViewOptions for application/xml-external-parsed-entity',
        () {
      MediaType mediaType7 =
          MediaType("application", "xml-external-parsed-entity");
      var result7 = getResponseBodyViewOptions(mediaType7);
      expect(result7.$1, kCodeRawBodyViewOptions);
      expect(result7.$2, "xml");
    });
    test('Testing getResponseBodyViewOptions for text/html', () {
      MediaType mediaType8 = MediaType("text", "html");
      var result8 = getResponseBodyViewOptions(mediaType8);
      expect(result8.$1, kCodeRawBodyViewOptions);
      expect(result8.$2, "xml");
    });
    test('Testing getResponseBodyViewOptions for application/pdf', () {
      MediaType mediaType9 = MediaType("application", "pdf");
      var result9 = getResponseBodyViewOptions(mediaType9);
      expect(result9.$1, kPreviewBodyViewOptions);
      expect(result9.$2, "pdf");
    });
    test('Testing getResponseBodyViewOptions for text/calendar', () {
      MediaType mediaType10 = MediaType("text", "calendar");
      var result10 = getResponseBodyViewOptions(mediaType10);
      expect(result10.$1, kRawBodyViewOptions);
      expect(result10.$2, "calendar");
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
