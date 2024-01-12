import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import 'package:apidash/utils/convert_utils.dart';
import 'package:apidash/models/name_value_model.dart';
import 'package:apidash/models/form_data_model.dart';

void main() {
  group("Testing humanizeDuration function", () {
    test('Testing using dur1', () {
      Duration dur1 = const Duration(minutes: 1, seconds: 3);
      String dur1Expected = "1.05 m";
      expect(humanizeDuration(dur1), dur1Expected);
    });

    test('Testing using dur2', () {
      Duration dur2 = const Duration(seconds: 3, milliseconds: 20);
      String dur2Expected = "3.02 s";
      expect(humanizeDuration(dur2), dur2Expected);
    });

    test('Testing using dur3', () {
      Duration dur3 = const Duration(milliseconds: 345);
      String dur3Expected = "345 ms";
      expect(humanizeDuration(dur3), dur3Expected);
    });

    test('Testing using dur4', () {
      Duration dur4 = const Duration(seconds: 1, milliseconds: 200);
      String dur4Expected = "1.20 s";
      expect(humanizeDuration(dur4), dur4Expected);
    });
  });

  group("Testing capitalizeFirstLetter function", () {
    test('Testing using text1', () {
      String text1 = "";
      String text1Expected = "";
      expect(capitalizeFirstLetter(text1), text1Expected);
    });

    test('Testing using text2', () {
      String text2 = "a";
      String text2Expected = "A";
      expect(capitalizeFirstLetter(text2), text2Expected);
    });

    test('Testing using text3', () {
      String text3 = "world";
      String text3Expected = "World";
      expect(capitalizeFirstLetter(text3), text3Expected);
    });

    test('Testing using text4', () {
      String text4 = "worldly affairs";
      String text4Expected = "Worldly affairs";
      expect(capitalizeFirstLetter(text4), text4Expected);
    });
  });

  group("Testing formatHeaderCase function", () {
    test('Testing using headerText1', () {
      String headerText1 = "content-type";
      String headerText1Expected = "Content-Type";
      expect(formatHeaderCase(headerText1), headerText1Expected);
    });

    test('Testing using headerText2', () {
      String headerText2 = "x-cloud-trace-context";
      String headerText2Expected = "X-Cloud-Trace-Context";
      expect(formatHeaderCase(headerText2), headerText2Expected);
    });
  });
  group("Testing rowsToMap", () {
    test('Testing for null', () {
      expect(rowsToMap(null), null);
    });
    test('Testing for string KVRow values', () {
      const kvRow1 = NameValueModel(name: "code", value: "IN");
      expect(rowsToMap([kvRow1]), {"code": "IN"});
    });
    test('Testing when header is True', () {
      const kvRow2 = NameValueModel(name: "Text", value: "ABC");
      expect(rowsToMap([kvRow2], isHeader: true), {"text": "ABC"});
    });
    test('Testing when header is false and key is in upper case', () {
      const kvRow3 = <NameValueModel>[
        NameValueModel(name: "TEXT", value: "ABC"),
        NameValueModel(name: "version", value: 0.1),
        NameValueModel(name: "month", value: 4),
      ];
      expect(
          rowsToMap(kvRow3), {"TEXT": "ABC", "version": "0.1", "month": "4"});
    });
  });

  group("Testing mapToRows", () {
    test('Testing for null', () {
      expect(mapToRows(null), null);
    });
    test('Testing with a map value', () {
      Map<String, String> value1 = {"text": "abc", "lang": "eng", "code": "1"};
      const result1Expected = <NameValueModel>[
        NameValueModel(name: "text", value: "abc"),
        NameValueModel(name: "lang", value: "eng"),
        NameValueModel(name: "code", value: "1")
      ];
      expect(mapToRows(value1), result1Expected);
    });
  });

  group("Testing rowsToFormDataMapList", () {
    test('Testing for null', () {
      expect(rowsToFormDataMapList(null), null);
    });
    test('Testing with a map value', () {
      const input = <FormDataModel>[
        FormDataModel(name: "text", value: "abc", type: FormDataType.file),
        FormDataModel(name: "lang", value: "eng", type: FormDataType.file),
        FormDataModel(name: "code", value: "1", type: FormDataType.text)
      ];
      const expectedResult = [
        {"name": "text", "value": "abc", "type": "file"},
        {"name": "lang", "value": "eng", "type": "file"},
        {"name": "code", "value": "1", "type": "text"}
      ];
      expect(rowsToFormDataMapList(input), expectedResult);
    });
  });

  group("Testing mapListToFormDataModelRows", () {
    test('Testing for null', () {
      expect(mapListToFormDataModelRows(null), null);
    });
    test('Testing with a map value', () {
      const input = [
        {"name": "text", "value": "abc", "type": "file"},
        {"name": "lang", "value": "eng", "type": "file"},
        {"name": "code", "value": "1", "type": "text"}
      ];
      const expectedResult = <FormDataModel>[
        FormDataModel(name: "text", value: "abc", type: FormDataType.file),
        FormDataModel(name: "lang", value: "eng", type: FormDataType.file),
        FormDataModel(name: "code", value: "1", type: FormDataType.text)
      ];
      expect(mapListToFormDataModelRows(input), expectedResult);
    });
  });

  group("Testing getFormDataType", () {
    test('Testing for null', () {
      expect(getFormDataType(null), FormDataType.text);
    });
    test('Testing with a map value', () {
      const input = "file";
      const expectedResult = FormDataType.file;
      expect(getFormDataType(input), expectedResult);
    });
  });

  group("Testing jsonMapToBytes", () {
    test('Testing for null', () {
      expect(jsonMapToBytes(null), []);
    });
    test('Testing with a map value', () {
      Map<String, String> value1 = {"a": "1"};
      const result1Expected = [
        123,
        10,
        32,
        32,
        34,
        97,
        34,
        58,
        32,
        34,
        49,
        34,
        10,
        125
      ];
      expect(jsonMapToBytes(value1), result1Expected);
    });
  });

  group("Testing stringToBytes", () {
    test('Testing for null', () {
      expect(stringToBytes(null), null);
    });
    test('Testing with a stringToBytes value', () {
      String value1 = "ab";
      const result1Expected = [97, 98];
      expect(stringToBytes(value1), result1Expected);
    });
  });

  group("Testing padMultilineString", () {
    String text1 =
        '''Using API Dash, you can draft API requests via an easy to use GUI which allows you to:
Create different types of HTTP requests (GET, HEAD, POST, PATCH, PUT and DELETE)
Easily manipulate and play around with request inputs like headers, query parameters and body.''';
    test('Testing when firstLinePadded is true ', () {
      String text1FirstLinePaddedExpected =
          '''          Using API Dash, you can draft API requests via an easy to use GUI which allows you to:
          Create different types of HTTP requests (GET, HEAD, POST, PATCH, PUT and DELETE)
          Easily manipulate and play around with request inputs like headers, query parameters and body.''';
      expect(padMultilineString(text1, 10, firstLinePadded: true),
          text1FirstLinePaddedExpected);
    });
    test('Testing when firstLinePadded is false ', () {
      String text1FirstLineNotPaddedExpected =
          '''Using API Dash, you can draft API requests via an easy to use GUI which allows you to:
          Create different types of HTTP requests (GET, HEAD, POST, PATCH, PUT and DELETE)
          Easily manipulate and play around with request inputs like headers, query parameters and body.''';
      expect(padMultilineString(text1, 10), text1FirstLineNotPaddedExpected);
    });
  });

  group("Test getEnabledRows", () {
    test('Testing for null', () {
      expect(getEnabledRows(null, null), null);
    });
    test('Testing for empty list', () {
      expect(getEnabledRows([], []), []);
    });
    const kvRow1 = NameValueModel(name: "code", value: "IN");
    const kvRow2 = NameValueModel(name: "lang", value: "eng");
    const kvRow3 = NameValueModel(name: "version", value: 0.1);
    const kvRow4 = NameValueModel(name: "month", value: 4);
    test('Testing with isRowEnabledList null', () {
      expect(getEnabledRows([kvRow1, kvRow2, kvRow3, kvRow4], null),
          [kvRow1, kvRow2, kvRow3, kvRow4]);
    });
    test('Testing for list with all enabled', () {
      expect(
          getEnabledRows(
              [kvRow1, kvRow2, kvRow3, kvRow4], [true, true, true, true]),
          [kvRow1, kvRow2, kvRow3, kvRow4]);
    });
    test('Testing for list with all disabled', () {
      expect(
          getEnabledRows(
              [kvRow1, kvRow2, kvRow3, kvRow4], [false, false, false, false]),
          []);
    });
    test('Testing for list with some disabled', () {
      expect(
          getEnabledRows(
              [kvRow1, kvRow2, kvRow3, kvRow4], [true, false, true, false]),
          [kvRow1, kvRow3]);
    });
  });
}
