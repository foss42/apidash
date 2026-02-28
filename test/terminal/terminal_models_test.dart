import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/terminal/models/models.dart';
import 'package:apidash/terminal/enums.dart';

void main() {
  group('TerminalEntry model', () {
    test('copyWith preserves immutability and updates fields', () {
      final entry = TerminalEntry(
        id: 'e1',
        source: TerminalSource.system,
        level: TerminalLevel.info,
        system: SystemLogData(category: 'ui', message: 'hello'),
      );

      final ts = DateTime.fromMillisecondsSinceEpoch(1000);
      final updated = entry.copyWith(
        ts: ts,
        level: TerminalLevel.warn,
        system: SystemLogData(category: 'io', message: 'updated'),
      );

      expect(updated.id, 'e1');
      expect(updated.ts, ts);
      expect(updated.level, TerminalLevel.warn);
      expect(updated.system?.category, 'io');
      expect(entry.system?.category, 'ui');
    });

    test('supports js and network data variants', () {
      final jsEntry = TerminalEntry(
        id: 'j1',
        source: TerminalSource.js,
        level: TerminalLevel.error,
        js: JsLogData(level: 'error', args: ['a', 'b'], stack: 'trace'),
      );
      expect(jsEntry.js, isNotNull);
      expect(jsEntry.system, isNull);

      final netEntry = TerminalEntry(
        id: 'n1',
        source: TerminalSource.network,
        level: TerminalLevel.info,
        network: NetworkLogData(
          phase: NetworkPhase.started,
          apiType: APIType.rest,
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev',
        ),
      );
      expect(netEntry.network, isNotNull);
      expect(netEntry.js, isNull);
    });
  });

  group('NetworkLogData model', () {
    test('copyWith updates fields and keeps others', () {
      final n = NetworkLogData(
        phase: NetworkPhase.started,
        apiType: APIType.rest,
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev',
        requestHeaders: const {'A': '1'},
        requestBodyPreview: '{x}',
      );

      final completedAt = DateTime.fromMillisecondsSinceEpoch(5000);
      final c = n.copyWith(
        phase: NetworkPhase.completed,
        responseStatus: 200,
        responseHeaders: const {'B': '2'},
        responseBodyPreview: 'ok',
        duration: const Duration(milliseconds: 123),
        isStreaming: true,
        completedAt: completedAt,
      );

      expect(c.phase, NetworkPhase.completed);
      expect(c.responseStatus, 200);
      expect(c.responseHeaders, {'B': '2'});
      expect(c.requestHeaders, {'A': '1'});
      expect(c.requestBodyPreview, '{x}');
      expect(c.responseBodyPreview, 'ok');
      expect(c.duration?.inMilliseconds, 123);
      expect(c.isStreaming, true);
      expect(c.completedAt, completedAt);
    });

    test('copyWith preserves phase when not provided', () {
      final n = NetworkLogData(
        phase: NetworkPhase.started,
        apiType: APIType.rest,
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev',
      );

      // Do not pass phase; update another field
      final c = n.copyWith(responseStatus: 201);

      expect(c.phase, NetworkPhase.started);
      expect(c.responseStatus, 201);
      // Verify some other fields are preserved
      expect(c.apiType, APIType.rest);
      expect(c.method, HTTPVerb.get);
      expect(c.url, 'https://api.apidash.dev');
    });

    test('BodyChunk stores timestamp, text and size', () {
      final t = DateTime.fromMillisecondsSinceEpoch(42);
      final b = BodyChunk(ts: t, text: 'hello', sizeBytes: 5);
      expect(b.ts, t);
      expect(b.text, 'hello');
      expect(b.sizeBytes, 5);
    });
  });

  group('JsLogData & SystemLogData', () {
    test('JsLogData holds args, level and optional context', () {
      final j = JsLogData(level: 'warn', args: ['x', 'y'], context: 'pre');
      expect(j.level, 'warn');
      expect(j.args, ['x', 'y']);
      expect(j.context, 'pre');
      expect(j.stack, isNull);
    });

    test('SystemLogData stores category, message and stack', () {
      final s = SystemLogData(category: 'provider', message: 'm', stack: 'st');
      expect(s.category, 'provider');
      expect(s.message, 'm');
      expect(s.stack, 'st');
    });
  });
}
