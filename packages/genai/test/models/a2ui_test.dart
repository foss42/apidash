import 'package:genai/models/a2ui.dart';
import 'package:test/test.dart';

void main() {
  group('A2UIParser.isA2UIPayload', () {
    test('returns true for createSurface event', () {
      const body = '{"createSurface":{"id":"main","title":"My App"}}';
      expect(A2UIParser.isA2UIPayload(body), isTrue);
    });

    test('returns true for updateComponents event', () {
      const body =
          '{"updateComponents":{"components":[{"id":"root","component":"Text","text":"Hi"}]}}';
      expect(A2UIParser.isA2UIPayload(body), isTrue);
    });

    test('returns true when events are mixed with blank lines', () {
      const body = '\n\n{"createSurface":{"id":"s1","title":"T"}}\n\n';
      expect(A2UIParser.isA2UIPayload(body), isTrue);
    });

    test('returns false for plain JSON', () {
      expect(A2UIParser.isA2UIPayload('{"foo":"bar"}'), isFalse);
    });

    test('returns false for empty string', () {
      expect(A2UIParser.isA2UIPayload(''), isFalse);
    });

    test('returns false for malformed lines', () {
      expect(A2UIParser.isA2UIPayload('not json at all'), isFalse);
    });

    test('returns false for Open Responses JSON', () {
      const body =
          '{"id":"r1","object":"response","output":[],"status":"completed"}';
      expect(A2UIParser.isA2UIPayload(body), isFalse);
    });
  });

  group('A2UIParser.parse', () {
    test('returns null when no components are present', () {
      const body = '{"updateDataModel":{"path":"/name","value":"Alice"}}';
      expect(A2UIParser.parse(body), isNull);
    });

    test('returns null for empty body', () {
      expect(A2UIParser.parse(''), isNull);
    });

    test('parses updateComponents into components map', () {
      const body =
          '{"updateComponents":{"components":[{"id":"root","component":"Text","text":"Hello"}]}}';
      final result = A2UIParser.parse(body);
      expect(result, isNotNull);
      expect(result!.components.containsKey('root'), isTrue);
      expect(result.components['root']['component'], 'Text');
    });

    test('parses updateDataModel into dataModel map', () {
      const body =
          '{"updateComponents":{"components":[{"id":"root","component":"Text","text":"x"}]}}\n'
          '{"updateDataModel":{"path":"/user/name","value":"Bob"}}';
      final result = A2UIParser.parse(body);
      expect(result!.dataModel['user/name'], 'Bob');
    });

    test('extracts surfaceTitle from createSurface event', () {
      const body =
          '{"createSurface":{"id":"main","title":"Weather Dashboard"}}\n'
          '{"updateComponents":{"components":[{"id":"root","component":"Text","text":"Hi"}]}}';
      final result = A2UIParser.parse(body);
      expect(result!.surfaceTitle, 'Weather Dashboard');
    });

    test('surfaceTitle is null when createSurface is absent', () {
      const body =
          '{"updateComponents":{"components":[{"id":"root","component":"Text","text":"Hi"}]}}';
      final result = A2UIParser.parse(body);
      expect(result!.surfaceTitle, isNull);
    });

    test('handles multiple updateComponents calls, last write wins per id', () {
      const body =
          '{"updateComponents":{"components":[{"id":"t1","component":"Text","text":"v1"}]}}\n'
          '{"updateComponents":{"components":[{"id":"t1","component":"Text","text":"v2"}]}}';
      final result = A2UIParser.parse(body);
      expect(result!.components['t1']['text'], 'v2');
    });

    test('skips malformed JSON lines', () {
      const body =
          'not json\n'
          '{"updateComponents":{"components":[{"id":"root","component":"Text","text":"ok"}]}}';
      final result = A2UIParser.parse(body);
      expect(result, isNotNull);
      expect(result!.components.containsKey('root'), isTrue);
    });

    test('ignores closeSurface events without crashing', () {
      const body =
          '{"updateComponents":{"components":[{"id":"root","component":"Text","text":"hi"}]}}\n'
          '{"closeSurface":{"id":"main"}}';
      expect(() => A2UIParser.parse(body), returnsNormally);
    });

    test('strips leading slash from dataModel path', () {
      const body =
          '{"updateComponents":{"components":[{"id":"root","component":"Text","text":"x"}]}}\n'
          '{"updateDataModel":{"path":"/score","value":42}}';
      final result = A2UIParser.parse(body);
      expect(result!.dataModel.containsKey('score'), isTrue);
      expect(result.dataModel['score'], 42);
    });
  });
}
