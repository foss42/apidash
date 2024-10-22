import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:test/test.dart';
import 'package:apidash/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

void main() {
  Brightness dark = Brightness.dark;
  group("Testing getResponseStatusCodeColor function", () {
    int statusCode1 = 200;
    test('Testing getResponseStatusCodeColor for statusCode 200', () {
      expect(getResponseStatusCodeColor(statusCode1), kColorStatusCode200);
    });

    Color colStatusCode1DarkModeExpected =
        getDarkModeColor(kColorStatusCode200);
    test('Testing getResponseStatusCodeColor for statusCode 200 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode1, brightness: dark),
          colStatusCode1DarkModeExpected);
    });

    int statusCode2 = 300;
    test('Testing getResponseStatusCodeColor for statusCode 300', () {
      expect(getResponseStatusCodeColor(statusCode2), kColorStatusCode300);
    });

    Color colStatusCode2DarkModeExpected =
        getDarkModeColor(kColorStatusCode300);
    test('Testing getResponseStatusCodeColor for statusCode 300 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode2, brightness: dark),
          colStatusCode2DarkModeExpected);
    });

    int statusCode3 = 404;
    test('Testing getResponseStatusCodeColor for statusCode 404', () {
      expect(getResponseStatusCodeColor(statusCode3), kColorStatusCode400);
    });

    Color colStatusCode3DarkModeExpected =
        getDarkModeColor(kColorStatusCode400);
    test('Testing getResponseStatusCodeColor for statusCode 404 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode3, brightness: dark),
          colStatusCode3DarkModeExpected);
    });

    int statusCode4 = 503;

    test('Testing getResponseStatusCodeColor for statusCode 503', () {
      expect(getResponseStatusCodeColor(statusCode4), kColorStatusCode500);
    });

    Color colStatusCode4DarkModeExpected =
        getDarkModeColor(kColorStatusCode500);
    test('Testing getResponseStatusCodeColor for statusCode 503 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode4, brightness: dark),
          colStatusCode4DarkModeExpected);
    });

    int statusCode5 = 101;

    test('Testing getResponseStatusCodeColor for statusCode 101', () {
      expect(getResponseStatusCodeColor(statusCode5), kColorStatusCodeDefault);
    });

    Color colStatusCode5DarkModeExpected =
        getDarkModeColor(kColorStatusCodeDefault);
    test('Testing getResponseStatusCodeColor for statusCode 101 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode5, brightness: dark),
          colStatusCode5DarkModeExpected);
    });
  });

  group("Testing getHTTPMethodColor function", () {
    HTTPVerb methodGet = HTTPVerb.get;
    test('Test getHTTPMethodColor for GET method', () {
      expect(getHTTPMethodColor(methodGet), kColorHttpMethodGet);
    });

    Color colMethodGetDarkModeExpected = getDarkModeColor(kColorHttpMethodGet);
    test('Test getHTTPMethodColor for GET method dark mode', () {
      expect(getHTTPMethodColor(methodGet, brightness: dark),
          colMethodGetDarkModeExpected);
    });

    HTTPVerb methodHead = HTTPVerb.head;
    test('Test getHTTPMethodColor for HEAD Method', () {
      expect(getHTTPMethodColor(methodHead), kColorHttpMethodHead);
    });

    Color colMethodHeadDarkModeExpected =
        getDarkModeColor(kColorHttpMethodHead);
    test('Test getHTTPMethodColor for HEAD Method dark mode', () {
      expect(getHTTPMethodColor(methodHead, brightness: dark),
          colMethodHeadDarkModeExpected);
    });

    HTTPVerb methodPatch = HTTPVerb.patch;
    test('Test getHTTPMethodColor for PATCH Method', () {
      expect(getHTTPMethodColor(methodPatch), kColorHttpMethodPatch);
    });

    Color colMethodPatchDarkModeExpected =
        getDarkModeColor(kColorHttpMethodPatch);
    test('Test getHTTPMethodColor for PATCH Method dark mode', () {
      expect(getHTTPMethodColor(methodPatch, brightness: dark),
          colMethodPatchDarkModeExpected);
    });

    HTTPVerb methodPut = HTTPVerb.put;
    test('Test getHTTPMethodColor for PUT Method', () {
      expect(getHTTPMethodColor(methodPut), kColorHttpMethodPut);
    });

    Color colMethodPutDarkModeExpected = getDarkModeColor(kColorHttpMethodPut);
    test('Test getHTTPMethodColor for PUT Method dark mode', () {
      expect(getHTTPMethodColor(methodPut, brightness: dark),
          colMethodPutDarkModeExpected);
    });

    HTTPVerb methodPost = HTTPVerb.post;

    test('Test getHTTPMethodColor for POST Method', () {
      expect(getHTTPMethodColor(methodPost), kColorHttpMethodPost);
    });

    Color colMethodPostDarkModeExpected =
        getDarkModeColor(kColorHttpMethodPost);
    test('Test getHTTPMethodColor for POST Method dark mode', () {
      expect(getHTTPMethodColor(methodPost, brightness: dark),
          colMethodPostDarkModeExpected);
    });

    HTTPVerb methodDelete = HTTPVerb.delete;
    test('Test getHTTPMethodColor for DELETE Method', () {
      expect(getHTTPMethodColor(methodDelete), kColorHttpMethodDelete);
    });

    Color colMethodDeleteDarkModeExpected =
        getDarkModeColor(kColorHttpMethodDelete);
    test('Test getHTTPMethodColor for DELETE Method dark mode', () {
      expect(getHTTPMethodColor(methodDelete, brightness: dark),
          colMethodDeleteDarkModeExpected);
    });
  });

  group('Testing getScaffoldKey function', () {
    test('Returns kEnvScaffoldKey for railIdx 1', () {
      expect(getScaffoldKey(1), kEnvScaffoldKey);
    });

    test('Returns kHisScaffoldKey for railIdx 2', () {
      expect(getScaffoldKey(2), kHisScaffoldKey);
    });

    test('Returns kHomeScaffoldKey for railIdx other than 1 or 2', () {
      expect(getScaffoldKey(0), kHomeScaffoldKey);
      expect(getScaffoldKey(3), kHomeScaffoldKey);
    });
  });
}
