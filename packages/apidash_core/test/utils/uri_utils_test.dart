import 'package:apidash_core/models/models.dart';
import 'package:apidash_core/utils/uri_utils.dart';
import 'package:test/test.dart';

void main() {
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
    test('Testing getValidRequestUri with localhost URL without port or path',
        () {
      String url1 = "localhost";
      Uri uri1Expected = Uri(scheme: 'http', host: 'localhost');
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri with localhost URL with port', () {
      String url1 = "localhost:8080";
      Uri uri1Expected = Uri(scheme: 'http', host: 'localhost', port: 8080);
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri with localhost URL with port and path',
        () {
      String url1 = "localhost:8080/hello";
      Uri uri1Expected =
          Uri(scheme: 'http', host: 'localhost', port: 8080, path: '/hello');
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri with localhost URL with http prefix', () {
      String url1 = "http://localhost:3080";
      Uri uri1Expected = Uri(scheme: 'http', host: 'localhost', port: 3080);
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri with localhost URL with https prefix', () {
      String url1 = "https://localhost:8080";
      Uri uri1Expected = Uri(scheme: 'https', host: 'localhost', port: 8080);
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri for normal values', () {
      String url1 = "https://api.apidash.dev/country/data";
      const kvRow1 = NameValueModel(name: "code", value: "US");
      Uri uri1Expected = Uri(
          scheme: 'https',
          host: 'api.apidash.dev',
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
      String url4 = "api.apidash.dev/country/data";
      const kvRow4 = NameValueModel(name: "code", value: "US");
      Uri uri4Expected = Uri(
          scheme: 'https',
          host: 'api.apidash.dev',
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
      String url6 = "api.apidash.dev/country/data?code=IND";
      const kvRow6 = NameValueModel(name: "code", value: "US");
      Uri uri6Expected = Uri(
          scheme: 'https',
          host: 'api.apidash.dev',
          path: 'country/data',
          queryParameters: {'code': 'US'});
      expect(getValidRequestUri(url6, [kvRow6]), (uri6Expected, null));
    });
    test('Testing getValidRequestUri when kvrow is null', () {
      String url7 = "api.apidash.dev/country/data?code=US";
      Uri uri7Expected = Uri(
          scheme: 'https',
          host: 'api.apidash.dev',
          path: 'country/data',
          queryParameters: {'code': 'US'});
      expect(getValidRequestUri(url7, null), (uri7Expected, null));
    });
  });
}
