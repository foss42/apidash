import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('Testing StringExtensions', () {
    group('Testing capitalize', () {
      test('should capitalize the first letter of a lowercase word', () {
        expect('hello'.capitalize(), 'Hello');
      });

      test(
          'should capitalize the first letter and lowercase the rest of an uppercase word',
          () {
        expect('HELLO'.capitalize(), 'Hello');
      });

      test('should return the same string if it is already capitalized', () {
        expect('Hello'.capitalize(), 'Hello');
      });

      test('should return an empty string if the input is empty', () {
        expect(''.capitalize(), '');
      });

      test('should capitalize a single lowercase letter', () {
        expect('h'.capitalize(), 'H');
      });

      test('should return the same single uppercase letter', () {
        expect('H'.capitalize(), 'H');
      });
    });

    group('Testing clip', () {
      test(
          'should return the same string if its length is less than or equal to the limit',
          () {
        expect('hello'.clip(5), 'hello');
        expect('hello'.clip(10), 'hello');
      });

      test(
          'should clip the string and add ellipsis if its length is greater than the limit',
          () {
        expect('hello world'.clip(5), 'hello...');
        expect('hello world'.clip(8), 'hello wo...');
      });

      test('should return an empty string if the input is empty', () {
        expect(''.clip(5), '');
      });

      test('should handle limit of 0 correctly', () {
        expect('hello'.clip(0), '...');
      });

      test('should handle negative limit correctly', () {
        expect('hello'.clip(-1), '...');
      });
    });
  });
}
