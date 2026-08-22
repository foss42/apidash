import 'dart:math';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/websocket_utils.dart';
import 'package:flutter_test/flutter_test.dart';

/// [n] messages whose payloads count up from [from], so ordering assertions
/// read unambiguously.
List<WebSocketMessage> msgs(int n, {int from = 0}) =>
    List.generate(n, (i) => WebSocketMessage(payload: '${from + i}'));

List<String> payloads(List<WebSocketMessage> list) =>
    list.map((m) => m.payload).toList();

/// The delay [webSocketReconnectDelay] should cap at for [attempt], derived by
/// repeated doubling rather than the shift the implementation uses, so this is
/// an independent check instead of a restatement.
int expectedCapMs(int attempt) {
  final capMs = kWsMaxReconnectDelay.inMilliseconds;
  var ms = kWsReconnectBaseDelay.inMilliseconds;
  for (var i = 1; i < attempt; i++) {
    ms *= 2;
    if (ms >= capMs) return capMs;
  }
  return ms > capMs ? capMs : ms;
}

void main() {
  group('appendWebSocketMessages', () {
    test('appends normally while below the cap', () {
      final result = appendWebSocketMessages(
        msgs(3),
        msgs(2, from: 3),
        max: 10,
      );
      expect(payloads(result), ['0', '1', '2', '3', '4']);
    });

    test('keeps everything when the result lands exactly on the cap', () {
      final result = appendWebSocketMessages(msgs(4), msgs(1, from: 4), max: 5);
      expect(result, hasLength(5));
      expect(payloads(result), ['0', '1', '2', '3', '4']);
    });

    test('drops the oldest messages once the cap is exceeded', () {
      final result = appendWebSocketMessages(msgs(5), msgs(2, from: 5), max: 5);
      expect(result, hasLength(5));
      // '0' and '1' fell off the front; the newest message is last.
      expect(payloads(result), ['2', '3', '4', '5', '6']);
    });

    test('stays at the cap across many successive single appends', () {
      var history = <WebSocketMessage>[];
      for (var i = 0; i < 250; i++) {
        history = appendWebSocketMessage(
          history,
          WebSocketMessage(payload: '$i'),
          max: 100,
        );
        expect(history.length, lessThanOrEqualTo(100));
      }
      expect(history, hasLength(100));
      expect(history.first.payload, '150');
      expect(history.last.payload, '249');
    });

    test(
      'keeps only the trailing window when additions alone exceed the cap',
      () {
        final result = appendWebSocketMessages(
          msgs(3),
          msgs(10, from: 100),
          max: 4,
        );
        expect(result, hasLength(4));
        // Nothing from history survives — only the last 4 additions.
        expect(payloads(result), ['106', '107', '108', '109']);
      },
    );

    test('trims an already-oversized history even with no additions', () {
      final result = appendWebSocketMessages(msgs(7), const [], max: 3);
      expect(payloads(result), ['4', '5', '6']);
    });

    test('returns a copy, not the original list, when nothing is added', () {
      final history = msgs(2);
      final result = appendWebSocketMessages(history, const [], max: 10);
      expect(result, equals(history));
      expect(identical(result, history), isFalse);
    });

    test('does not mutate the history it was given', () {
      final history = msgs(5);
      appendWebSocketMessages(history, msgs(5, from: 5), max: 5);
      expect(payloads(history), ['0', '1', '2', '3', '4']);
    });

    test('a non-positive cap retains nothing', () {
      expect(
        appendWebSocketMessages(msgs(3), msgs(1, from: 3), max: 0),
        isEmpty,
      );
    });

    test('defaults to kMaxWebSocketMessages', () {
      final result = appendWebSocketMessage(
        msgs(kMaxWebSocketMessages),
        const WebSocketMessage(payload: 'newest'),
      );
      expect(result, hasLength(kMaxWebSocketMessages));
      expect(result.last.payload, 'newest');
      // Exactly one message was evicted to make room.
      expect(result.first.payload, '1');
    });
  });

  group('webSocketReconnectDelay', () {
    test('grows exponentially from the base delay', () {
      // With equal jitter the delay lands in [cap/2, cap] for that attempt.
      for (var attempt = 1; attempt <= 15; attempt++) {
        final capMs = expectedCapMs(attempt);
        final ms = webSocketReconnectDelay(
          attempt,
          random: Random(attempt),
        ).inMilliseconds;
        expect(
          ms,
          inInclusiveRange(capMs ~/ 2, capMs),
          reason: 'attempt $attempt should fall within [${capMs ~/ 2}, $capMs]',
        );
      }
    });

    test('reaches the base delay window on the first attempt', () {
      final baseMs = kWsReconnectBaseDelay.inMilliseconds;
      final ms = webSocketReconnectDelay(1, random: Random(7)).inMilliseconds;
      expect(ms, inInclusiveRange(baseMs ~/ 2, baseMs));
    });

    test(
      'never exceeds kWsMaxReconnectDelay, including for absurd attempts',
      () {
        for (final attempt in [1, 5, 10, 32, 64, 1000, 1 << 40]) {
          expect(
            webSocketReconnectDelay(attempt),
            lessThanOrEqualTo(kWsMaxReconnectDelay),
            reason: 'attempt $attempt overflowed the cap',
          );
        }
      },
    );

    test('saturates at the cap once doubling passes it', () {
      // Anything at or beyond the saturation point shares the same window.
      final capMs = kWsMaxReconnectDelay.inMilliseconds;
      for (final attempt in [20, 50, 500]) {
        expect(expectedCapMs(attempt), capMs);
        expect(
          webSocketReconnectDelay(attempt).inMilliseconds,
          inInclusiveRange(capMs ~/ 2, capMs),
        );
      }
    });

    test('is always positive, so reconnects can never busy-loop', () {
      for (var attempt = 1; attempt <= 20; attempt++) {
        expect(
          webSocketReconnectDelay(attempt),
          greaterThan(Duration.zero),
          reason: 'attempt $attempt produced a non-positive delay',
        );
      }
    });

    test('treats non-positive attempts as the first attempt', () {
      final first = webSocketReconnectDelay(1, random: Random(3));
      expect(webSocketReconnectDelay(0, random: Random(3)), first);
      expect(webSocketReconnectDelay(-5, random: Random(3)), first);
    });

    test('is reproducible for a given seed', () {
      expect(
        webSocketReconnectDelay(4, random: Random(99)),
        webSocketReconnectDelay(4, random: Random(99)),
      );
    });

    test('jitter actually varies the delay across attempts', () {
      // Guards against the jitter term being accidentally dropped: over many
      // draws at one attempt the delay must not be constant.
      final random = Random(1234);
      final seen = <int>{};
      for (var i = 0; i < 50; i++) {
        seen.add(webSocketReconnectDelay(5, random: random).inMilliseconds);
      }
      expect(seen.length, greaterThan(1));
    });
  });

  group('webSocketConnectionWasStable', () {
    final connectedAt = DateTime(2026, 1, 1, 12);

    test('a session that outlived the threshold counts as recovered', () {
      expect(
        webSocketConnectionWasStable(
          connectedAt,
          connectedAt.add(kWsConnectionStableAfter * 2),
        ),
        isTrue,
      );
    });

    test('the threshold itself counts as recovered', () {
      expect(
        webSocketConnectionWasStable(
          connectedAt,
          connectedAt.add(kWsConnectionStableAfter),
        ),
        isTrue,
      );
    });

    test('an accept-then-close session does not reset the ladder', () {
      // The reconnect-storm shape: the handshake succeeds but the connection is
      // gone milliseconds later.
      expect(
        webSocketConnectionWasStable(
          connectedAt,
          connectedAt.add(const Duration(milliseconds: 20)),
        ),
        isFalse,
      );
    });

    test('a session just short of the threshold does not reset the ladder', () {
      expect(
        webSocketConnectionWasStable(
          connectedAt,
          connectedAt.add(kWsConnectionStableAfter - const Duration(seconds: 1)),
        ),
        isFalse,
      );
    });

    test('a clock that jumps backwards does not reset the ladder', () {
      expect(
        webSocketConnectionWasStable(
          connectedAt,
          connectedAt.subtract(const Duration(minutes: 5)),
        ),
        isFalse,
      );
    });

    test('honours an explicit threshold', () {
      final closedAt = connectedAt.add(const Duration(seconds: 5));
      expect(
        webSocketConnectionWasStable(
          connectedAt,
          closedAt,
          threshold: const Duration(seconds: 2),
        ),
        isTrue,
      );
      expect(
        webSocketConnectionWasStable(
          connectedAt,
          closedAt,
          threshold: const Duration(seconds: 10),
        ),
        isFalse,
      );
    });
  });
}
