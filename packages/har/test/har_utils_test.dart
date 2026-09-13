import 'package:har/har.dart';
import 'package:test/test.dart';

void main() {
  group('Har Utils tests', () {
    test('getRequestsFromHarLog handles null', () {
      expect(getRequestsFromHarLog(null), isEmpty);
      expect(getRequestsFromHarLog(HarLog()), isEmpty);
      expect(getRequestsFromHarLog(HarLog(log: Log())), isEmpty);
      expect(getRequestsFromHarLog(HarLog(log: Log(entries: []))), isEmpty);
    });

    test('getRequestsFromHarLog returns requests', () {
      final log = HarLog(
        log: Log(
          entries: [
            Entry(
              startedDateTime: '2023-01-01T00:00:00Z',
              request: Request(url: 'https://example.com/1'),
            ),
            Entry(request: Request(url: 'https://example.com/2')),
            Entry(), // No request
          ],
        ),
      );

      final requests = getRequestsFromHarLog(log);
      expect(requests.length, 2);
      expect(requests[0].$1, '2023-01-01T00:00:00Z');
      expect(requests[0].$2.url, 'https://example.com/1');
      expect(requests[1].$1, isNull);
      expect(requests[1].$2.url, 'https://example.com/2');
    });

    test('getRequestsFromHarLogEntry handles null', () {
      expect(getRequestsFromHarLogEntry(null), isEmpty);
      expect(getRequestsFromHarLogEntry(Entry()), isEmpty);
    });

    test('getRequestsFromHarLogEntry returns requests', () {
      final entry = Entry(
        startedDateTime: '2023-01-01T00:00:00Z',
        request: Request(url: 'https://example.com/1'),
      );

      final requests = getRequestsFromHarLogEntry(entry);
      expect(requests.length, 1);
      expect(requests[0].$1, '2023-01-01T00:00:00Z');
      expect(requests[0].$2.url, 'https://example.com/1');
    });
  });
}
