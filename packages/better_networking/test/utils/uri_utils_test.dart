import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

void main() {
  group("Testing getUriScheme", () {
    test('Testing getUriScheme for https', () {
      Uri uri1 = Uri(
        scheme: 'https',
        host: 'dart.dev',
        path: 'guides/libraries/library-tour',
        fragment: 'numbers',
      );
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
    test(
      'Testing getValidRequestUri with localhost URL without port or path',
      () {
        String url1 = "localhost";
        Uri uri1Expected = Uri(scheme: 'http', host: 'localhost');
        expect(getValidRequestUri(url1, []), (uri1Expected, null));
      },
    );

    test('Testing getValidRequestUri with localhost URL with port', () {
      String url1 = "localhost:8080";
      Uri uri1Expected = Uri(scheme: 'http', host: 'localhost', port: 8080);
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test(
      'Testing getValidRequestUri with localhost URL with port and path',
      () {
        String url1 = "localhost:8080/hello";
        Uri uri1Expected = Uri(
          scheme: 'http',
          host: 'localhost',
          port: 8080,
          path: '/hello',
        );
        expect(getValidRequestUri(url1, []), (uri1Expected, null));
      },
    );

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

    test('Testing getValidRequestUri with IP URL without port or path', () {
      String url1 = "8.8.8.8";
      Uri uri1Expected = Uri(scheme: 'http', host: '8.8.8.8');
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri with IP URL with port', () {
      String url1 = "8.8.8.8:8080";
      Uri uri1Expected = Uri(scheme: 'http', host: '8.8.8.8', port: 8080);
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri with IP URL with port and path', () {
      String url1 = "8.8.8.8:8080/hello";
      Uri uri1Expected = Uri(
        scheme: 'http',
        host: '8.8.8.8',
        port: 8080,
        path: '/hello',
      );
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri with IP URL with http prefix', () {
      String url1 = "http://8.8.8.8:3080";
      Uri uri1Expected = Uri(scheme: 'http', host: '8.8.8.8', port: 3080);
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri with IP URL with https prefix', () {
      String url1 = "https://8.8.8.8:8080";
      Uri uri1Expected = Uri(scheme: 'https', host: '8.8.8.8', port: 8080);
      expect(getValidRequestUri(url1, []), (uri1Expected, null));
    });

    test('Testing getValidRequestUri for normal values', () {
      String url1 = "https://api.apidash.dev/country/data";
      const kvRow1 = NameValueModel(name: "code", value: "US");
      Uri uri1Expected = Uri(
        scheme: 'https',
        host: 'api.apidash.dev',
        path: 'country/data',
        queryParameters: {'code': 'US'},
      );
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
        queryParameters: {'code': 'US'},
      );
      expect(getValidRequestUri(url4, [kvRow4]), (uri4Expected, null));
    });
    test('Testing getValidRequestUri when url has fragment', () {
      String url5 = "https://dart.dev/guides/libraries/library-tour#numbers";
      Uri uri5Expected = Uri(
        scheme: 'https',
        host: 'dart.dev',
        path: '/guides/libraries/library-tour',
      );
      expect(getValidRequestUri(url5, null), (uri5Expected, null));
    });
    test('Testing getValidRequestUri when uri scheme is not supported', () {
      String url5 = "mailto:someone@example.com";
      expect(getValidRequestUri(url5, null), (
        null,
        "Unsupported URL Scheme (mailto)",
      ));
    });
    test(
      'Testing getValidRequestUri when query params in both url and kvrow',
      () {
        String url6 = "api.apidash.dev/country/data?code=IND";
        const kvRow6 = NameValueModel(name: "code", value: "US");
        Uri uri6Expected = Uri(
          scheme: 'https',
          host: 'api.apidash.dev',
          path: 'country/data',
          queryParameters: {'code': 'US'},
        );
        expect(getValidRequestUri(url6, [kvRow6]), (uri6Expected, null));
      },
    );
    test('Testing getValidRequestUri when kvrow is null', () {
      String url7 = "api.apidash.dev/country/data?code=US";
      Uri uri7Expected = Uri(
        scheme: 'https',
        host: 'api.apidash.dev',
        path: 'country/data',
        queryParameters: {'code': 'US'},
      );
      expect(getValidRequestUri(url7, null), (uri7Expected, null));
    });
  });

  group("Testing stripUriParams", () {
    test('Removes query parameters from Uri with query', () {
      final uri = Uri.parse(
        "https://example.com/path/to/resource?param1=value1&param2=value2",
      );
      expect(stripUriParams(uri), "https://example.com/path/to/resource");
    });

    test('Removes fragment and query from Uri', () {
      final uri = Uri.parse("https://example.com/api#section?foo=bar");
      expect(stripUriParams(uri), "https://example.com/api");
    });

    test('stripUrlParams removes query from URL string', () {
      const url = "https://example.com/page?x=1&y=2";
      expect(stripUrlParams(url), "https://example.com/page");
    });

    test('stripUrlParams handles URL with no query', () {
      const url = "https://example.com/page";
      expect(stripUrlParams(url), "https://example.com/page");
    });

    test('stripUrlParams with only ? and no query', () {
      const url = "https://example.com/page?";
      expect(stripUrlParams(url), "https://example.com/page");
    });
  });

  group("Testing webSocketSchemeFor", () {
    test('https maps to wss', () {
      expect(
        webSocketSchemeFor(SupportedUriSchemes.https),
        SupportedWebSocketUriSchemes.wss,
      );
    });

    test('http maps to ws', () {
      expect(
        webSocketSchemeFor(SupportedUriSchemes.http),
        SupportedWebSocketUriSchemes.ws,
      );
    });
  });

  group("Testing applyWebSocketUriScheme", () {
    test('applies the default scheme when omitted', () {
      expect(
        applyWebSocketUriScheme("echo.websocket.org"),
        "wss://echo.websocket.org",
      );
    });

    test('honours an explicit default scheme', () {
      expect(
        applyWebSocketUriScheme(
          "echo.websocket.org",
          defaultUriScheme: SupportedWebSocketUriSchemes.ws,
        ),
        "ws://echo.websocket.org",
      );
    });

    test('leaves an existing ws scheme untouched', () {
      expect(
        applyWebSocketUriScheme("ws://echo.websocket.org"),
        "ws://echo.websocket.org",
      );
    });

    test('leaves an existing wss scheme untouched', () {
      expect(
        applyWebSocketUriScheme("wss://echo.websocket.org"),
        "wss://echo.websocket.org",
      );
    });

    test('leaves an unsupported scheme untouched for connect to report', () {
      expect(
        applyWebSocketUriScheme("http://echo.websocket.org"),
        "http://echo.websocket.org",
      );
    });

    test('defaults localhost to ws, not wss', () {
      expect(applyWebSocketUriScheme("localhost"), "ws://localhost");
    });

    test('defaults localhost with a port to ws', () {
      // Uri.parse("localhost:8765") reports the scheme "localhost", so this
      // case cannot be detected after parsing.
      expect(applyWebSocketUriScheme("localhost:8765"), "ws://localhost:8765");
    });

    test('defaults localhost with a port and path to ws', () {
      expect(
        applyWebSocketUriScheme("localhost:8765/socket"),
        "ws://localhost:8765/socket",
      );
    });

    test('defaults a bare IP host to ws', () {
      // Uri.parse("127.0.0.1:8765") throws, so this case cannot be detected
      // after parsing either.
      expect(applyWebSocketUriScheme("127.0.0.1:8765"), "ws://127.0.0.1:8765");
    });

    test('trims surrounding whitespace', () {
      expect(
        applyWebSocketUriScheme("  echo.websocket.org  "),
        "wss://echo.websocket.org",
      );
    });

    test('preserves path and query when defaulting', () {
      expect(
        applyWebSocketUriScheme("example.com/socket?topic=a&topic=b"),
        "wss://example.com/socket?topic=a&topic=b",
      );
    });

    test('returns null for a null URL', () {
      expect(applyWebSocketUriScheme(null), null);
    });

    test('returns null for a blank URL', () {
      expect(applyWebSocketUriScheme("   "), null);
    });
  });
}
