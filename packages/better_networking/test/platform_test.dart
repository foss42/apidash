import 'package:better_networking/src/platform.dart';
import 'package:test/test.dart';

void main() {
  test('kIsWeb is false in pure-Dart environment', () {
    expect(kIsWeb, isFalse);
  });
}
