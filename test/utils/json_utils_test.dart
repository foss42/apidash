import 'package:apidash/utils/json_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsonUtils', () {
    test('getLineCol calculates correct position', () {
      String json = '{\n  "a": 1\n}';
      // offset 0: Line 1, Col 1 ({)
      expect(JsonUtils.getLineCol(json, 0), (1, 1));
       // offset 2: Line 2, Col 1 (newline + space)
       // \n is index 1. Index 2 is space.
       // split('\n') -> ["{", "  \"a\": 1", "}"]
       // substring(0, 2) -> "{\n"
       // split -> ["{", ""] -> line 2, col 1
      expect(JsonUtils.getLineCol(json, 2), (2, 1));
    });

    test('findDuplicateKeys detects simple duplicates', () {
      String json = '{"a": 1, "a": 2}';
      var (msg, offset, length) = JsonUtils.findDuplicateKeys(json);
      expect(msg, contains("Duplicate key 'a'"));
      // "a": 1 is at index 1. "a": 2 is at index 9.
      expect(offset, isNotNull);
      expect(length, 3); // "a" (length 3 with quotes)
    });

    test('findDuplicateKeys allows same keys in nested objects', () {
      String json = '{"a": 1, "b": {"a": 2}}';
      var (msg, _, _a) = JsonUtils.findDuplicateKeys(json);
      expect(msg, isNull);
    });

    test('findDuplicateKeys handles arrays correctly', () {
      String json = '[{"a": 1}, {"a": 2}]';
      var (msg, _, _a) = JsonUtils.findDuplicateKeys(json);
      expect(msg, isNull);
    });

    test('findDuplicateKeys ignores keys in strings/values', () {
      String json = '{"a": "a"}'; 
      var (msg, _, _a) = JsonUtils.findDuplicateKeys(json);
      expect(msg, isNull);
    });
     
    test('findDuplicateKeys handles escaped quotes', () {
      String json = '{"key": "val\\"", "key": 2}';
      var (msg, offset, length) = JsonUtils.findDuplicateKeys(json);
      expect(msg, contains("Duplicate key 'key'"));
      expect(offset, isNotNull);
      expect(length, isNotNull);
    });
  });
}
