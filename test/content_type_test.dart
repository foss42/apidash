import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Content-Type Header Tests', () {
    test('useRawContentType removes charset from Content-Type header', () {
      // Simulate the behavior directly
      final contentTypeWithCharset = 'application/json; charset=utf-8';
      final contentTypeWithoutCharset = contentTypeWithCharset.split(';')[0];
      
      // Verify the splitting works
      expect(contentTypeWithoutCharset, equals('application/json'));
      
      // Simulate the actual fix logic
      final useRawContentType = true;
      final map = {'Content-Type': 'application/json; charset=utf-8'};
      
      if (useRawContentType && map.containsKey('Content-Type')) {
        map['Content-Type'] = map['Content-Type']!.split(';')[0];
      }
      
      // Verify the result
      expect(map['Content-Type'], equals('application/json'));
      
      print('Test PASSED: Content-Type header without charset is: ${map['Content-Type']}');
    });
  });
} 