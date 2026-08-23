import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/realtime_event_stream_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('watches a JSON value across received messages', (tester) async {
    final messages = [
      WebSocketMessage(
        payload: '{"ticker":{"price":10}}',
        timestamp: DateTime(2026, 8, 24, 10, 0, 1),
        outgoing: false,
        messageType: WebSocketMessageType.received,
      ),
      WebSocketMessage(
        payload: '{"ticker":{"price":999}}',
        timestamp: DateTime(2026, 8, 24, 10, 0, 2),
        messageType: WebSocketMessageType.sent,
      ),
      WebSocketMessage(
        payload: '{"ticker":{"price":20}}',
        timestamp: DateTime(2026, 8, 24, 10, 0, 3),
        outgoing: false,
        messageType: WebSocketMessageType.received,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              height: 500,
              child: RealtimeEventStreamView(historyMessages: messages),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('websocket-watch-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('websocket-watch-field')),
      'price',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Watch'));
    await tester.pumpAndSettle();

    expect(find.text('price (2)'), findsOneWidget);
    expect(find.byKey(const ValueKey('watched-value-10')), findsOneWidget);
    expect(find.byKey(const ValueKey('watched-value-20')), findsOneWidget);
    expect(find.byKey(const ValueKey('watched-value-999')), findsNothing);
    expect(find.text('10:00:03'), findsOneWidget);
  });

  testWidgets('stopping a watch restores the full event stream', (
    tester,
  ) async {
    const payload = '{"price":10}';
    final messages = [
      WebSocketMessage(
        payload: payload,
        timestamp: DateTime(2026, 8, 24, 10),
        outgoing: false,
        messageType: WebSocketMessageType.received,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              height: 500,
              child: RealtimeEventStreamView(historyMessages: messages),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('websocket-watch-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('websocket-watch-field')),
      'price',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Watch'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('websocket-watch-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Stop watching'));
    await tester.pumpAndSettle();

    expect(find.text(payload), findsOneWidget);
    expect(find.text('price (1)'), findsNothing);
  });
}
