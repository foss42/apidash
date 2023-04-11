import 'package:test/test.dart';
import 'package:apidash/utils/http_utils.dart';

void main() {
  String url1 = "";
  String url1Expected = "untitled";
  String url2 = " ";
  String url2Expected = "untitled";
  String url3 = "https://api.foss42.com/country/codes";
  String url3Expected = "api.foss42.com/country/codes";
  String url4 = "api.foss42.com/country/data";
  String url4Expected = "api.foss42.com/country/data";
  String url5 = "http://";
  String url5Expected = "untitled";

  group("Testing getRequestTitleFromUrl function", () {
    test('Testing getRequestTitleFromUrl using url1', () {
      expect(getRequestTitleFromUrl(url1), url1Expected);
    });

    test('Testing getRequestTitleFromUrl using url2', () {
      expect(getRequestTitleFromUrl(url2), url2Expected);
    });
    test('Testing getRequestTitleFromUrl using url3', () {
      expect(getRequestTitleFromUrl(url3), url3Expected);
    });
    test('Testing getRequestTitleFromUrl using url4', () {
      expect(getRequestTitleFromUrl(url4), url4Expected);
    });
    test('Testing getRequestTitleFromUrl using url5', () {
      expect(getRequestTitleFromUrl(url5), url5Expected);
    });
    test('Testing getRequestTitleFromUrl for null value', () {
      expect(getRequestTitleFromUrl(null), url1Expected);
    });
  });
}
