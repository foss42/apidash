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
}
