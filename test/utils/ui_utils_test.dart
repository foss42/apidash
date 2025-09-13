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

    Color colStatusCode1DarkModeExpected = kColorStatusCode200.toDark;
    test('Testing getResponseStatusCodeColor for statusCode 200 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode1, brightness: dark),
          colStatusCode1DarkModeExpected);
    });

    int statusCode2 = 300;
    test('Testing getResponseStatusCodeColor for statusCode 300', () {
      expect(getResponseStatusCodeColor(statusCode2), kColorStatusCode300);
    });

    Color colStatusCode2DarkModeExpected = kColorStatusCode300.toDark;
    test('Testing getResponseStatusCodeColor for statusCode 300 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode2, brightness: dark),
          colStatusCode2DarkModeExpected);
    });

    int statusCode3 = 404;
    test('Testing getResponseStatusCodeColor for statusCode 404', () {
      expect(getResponseStatusCodeColor(statusCode3), kColorStatusCode400);
    });

    Color colStatusCode3DarkModeExpected = kColorStatusCode400.toDark;
    test('Testing getResponseStatusCodeColor for statusCode 404 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode3, brightness: dark),
          colStatusCode3DarkModeExpected);
    });

    int statusCode4 = 503;

    test('Testing getResponseStatusCodeColor for statusCode 503', () {
      expect(getResponseStatusCodeColor(statusCode4), kColorStatusCode500);
    });

    Color colStatusCode4DarkModeExpected = kColorStatusCode500.toDark;
    test('Testing getResponseStatusCodeColor for statusCode 503 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode4, brightness: dark),
          colStatusCode4DarkModeExpected);
    });

    int statusCode5 = 101;

    test('Testing getResponseStatusCodeColor for statusCode 101', () {
      expect(getResponseStatusCodeColor(statusCode5), kColorStatusCodeDefault);
    });

    Color colStatusCode5DarkModeExpected = kColorStatusCodeDefault.toDark;
    test('Testing getResponseStatusCodeColor for statusCode 101 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode5, brightness: dark),
          colStatusCode5DarkModeExpected);
    });
  });

  group("Testing getAPIColor function", () {
    HTTPVerb methodGet = HTTPVerb.get;
    Color colMethodGetDarkModeExpected = kColorHttpMethodGet.toDark;
    test('Test getAPIColor for GET method dark mode', () {
      expect(
          getAPIColor(
            APIType.rest,
            method: methodGet,
            brightness: dark,
          ),
          colMethodGetDarkModeExpected);
    });

    HTTPVerb methodHead = HTTPVerb.head;
    Color colMethodHeadDarkModeExpected = kColorHttpMethodHead.toDark;
    test('Test getHTTPMethodColor for HEAD Method dark mode', () {
      expect(
          getAPIColor(
            APIType.rest,
            method: methodHead,
            brightness: dark,
          ),
          colMethodHeadDarkModeExpected);
    });

    HTTPVerb methodPatch = HTTPVerb.patch;
    Color colMethodPatchDarkModeExpected = kColorHttpMethodPatch.toDark;
    test('Test getHTTPMethodColor for PATCH Method dark mode', () {
      expect(
          getAPIColor(
            APIType.rest,
            method: methodPatch,
            brightness: dark,
          ),
          colMethodPatchDarkModeExpected);
    });

    HTTPVerb methodPut = HTTPVerb.put;
    Color colMethodPutDarkModeExpected = kColorHttpMethodPut.toDark;
    test('Test getHTTPMethodColor for PUT Method dark mode', () {
      expect(
          getAPIColor(
            APIType.rest,
            method: methodPut,
            brightness: dark,
          ),
          colMethodPutDarkModeExpected);
    });

    HTTPVerb methodPost = HTTPVerb.post;
    Color colMethodPostDarkModeExpected = kColorHttpMethodPost.toDark;
    test('Test getHTTPMethodColor for POST Method dark mode', () {
      expect(
          getAPIColor(
            APIType.rest,
            method: methodPost,
            brightness: dark,
          ),
          colMethodPostDarkModeExpected);
    });

    HTTPVerb methodDelete = HTTPVerb.delete;
    Color colMethodDeleteDarkModeExpected = kColorHttpMethodDelete.toDark;
    test('Test getHTTPMethodColor for DELETE Method dark mode', () {
      expect(
          getAPIColor(
            APIType.rest,
            method: methodDelete,
            brightness: dark,
          ),
          colMethodDeleteDarkModeExpected);
    });
  });

  group("Testing getHTTPMethodColor function", () {
    HTTPVerb methodGet = HTTPVerb.get;
    test('Test getHTTPMethodColor for GET method', () {
      expect(getHTTPMethodColor(methodGet), kColorHttpMethodGet);
    });

    HTTPVerb methodHead = HTTPVerb.head;
    test('Test getHTTPMethodColor for HEAD Method', () {
      expect(getHTTPMethodColor(methodHead), kColorHttpMethodHead);
    });

    HTTPVerb methodPatch = HTTPVerb.patch;
    test('Test getHTTPMethodColor for PATCH Method', () {
      expect(getHTTPMethodColor(methodPatch), kColorHttpMethodPatch);
    });

    HTTPVerb methodPut = HTTPVerb.put;
    test('Test getHTTPMethodColor for PUT Method', () {
      expect(getHTTPMethodColor(methodPut), kColorHttpMethodPut);
    });

    HTTPVerb methodPost = HTTPVerb.post;

    test('Test getHTTPMethodColor for POST Method', () {
      expect(getHTTPMethodColor(methodPost), kColorHttpMethodPost);
    });

    HTTPVerb methodDelete = HTTPVerb.delete;
    test('Test getHTTPMethodColor for DELETE Method', () {
      expect(getHTTPMethodColor(methodDelete), kColorHttpMethodDelete);
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
