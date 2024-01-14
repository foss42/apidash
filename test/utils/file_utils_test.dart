import 'package:test/test.dart';
import 'package:apidash/utils/file_utils.dart';

void main() {
  group(
    "Testing File Utils",
    () {
      test('Test getFileExtension', () {
        String mimetype = "text/csv";
        expect(getFileExtension(mimetype), "csv");
      });

      test('Test getShortPath', () {
        String path = "A/B/C/D.csv";
        expect(getShortPath(path), ".../C/D.csv");
      });

      test('Test getTempFileName', () {
        expect(getTempFileName().length, greaterThan(0));
      });
    },
  );
}
