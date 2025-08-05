import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

void main() {
  group('Testing RemoveJsonComments', () {
    test('Removes single-line comments', () {
      String input = '''
      {
        // This is a single-line comment
        "key": "value"
      }
      ''';

      String expected = '''{
  "key": "value"
}''';
      expect(removeJsonComments(input), expected);
    });

    test('Removes multi-line comments', () {
      String input = '''
      {
        /*
          This is a multi-line comment
        */
        "key": "value"
      }
      ''';

      String expected = '''{
  "key": "value"
}''';
      expect(removeJsonComments(input), expected);
    });

    test('Handles valid JSON without comments', () {
      String input = '{"key":"value"}';
      String expected = '''{
  "key": "value"
}''';
      expect(removeJsonComments(input), expected);
    });

    test('Returns original string if invalid JSON', () {
      String input = '{key: value}';
      String expected = '{key: value}';
      expect(removeJsonComments(input), expected);
    });

    test('Removes trailing commas', () {
      String input = '''
      {
        "key1": "value1",
        "key2": "value2", // trailing comma
      }
      ''';

      String expected = '''{
  "key1": "value1",
  "key2": "value2"
}''';
      expect(removeJsonComments(input), expected);
    });

    test('Test blank json', () {
      String input = '''
      {}
      ''';

      String expected = '{}';
      expect(removeJsonComments(input), expected);
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
      expect(rowsToMap(kvRow3), {
        "TEXT": "ABC",
        "version": "0.1",
        "month": "4",
      });
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
        NameValueModel(name: "code", value: "1"),
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
        FormDataModel(name: "code", value: "1", type: FormDataType.text),
      ];
      const expectedResult = [
        {"name": "text", "value": "abc", "type": "file"},
        {"name": "lang", "value": "eng", "type": "file"},
        {"name": "code", "value": "1", "type": "text"},
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
        {"name": "code", "value": "1", "type": "text"},
      ];
      const expectedResult = <FormDataModel>[
        FormDataModel(name: "text", value: "abc", type: FormDataType.file),
        FormDataModel(name: "lang", value: "eng", type: FormDataType.file),
        FormDataModel(name: "code", value: "1", type: FormDataType.text),
      ];
      expect(mapListToFormDataModelRows(input), expectedResult);
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
      expect(getEnabledRows([kvRow1, kvRow2, kvRow3, kvRow4], null), [
        kvRow1,
        kvRow2,
        kvRow3,
        kvRow4,
      ]);
    });
    test('Testing for list with all enabled', () {
      expect(
        getEnabledRows(
          [kvRow1, kvRow2, kvRow3, kvRow4],
          [true, true, true, true],
        ),
        [kvRow1, kvRow2, kvRow3, kvRow4],
      );
    });
    test('Testing for list with all disabled', () {
      expect(
        getEnabledRows(
          [kvRow1, kvRow2, kvRow3, kvRow4],
          [false, false, false, false],
        ),
        [],
      );
    });
    test('Testing for list with some disabled', () {
      expect(
        getEnabledRows(
          [kvRow1, kvRow2, kvRow3, kvRow4],
          [true, false, true, false],
        ),
        [kvRow1, kvRow3],
      );
    });
  });

  group('Testing getRequestBody', () {
    test('Returns body for REST when hasJsonData is true', () {
      const model = HttpRequestModel(
        body: '{"key":"value"}',
        method: HTTPVerb.post,
      );
      final result = getRequestBody(APIType.rest, model);
      expect(result, '{"key":"value"}');
    });

    test('Returns body for REST when hasTextData is true', () {
      const model = HttpRequestModel(body: 'plain text', method: HTTPVerb.post);
      final result = getRequestBody(APIType.rest, model);
      expect(result, 'plain text');
    });

    test('Returns null for REST when no data', () {
      const model = HttpRequestModel(body: null);
      final result = getRequestBody(APIType.rest, model);
      expect(result, isNull);
    });

    test('Returns GraphQL body as JSON when query is present', () {
      const model = HttpRequestModel(
        query: '{ users { name } }',
        method: HTTPVerb.post,
      );
      final result = getRequestBody(APIType.graphql, model);
      expect(result, '{\n  "query": "{ users { name } }"\n}');
    });

    test('Returns null for GraphQL when query is missing', () {
      const model = HttpRequestModel(query: null);
      final result = getRequestBody(APIType.graphql, model);
      expect(result, isNull);
    });

    test('Returns null for GraphQL when query is empty', () {
      const model = HttpRequestModel(query: '');
      final result = getRequestBody(APIType.graphql, model);
      expect(result, isNull);
    });
  });

  group('getFormDataType', () {
    test('Returns correct enum for valid type "text"', () {
      expect(getFormDataType("text"), FormDataType.text);
    });

    test('Returns correct enum for valid type "file"', () {
      expect(getFormDataType("file"), FormDataType.file);
    });

    test('Returns FormDataType.text for any other unknown type', () {
      expect(getFormDataType("unknown_type"), FormDataType.text);
    });
  });

  group('convertStreamedResponse', () {
    test('Converts StreamedResponse into Response correctly', () async {
      final bodyBytes = "Hello".codeUnits; // "Hello"
      final streamedResponse = StreamedResponse(
        Stream.fromIterable([bodyBytes]),
        200,
        headers: {'content-type': 'text/plain'},
        reasonPhrase: 'OK',
        persistentConnection: true,
      );

      final response = await convertStreamedResponse(streamedResponse);

      expect(response.statusCode, 200);
      expect(response.body, 'Hello');
      expect(response.headers['content-type'], 'text/plain');
      expect(response.reasonPhrase, 'OK');
      expect(response.persistentConnection, true);
    });
  });
}
