import 'package:test/test.dart';
import 'package:apidash/utils/ui_utils.dart';
import 'package:flutter/material.dart';

void main() {
  int statusCode1 = 200;
  int statusCode2 = 300;
  int statusCode3 = 404;
  int statusCode4 = 503;
  int statusCode5 = 101;
  Color col1Expected = Colors.green.shade800;
  Color col2Expected = Colors.blue.shade800;
  Color col3Expected = Colors.red.shade800;
  Color col4Expected = Colors.amber.shade900;
  Brightness brightness1 = Brightness.dark;
  Color col5Expected =
      Color.alphaBlend(col1Expected.withOpacity(0.4), Colors.white);
  Color col6Expected =
      Color.alphaBlend(col2Expected.withOpacity(0.4), Colors.white);
  Color col7Expected =
      Color.alphaBlend(col3Expected.withOpacity(0.4), Colors.white);
  Color col8Expected =
      Color.alphaBlend(col4Expected.withOpacity(0.4), Colors.white);
  Color col9Expected = Colors.grey.shade700;
  Color col10Expected =
      Color.alphaBlend(col9Expected.withOpacity(0.4), Colors.white);

  group("Testing getResponseStatusCodeColor function", () {
    test('Testing getResponseStatusCodeColor for statusCode1', () {
      expect(getResponseStatusCodeColor(statusCode1), col1Expected);
    });
    test('Testing getResponseStatusCodeColor for statusCode1 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode1, brightness: brightness1),
          col5Expected);
    });
    test('Testing getResponseStatusCodeColor for statusCode2', () {
      expect(getResponseStatusCodeColor(statusCode2), col2Expected);
    });
    test('Testing getResponseStatusCodeColor for statusCode2 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode2, brightness: brightness1),
          col6Expected);
    });
    test('Testing getResponseStatusCodeColor for statusCode3', () {
      expect(getResponseStatusCodeColor(statusCode3), col3Expected);
    });
    test('Testing getResponseStatusCodeColor for statusCode3 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode3, brightness: brightness1),
          col7Expected);
    });
    test('Testing getResponseStatusCodeColor for statusCode4', () {
      expect(getResponseStatusCodeColor(statusCode4), col4Expected);
    });
    test('Testing getResponseStatusCodeColor for statusCode4 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode4, brightness: brightness1),
          col8Expected);
    });
    test('Testing getResponseStatusCodeColor for statusCode5', () {
      expect(getResponseStatusCodeColor(statusCode5), col9Expected);
    });
    test('Testing getResponseStatusCodeColor for statusCode5 dark mode', () {
      expect(getResponseStatusCodeColor(statusCode5, brightness: brightness1),
          col10Expected);
    });
  });
}
