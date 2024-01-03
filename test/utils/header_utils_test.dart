import 'package:apidash/utils/header_utils.dart';
import 'package:test/test.dart';

void main() {
  group("Testing getHeaderSuggestions function", () {
    test("Testing using Allow-Headers", () {
      String pattern = "Allow-Headers";
      List<String> expected = ["Access-Control-Allow-Headers"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Allow-Methods", () {
      String pattern = "Allow-Methods";
      List<String> expected = ["Access-Control-Allow-Methods"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Allow-Origin", () {
      String pattern = "Allow-Origin";
      List<String> expected = ["Access-Control-Allow-Origin"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Request-Method", () {
      String pattern = "Request-Method";
      List<String> expected = ["Access-Control-Request-Method"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Max-Age", () {
      String pattern = "Max-Age";
      List<String> expected = ["Access-Control-Max-Age"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Access-Control-Allow-Headers", () {
      String pattern = "Access-Control-Allow-Headers";
      List<String> expected = ["Access-Control-Allow-Headers"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Access-Control-Allow-Methods", () {
      String pattern = "Access-Control-Allow-Methods";
      List<String> expected = ["Access-Control-Allow-Methods"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Access-Control-Allow-Origin", () {
      String pattern = "Access-Control-Allow-Origin";
      List<String> expected = ["Access-Control-Allow-Origin"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Access-Control-Request-Method", () {
      String pattern = "Access-Control-Request-Method";
      List<String> expected = ["Access-Control-Request-Method"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Access-Control-Max-Age", () {
      String pattern = "Access-Control-Max-Age";
      List<String> expected = ["Access-Control-Max-Age"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Content-Type", () {
      String pattern = "Content-Type";
      List<String> expected = ["Content-Type"];
      expect(getHeaderSuggestions(pattern), expected);
    });
    test("Testing using Expires", () {
      String pattern = "Expires";
      List<String> expected = ["Expires"];
      expect(getHeaderSuggestions(pattern), expected);
    });
  });
}