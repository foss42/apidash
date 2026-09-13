import 'package:apidash/consts.dart';
import 'package:apidash/importer/importer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Importer', () {
    test('getHttpRequestModelList returns null for invalid import', () async {
      final importer = Importer();
      final result = await importer.getHttpRequestModelList(
        ImportFormat.curl,
        'invalid content',
      );
      expect(result, isNull);
    });

    test('getHttpRequestModelList handles valid curl', () async {
      final importer = Importer();
      final result = await importer.getHttpRequestModelList(
        ImportFormat.curl,
        'curl -X GET https://api.test.com',
      );
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result[0].$2.url, 'https://api.test.com');
    });
  });
}
