import 'package:test/test.dart';
import 'package:apidash/utils/window_utils.dart';

void main() {
  group(
    "Testing showButtonLabelsInBodySuccess function",
    () {
      test('Test case 1 options 0', () {
        expect(showButtonLabelsInBodySuccess(0, 300), true);
      });

      test('Test case 2 options 0', () {
        expect(showButtonLabelsInBodySuccess(0, 500), true);
      });

      test('Test case 1 options 1', () {
        expect(showButtonLabelsInBodySuccess(1, 250), false);
      });

      test('Test case 2 options 1', () {
        expect(showButtonLabelsInBodySuccess(1, 350), true);
      });

      test('Test case 1 options 2', () {
        expect(showButtonLabelsInBodySuccess(2, 250), false);
      });

      test('Test case 2 options 2', () {
        expect(showButtonLabelsInBodySuccess(2, 350), false);
      });

      test('Test case 3 options 2', () {
        expect(showButtonLabelsInBodySuccess(2, 450), true);
      });

      test('Test case 1 options 3', () {
        expect(showButtonLabelsInBodySuccess(3, 350), false);
      });

      test('Test case 2 options 3', () {
        expect(showButtonLabelsInBodySuccess(3, 450), false);
      });

      test('Test case 3 options 3', () {
        expect(showButtonLabelsInBodySuccess(3, 550), true);
      });
    },
  );

  group(
    "Testing showButtonLabelsInViewCodePane function",
    () {
      test('Test case 2', () {
        expect(showButtonLabelsInViewCodePane(350), false);
      });

      test('Test case 3', () {
        expect(showButtonLabelsInViewCodePane(450), true);
      });
    },
  );
}
