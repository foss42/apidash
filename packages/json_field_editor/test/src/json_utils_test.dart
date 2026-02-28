import 'package:flutter_test/flutter_test.dart';
import 'package:json_field_editor/src/json_utils.dart';

void main() {
  group('getJsonParsingError', () {
    test('returns error message for invalid JSON', () {
      String? invalidJson = '{ "name": "John", "age": 30, }';
      expect(JsonUtils.getJsonParsingError(invalidJson), isNotNull);
    });

    test('returns null for valid JSON', () {
      String? validJson = '{ "name": "John", "age": 30 }';
      expect(JsonUtils.getJsonParsingError(validJson), isNull);
    });
  });

  group('validateJson', () {
    test('calls onError with null for valid JSON', () {
      String validJson = '{ "name": "John", "age": 30 }';
      bool onErrorCalled = false;
      JsonUtils.validateJson(
        json: validJson,
        onError: (error) {
          onErrorCalled = true;
          expect(error, isNull);
        },
      );
      expect(onErrorCalled, isTrue);
    });

    test('calls onError with error message for invalid JSON', () {
      String invalidJson = '{ "name": "John", "age": 30, }';
      bool onErrorCalled = false;
      JsonUtils.validateJson(
        json: invalidJson,
        onError: (error) {
          onErrorCalled = true;
          expect(error, isNotNull);
        },
      );
      expect(onErrorCalled, isTrue);
    });
  });
}
