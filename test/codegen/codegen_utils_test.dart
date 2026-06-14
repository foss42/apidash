import 'package:test/test.dart';
import 'package:apidash/codegen/codegen_utils.dart';

void main() {
  group("Testing jsonToPyDict", () {
    test('null is replaced with None', () {
      expect(jsonToPyDict('{"key": null}'), '{"key": None}');
    });

    test('true is replaced with True', () {
      expect(jsonToPyDict('{"key": true}'), '{"key": True}');
    });

    test('false is replaced with False', () {
      expect(jsonToPyDict('{"key": false}'), '{"key": False}');
    });

    test('quoted "null" inside string values is preserved', () {
      expect(jsonToPyDict('{"key": "null"}'), '{"key": "null"}');
    });

    test('quoted "true" inside string values is preserved', () {
      expect(jsonToPyDict('{"key": "true"}'), '{"key": "true"}');
    });

    test('quoted "false" inside string values is preserved', () {
      expect(jsonToPyDict('{"key": "false"}'), '{"key": "false"}');
    });

    test('mixed replacements with quoted and unquoted values', () {
      expect(
        jsonToPyDict('{"a": null, "b": true, "c": "false"}'),
        '{"a": None, "b": True, "c": "false"}',
      );
    });

    test('empty object is unchanged', () {
      expect(jsonToPyDict('{}'), '{}');
    });

    test('nested objects with multiple replacements', () {
      expect(
        jsonToPyDict('{"a": {"b": null, "c": true}}'),
        '{"a": {"b": None, "c": True}}',
      );
    });

    test('array with booleans and null', () {
      expect(
        jsonToPyDict('[true, false, null]'),
        '[True, False, None]',
      );
    });

    test('complex JSON with all replacement types', () {
      const input = '{"text": "I LOVE Flutter", "flag": null, "male": true, '
          '"female": false, "no": 1.2, "arr": ["null", "true", "false", null]}';
      const expected = '{"text": "I LOVE Flutter", "flag": None, "male": True, '
          '"female": False, "no": 1.2, "arr": ["null", "true", "false", None]}';
      expect(jsonToPyDict(input), expected);
    });
  });
}
