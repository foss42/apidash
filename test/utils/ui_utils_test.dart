import 'package:test/test.dart';
import 'package:apidash/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

void main() {
  Brightness dark = Brightness.dark;
  group("Testing getResponseStatusCodeColor function", () {
    int statusCode1 = 200;
    Color colStatusCode1Expected = Colors.green.shade800;
    test('Testing getResponseStatusCodeColor for statusCode1', () {
      expect(getResponseStatusCodeColor(statusCode1), colStatusCode1Expected);
    });

    Color colStatusCode1DarkModeExpected =
        Color.alphaBlend(colStatusCode1Expected.withOpacity(0.4), Colors.white);
    test('Testing getResponseStatusCodeColor for statusCode1 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode1, brightness: dark),
          colStatusCode1DarkModeExpected);
    });

    int statusCode2 = 300;
    Color colStatusCode2Expected = Colors.blue.shade800;
    test('Testing getResponseStatusCodeColor for statusCode2', () {
      expect(getResponseStatusCodeColor(statusCode2), colStatusCode2Expected);
    });

    Color colStatusCode2DarkModeExpected =
        Color.alphaBlend(colStatusCode2Expected.withOpacity(0.4), Colors.white);
    test('Testing getResponseStatusCodeColor for statusCode2 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode2, brightness: dark),
          colStatusCode2DarkModeExpected);
    });

    int statusCode3 = 404;
    Color colStatusCode3Expected = Colors.red.shade800;
    test('Testing getResponseStatusCodeColor for statusCode3', () {
      expect(getResponseStatusCodeColor(statusCode3), colStatusCode3Expected);
    });

    Color colStatusCode3DarkModeExpected =
        Color.alphaBlend(colStatusCode3Expected.withOpacity(0.4), Colors.white);
    test('Testing getResponseStatusCodeColor for statusCode3 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode3, brightness: dark),
          colStatusCode3DarkModeExpected);
    });

    int statusCode4 = 503;
    Color colStatusCode4Expected = Colors.amber.shade900;
    test('Testing getResponseStatusCodeColor for statusCode4', () {
      expect(getResponseStatusCodeColor(statusCode4), colStatusCode4Expected);
    });

    Color colStatusCode4DarkModeExpected =
        Color.alphaBlend(colStatusCode4Expected.withOpacity(0.4), Colors.white);
    test('Testing getResponseStatusCodeColor for statusCode4 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode4, brightness: dark),
          colStatusCode4DarkModeExpected);
    });

    int statusCode5 = 101;
    Color colStatusCode5Expected = Colors.grey.shade700;
    test('Testing getResponseStatusCodeColor for statusCode5', () {
      expect(getResponseStatusCodeColor(statusCode5), colStatusCode5Expected);
    });

    Color colStatusCode5DarkModeExpected =
        Color.alphaBlend(colStatusCode5Expected.withOpacity(0.4), Colors.white);
    test('Testing getResponseStatusCodeColor for statusCode5 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode5, brightness: dark),
          colStatusCode5DarkModeExpected);
    });
  });

  group("Testing getHTTPMethodColor function", () {
    HTTPVerb method1 = HTTPVerb.get;
    Color colMethod1Expected = Colors.green.shade800;
    test('Test getHTTPMethodColor for Method1', () {
      expect(getHTTPMethodColor(method1), colMethod1Expected);
    });

    Color colMethod1DarkModeExpected =
        Color.alphaBlend(colMethod1Expected.withOpacity(0.4), Colors.white);
    test('Test getHTTPMethodColor for Method1 dark mode', () {
      expect(getHTTPMethodColor(method1, brightness: dark),
          colMethod1DarkModeExpected);
    });

    HTTPVerb method2 = HTTPVerb.head;
    Color colMethod2Expected = Colors.green.shade800;
    test('Test getHTTPMethodColor for Method2', () {
      expect(getHTTPMethodColor(method2), colMethod2Expected);
    });

    Color colMethod2DarkModeExpected =
        Color.alphaBlend(colMethod2Expected.withOpacity(0.4), Colors.white);
    test('Test getHTTPMethodColor for Method2 dark mode', () {
      expect(getHTTPMethodColor(method2, brightness: dark),
          colMethod2DarkModeExpected);
    });

    HTTPVerb method3 = HTTPVerb.patch;
    Color colMethod3Expected = Colors.amber.shade900;
    test('Test getHTTPMethodColor for Method3', () {
      expect(getHTTPMethodColor(method3), colMethod3Expected);
    });

    Color colMethod3DarkModeExpected =
        Color.alphaBlend(colMethod3Expected.withOpacity(0.4), Colors.white);
    test('Test getHTTPMethodColor for Method3 dark mode', () {
      expect(getHTTPMethodColor(method3, brightness: dark),
          colMethod3DarkModeExpected);
    });

    HTTPVerb method4 = HTTPVerb.put;
    Color colMethod4Expected = Colors.amber.shade900;
    test('Test getHTTPMethodColor for Method4', () {
      expect(getHTTPMethodColor(method4), colMethod4Expected);
    });

    Color colMethod4DarkModeExpected =
        Color.alphaBlend(colMethod4Expected.withOpacity(0.4), Colors.white);
    test('Test getHTTPMethodColor for Method4 dark mode', () {
      expect(getHTTPMethodColor(method4, brightness: dark),
          colMethod4DarkModeExpected);
    });

    HTTPVerb method5 = HTTPVerb.post;
    Color colMethod5Expected = Colors.blue.shade800;
    test('Test getHTTPMethodColor for Method5', () {
      expect(getHTTPMethodColor(method5), colMethod5Expected);
    });

    Color colMethod5DarkModeExpected =
        Color.alphaBlend(colMethod5Expected.withOpacity(0.4), Colors.white);
    test('Test getHTTPMethodColor for Method5 dark mode', () {
      expect(getHTTPMethodColor(method5, brightness: dark),
          colMethod5DarkModeExpected);
    });

    HTTPVerb method6 = HTTPVerb.delete;
    Color colMethod6Expected = Colors.red.shade800;
    test('Test getHTTPMethodColor for Method6', () {
      expect(getHTTPMethodColor(method6), colMethod6Expected);
    });

    Color colMethod6DarkModeExpected =
        Color.alphaBlend(colMethod6Expected.withOpacity(0.4), Colors.white);
    test('Test getHTTPMethodColor for Method6 dark mode', () {
      expect(getHTTPMethodColor(method6, brightness: dark),
          colMethod6DarkModeExpected);
    });
  });
}
