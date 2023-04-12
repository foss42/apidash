import 'package:test/test.dart';
import 'package:apidash/utils/http_utils.dart';

void main() {
  group("Testing getRequestTitleFromUrl function", () {
    String titleUntitled = "untitled";
    test('Testing getRequestTitleFromUrl using url1', () {
      String url1 = "";
      expect(getRequestTitleFromUrl(url1), titleUntitled);
    });

    test('Testing getRequestTitleFromUrl using url2', () {
      String url2 = " ";
      expect(getRequestTitleFromUrl(url2), titleUntitled);
    });

    test('Testing getRequestTitleFromUrl using url3', () {
      String url3 = "https://api.foss42.com/country/codes";
      String title3Expected = "api.foss42.com/country/codes";
      expect(getRequestTitleFromUrl(url3), title3Expected);
    });

    test('Testing getRequestTitleFromUrl using url4', () {
      String url4 = "api.foss42.com/country/data";
      String title4Expected = "api.foss42.com/country/data";
      expect(getRequestTitleFromUrl(url4), title4Expected);
    });

    test('Testing getRequestTitleFromUrl using url5', () {
      String url5 = "http://";
      expect(getRequestTitleFromUrl(url5), titleUntitled);
    });

    test('Testing getRequestTitleFromUrl for null value', () {
      expect(getRequestTitleFromUrl(null), titleUntitled);
    });
  });
}
