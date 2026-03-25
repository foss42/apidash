import 'package:apidash/agentic_testing/engine/rule_generation_service.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RuleGenerationService', () {
    const service = RuleGenerationService();

    test('generates deterministic rule cases for request model', () {
      final request = RequestModel(
        id: 'r1',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.example.com/register',
          headers: [
            NameValueModel(name: 'Authorization', value: 'Bearer token'),
            NameValueModel(name: 'Content-Type', value: 'application/json'),
          ],
          isHeaderEnabledList: [true, true],
          body: '{"email":"x@y.com","password":"secret"}',
        ),
      );

      final first = service.generateForRequest(request);
      final second = service.generateForRequest(request);

      expect(first.isNotEmpty, isTrue);
      expect(second.length, first.length);

      for (int i = 0; i < first.length; i++) {
        expect(second[i].id, first[i].id);
        expect(second[i].name, first[i].name);
      }
    });

    test('returns valid-only case for simple GET request', () {
      final request = RequestModel(
        id: 'r2',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/health',
        ),
      );

      final cases = service.generateForRequest(request);

      expect(cases.length, 1);
      expect(cases.first.name, 'Valid Request');
    });
  });
}