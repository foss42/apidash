import 'package:path/path.dart';
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
        String shortPath = getShortPath(path);

        // Default windows separator (\) causes issue with
        // hardcoded default with separator for Linux/MacOS (/)
        if (context.separator == '\\') {
          shortPath = shortPath.replaceAll('\\', '/');
        }

        expect(shortPath, ".../C/D.csv");
      });

      test('Test getTempFileName', () {
        expect(getTempFileName().length, greaterThan(0));
      });
    },
  );
}
