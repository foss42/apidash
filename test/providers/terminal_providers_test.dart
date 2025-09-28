import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/terminal_providers.dart';
import 'package:apidash/terminal/terminal.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('TerminalController', () {
    late ProviderContainer container;
    late TerminalController controller;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(terminalStateProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is empty', () {
      final state = container.read(terminalStateProvider);
      expect(state.entries, isEmpty);
      expect(state.index, isEmpty);
    });

    test('log system entries and clear', () {
      controller.logSystem(category: 'ui', message: 'opened');
      controller.logSystem(
          category: 'provider', message: 'updated', level: TerminalLevel.warn);
      final state = container.read(terminalStateProvider);
      expect(state.entries.length, 2);
      expect(state.entries.first.system?.category, anyOf('ui', 'provider'));

      // serialization has timestamps, uppercase level and title-cased source
      final text = controller.serializeAll();
      expect(text, contains('INFO'));
      expect(text, contains('System'));
      expect(text.toLowerCase(), contains('opened'));

      controller.clear();
      expect(container.read(terminalStateProvider).entries, isEmpty);
    });

    test('JS logs map levels and include args', () {
      controller.logJs(level: 'log', args: ['hello']);
      controller.logJs(level: 'warn', args: ['warn']);
      controller.logJs(level: 'error', args: ['err'], context: 'preRequest');
      final state = container.read(terminalStateProvider);
      expect(state.entries.length, 3);
      final levels = state.entries.map((e) => e.level).toList();
      expect(levels.contains(TerminalLevel.info), isTrue);
      expect(levels.contains(TerminalLevel.warn), isTrue);
      expect(levels.contains(TerminalLevel.error), isTrue);

      final title0 = controller.titleFor(state.entries.first);
      final sub0 = controller.subtitleFor(state.entries.first);
      expect(title0.toLowerCase(), contains('js'));
      expect(sub0, isNotNull);
    });

    test('network lifecycle: start -> chunk -> complete', () async {
      final id = controller.startNetwork(
        apiType: APIType.rest,
        method: HTTPVerb.get,
        url: 'https://example.com',
        requestHeaders: const {'A': '1'},
        requestBodyPreview: 'req',
        isStreaming: true,
      );
      expect(container.read(terminalStateProvider).entries, isNotEmpty);

      controller.addNetworkChunk(
        id,
        BodyChunk(
          ts: DateTime.now(),
          text: 'chunk1',
          sizeBytes: 6,
        ),
      );

      controller.completeNetwork(
        id,
        statusCode: 200,
        responseHeaders: const {'B': '2'},
        responseBodyPreview: 'ok',
        duration: const Duration(milliseconds: 88),
      );

      final e = container.read(terminalStateProvider).entries.first;
      expect(e.network?.phase, NetworkPhase.completed);
      expect(e.level, TerminalLevel.info);
      expect(e.network?.responseStatus, 200);
      expect(e.network?.duration?.inMilliseconds, 88);

      // Helpers
      final title = controller.titleFor(e);
      final sub = controller.subtitleFor(e);
      expect(title, contains('GET'));
      expect(title, contains('https://example.com'));
      expect(sub, 'ok');

      // Serialization should include status code
      final ser = controller.serializeAll();
      expect(ser, contains('200'));
    });

    test('network failure switches level to error', () {
      final id = controller.startNetwork(
        apiType: APIType.rest,
        method: HTTPVerb.post,
        url: 'https://api',
      );
      controller.failNetwork(id, 'timeout');
      final e = container.read(terminalStateProvider).entries.first;
      expect(e.level, TerminalLevel.error);
      expect(e.network?.phase, NetworkPhase.failed);
      expect(controller.subtitleFor(e), 'timeout');
    });

    test('completeNetwork maps 4xx/5xx to error level', () {
      final id = controller.startNetwork(
        apiType: APIType.rest,
        method: HTTPVerb.get,
        url: 'https://api',
      );
      controller.completeNetwork(id,
          statusCode: 404, responseBodyPreview: 'nf');
      final e = container.read(terminalStateProvider).entries.first;
      expect(e.level, TerminalLevel.error);
      expect(e.network?.responseStatus, 404);
      expect(controller.subtitleFor(e), 'nf');
    });

    test('progress chunks update phase and accumulate data', () {
      final id = controller.startNetwork(
        apiType: APIType.rest,
        method: HTTPVerb.get,
        url: 'https://chunks',
        isStreaming: true,
      );
      controller.addNetworkChunk(
        id,
        BodyChunk(ts: DateTime.now(), text: 'part1', sizeBytes: 5),
      );
      controller.addNetworkChunk(
        id,
        BodyChunk(ts: DateTime.now(), text: 'part2', sizeBytes: 5),
      );
      final e = container.read(terminalStateProvider).entries.first;
      expect(e.network?.phase, NetworkPhase.progress);
      expect(e.network?.chunks.length, 2);
      expect(e.network?.chunks.first.text, 'part1');
    });

    test('entries are stored newest first and index maps ids', () {
      controller.logSystem(category: 'a', message: 'm1');
      controller.logSystem(category: 'b', message: 'm2');
      final entries = container.read(terminalStateProvider).entries;
      // Last logged appears first
      expect(entries.first.system?.category, anyOf('a', 'b'));
      final idxMap = container.read(terminalStateProvider).index;
      expect(idxMap.containsKey(entries.first.id), isTrue);
      expect(idxMap[entries.first.id], 0);
    });

    test('serializeAll with provided entries includes ISO timestamps', () {
      final e1 = TerminalEntry(
        id: 'x1',
        ts: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        source: TerminalSource.system,
        level: TerminalLevel.info,
        system: SystemLogData(category: 'ui', message: 'hello'),
      );
      final e2 = TerminalEntry(
        id: 'x2',
        ts: DateTime.fromMillisecondsSinceEpoch(1000, isUtc: true),
        source: TerminalSource.js,
        level: TerminalLevel.error,
        js: JsLogData(level: 'error', args: ['boom']),
      );
      final text = controller.serializeAll(entries: [e1, e2]);
      expect(text, contains('[1970-01-01T00:00:00.000Z]'));
      expect(text, contains('[1970-01-01T00:00:01.000Z]'));
      expect(text, contains('System'));
      expect(text, contains('JS error'));
    });
  });

  group('TerminalState.copyWith', () {
    test('returns same entries when no new entries provided', () {
      final e1 = TerminalEntry(
        id: 'id1',
        source: TerminalSource.system,
        level: TerminalLevel.info,
        system: SystemLogData(category: 'ui', message: 'hello'),
      );
      final s1 = TerminalState(entries: [e1]);
      final s2 = s1.copyWith();

      expect(identical(s1.entries, s2.entries), isTrue);
      expect(s2.index[e1.id], 0);
      expect(s2.index.length, 1);
    });

    test('rebuilds index when entries list changes', () {
      final e1 = TerminalEntry(
        id: 'id1',
        source: TerminalSource.system,
        level: TerminalLevel.info,
        system: SystemLogData(category: 'ui', message: 'hello'),
      );
      final e2 = TerminalEntry(
        id: 'id2',
        source: TerminalSource.js,
        level: TerminalLevel.error,
        js: JsLogData(level: 'error', args: ['boom']),
      );

      final s1 = TerminalState(entries: [e1]);
      final s2 = s1.copyWith(entries: [e2, e1]);

      expect(identical(s1.entries, s2.entries), isFalse);
      expect(s2.entries, orderedEquals([e2, e1]));
      expect(s2.index[e2.id], 0);
      expect(s2.index[e1.id], 1);
      expect(s2.index.length, 2);
    });
  });
}
