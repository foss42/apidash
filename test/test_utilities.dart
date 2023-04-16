import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String getRandomStringLines(int lines, int length) {
  List<String> result = [];
  for (var i = 0; i < lines; i++) {
    result.add(getRandomString(length));
  }
  return result.join('\n');
}
