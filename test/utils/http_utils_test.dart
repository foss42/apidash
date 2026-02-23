import 'package:apidash_core/apidash_core.dart' show MediaType;
import 'package:test/test.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart' show MediaType, HTTPVerb;

void main() {
  group("Testing getRequestTitleFromUrl function", () {
    test('Testing getRequestTitleFromUrl using url1', () {
      String url1 = "";
      expect(getRequestTitleFromUrl(url1), kUntitled);
    });

    test('Testing getRequestTitleFromUrl using url2', () {
      String url2 = " ";
      expect(getRequestTitleFromUrl(url2), kUntitled);
    });

    test('Testing getRequestTitleFromUrl using url3', () {
      String url3 = "https://api.apidash.dev/country/codes";
      String title3Expected = "api.apidash.dev/country/codes";
      expect(getRequestTitleFromUrl(url3), title3Expected);
    });

    test('Testing getRequestTitleFromUrl using url4', () {
      String url4 = "api.apidash.dev/country/data";
      String title4Expected = "api.apidash.dev/country/data";
      expect(getRequestTitleFromUrl(url4), title4Expected);
    });

    test('Testing getRequestTitleFromUrl using url5', () {
      String url5 = "http://";
      expect(getRequestTitleFromUrl(url5), kUntitled);
    });

    test('Testing getRequestTitleFromUrl for null value', () {
      expect(getRequestTitleFromUrl(null), kUntitled);
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

      group("Testing deriveRequestName function", () {
    test('Full URL with path returns METHOD /path', () {
      expect(
        deriveRequestName(HTTPVerb.get, "https://api.example.com/v1/users/123"),
        "GET /v1/users/123",
      );
    });

    test('URL with query params strips them', () {
      expect(
        deriveRequestName(HTTPVerb.get, "https://api.example.com/users?page=1&limit=20"),
        "GET /users",
      );
    });

    test('POST request shows correct method', () {
      expect(
        deriveRequestName(HTTPVerb.post, "https://api.example.com/login"),
        "POST /login",
      );
    });

    test('DELETE request shows correct method', () {
      expect(
        deriveRequestName(HTTPVerb.delete, "https://api.example.com/posts/1"),
        "DELETE /posts/1",
      );
    });

    test('PUT request shows correct method', () {
      expect(
        deriveRequestName(HTTPVerb.put, "https://api.example.com/posts/1"),
        "PUT /posts/1",
      );
    });

    test('PATCH request shows correct method', () {
      expect(
        deriveRequestName(HTTPVerb.patch, "https://api.example.com/posts/1"),
        "PATCH /posts/1",
      );
    });

    test('URL without scheme is handled', () {
      expect(
        deriveRequestName(HTTPVerb.get, "api.example.com/users"),
        "GET /users",
      );
    });

    test('URL with only host (no path) returns METHOD /', () {
      expect(
        deriveRequestName(HTTPVerb.get, "https://api.example.com"),
        "GET /",
      );
    });

    test('Empty URL returns just the method', () {
      expect(
        deriveRequestName(HTTPVerb.get, ""),
        "GET",
      );
    });

    test('Null URL returns just the method', () {
      expect(
        deriveRequestName(HTTPVerb.get, null),
        "GET",
      );
    });

    test('URL with trailing slash', () {
      expect(
        deriveRequestName(HTTPVerb.get, "https://api.example.com/"),
        "GET /",
      );
    });

    test('Deeply nested path', () {
      expect(
        deriveRequestName(HTTPVerb.get, "https://api.example.com/v2/org/teams/members/123"),
        "GET /v2/org/teams/members/123",
      );
    });
  });
  });
}
