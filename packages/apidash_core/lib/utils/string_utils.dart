import 'dart:math';

class RandomStringGenerator {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static Random rnd = Random();

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(rnd.nextInt(_chars.length))));

  static String getRandomStringLines(int lines, int length) {
    List<String> result = [];
    for (var i = 0; i < lines; i++) {
      result.add(getRandomString(length));
    }
    return result.join('\n');
  }
}
