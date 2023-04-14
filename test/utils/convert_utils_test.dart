import 'package:test/test.dart';
import 'package:apidash/utils/convert_utils.dart';

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
}
