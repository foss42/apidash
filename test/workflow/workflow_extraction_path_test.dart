import 'package:apidash/workflow/engine/extraction_service.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  const service = WorkflowExtractionService();

  group('normalizeExtractionPath', () {
    test('converts bracket indexes to dotted', () {
      expect(normalizeExtractionPath('data[0].id'), 'data.0.id');
      expect(normalizeExtractionPath('data.0.id'), 'data.0.id');
      expect(normalizeExtractionPath('items[2].name'), 'items.2.name');
    });
  });

  group('WorkflowExtractionService', () {
    test('reads data.0.id and data[0].id the same', () {
      const raw = '{"data":[{"id":"u1","name":"Ada"}]}';
      final response = HttpResponseModel(body: raw);
      expect(
        service.extract(
          source: 'response.body',
          jsonPath: 'data.0.id',
          response: response,
          statusCode: 200,
        ),
        'u1',
      );
      expect(
        service.extract(
          source: 'response.body',
          jsonPath: 'data[0].id',
          response: response,
          statusCode: 200,
        ),
        'u1',
      );
    });
  });
}
