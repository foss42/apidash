import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });
  group('Testing selectedDocExportProvider', () {
    test('returns null when selectedRequestModelProvider has no selection', () {
      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => null),
        ],
      );

      final doc = container.read(selectedDocExportProvider);
      expect(doc, isNull);
    });

    test('returns null when selectedRequestModel has no httpRequestModel', () {
      const nonHttpRequestModel = RequestModel(
        id: 'ws_1',
        name: 'WebSocket Stream',
        apiType: APIType.websocket,
      );

      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => nonHttpRequestModel),
        ],
      );

      final doc = container.read(selectedDocExportProvider);
      expect(doc, isNull);
    });

    test('returns formatted markdown for active RequestModel with response', () {
      final testRequestModel = RequestModel(
        id: 'req_1',
        name: 'Get Users List',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
          headers: [
            NameValueModel(name: 'Accept', value: 'application/json'),
          ],
        ),
        httpResponseModel: const HttpResponseModel(
          statusCode: 200,
          time: Duration(milliseconds: 85),
          body: '{"users": ["Alice", "Bob"]}',
        ),
      );

      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => testRequestModel),
        ],
      );

      final doc = container.read(selectedDocExportProvider);
      expect(doc, isNotNull);
      expect(doc, contains('# Get Users List'));
      expect(doc, contains('`GET` `https://api.apidash.dev/users`'));
      expect(doc, contains('Accept'));
      expect(doc, contains('200 OK'));
      expect(doc, contains('85 ms'));
    });

    test('reactively updates when response is received', () {
      final initialModel = RequestModel(
        id: 'req_2',
        name: 'Pending Request',
        httpRequestModel: const HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.apidash.dev/data',
        ),
      );

      final container = createContainer(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => initialModel),
        ],
      );

      // Initially no response section
      final initialDoc = container.read(selectedDocExportProvider);
      expect(initialDoc, isNotNull);
      expect(initialDoc, contains('# Pending Request'));
      expect(initialDoc, isNot(contains('## Response')));

      // Simulate response received
      final completedModel = initialModel.copyWith(
        httpResponseModel: const HttpResponseModel(
          statusCode: 201,
          time: Duration(milliseconds: 140),
          body: '{"id": 100}',
        ),
      );

      container.read(selectedRequestModelProvider.notifier).state = completedModel;

      final updatedDoc = container.read(selectedDocExportProvider);
      expect(updatedDoc, isNotNull);
      expect(updatedDoc, contains('## Response'));
      expect(updatedDoc, contains('201 Created'));
      expect(updatedDoc, contains('140 ms'));
    });
  });
}
