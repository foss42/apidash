import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ws/ws_recently_sent.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Recently Sent dedupes repeated payloads, most recent first',
      (tester) async {
    const sent = WebSocketMessageType.sent;
    final requestModel = RequestModel(
      id: 'ws-1',
      apiType: APIType.websocket,
      wsRequestModel: const WebSocketRequestModel(
        messageHistory: [
          WebSocketMessage(payload: 'hi', messageType: sent),
          WebSocketMessage(payload: 'hello', messageType: sent),
          WebSocketMessage(payload: 'hi', messageType: sent),
          WebSocketMessage(payload: 'hi', messageType: sent),
        ],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => requestModel),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: WsRecentlySent(
              templates: const [],
              onReuse: (_) {},
              onSaveTemplate: (_, __) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('hi'), findsOneWidget);
    expect(find.text('hello'), findsOneWidget);
    // Send count shown only on the repeated card.
    expect(find.text('\u00d73'), findsOneWidget);
    expect(find.textContaining('\u00d7'), findsOneWidget);
    expect(find.byType(Scrollbar), findsOneWidget);
    // Most recent send comes first.
    expect(
      tester.getTopLeft(find.text('hi')).dx,
      lessThan(tester.getTopLeft(find.text('hello')).dx),
    );
  });

  testWidgets('Recently Sent card opens the full long message in a dialog',
      (tester) async {
    final longPayload =
        '{\n${List.generate(40, (i) => '  "key$i": "value$i"').join(',\n')}\n}';
    String? reused;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith(
            (ref) => RequestModel(
              id: 'ws',
              apiType: APIType.websocket,
              wsRequestModel: WebSocketRequestModel(
                url: 'wss://example.com',
                messageHistory: [
                  WebSocketMessage(
                    payload: longPayload,
                    outgoing: true,
                    messageType: WebSocketMessageType.sent,
                  ),
                ],
              ),
            ),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: WsRecentlySent(
              templates: const [],
              onReuse: (p) => reused = p,
              onSaveTemplate: (_, __) {},
            ),
          ),
        ),
      ),
    );

    // Tapping the card still loads the message into the editor.
    await tester.tap(find.byType(InkWell).first);
    expect(reused, longPayload);
    expect(find.byType(AlertDialog), findsNothing);

    // The "View" button opens the whole payload, selectable, with Copy.
    await tester.tap(find.byTooltip('View full message'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.widgetWithText(SelectableText, longPayload), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
  });

  testWidgets(
      'Recently Sent hides automatic (heartbeat) messages with any payload',
      (tester) async {
    const keepalive = '{"type":"keepalive"}';
    final history = [
      WebSocketMessage(
        payload: 'hi',
        timestamp: DateTime(2026, 1, 1),
        messageType: WebSocketMessageType.sent,
      ),
      WebSocketMessage(
        payload: keepalive,
        timestamp: DateTime(2026, 1, 1, 0, 0, 2),
        isAutomatic: true,
        messageType: WebSocketMessageType.sent,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith(
            (ref) => RequestModel(
              id: 'ws',
              apiType: APIType.websocket,
              wsRequestModel: WebSocketRequestModel(
                enableMessageHeartbeat: true,
                messageHeartbeatPayload: keepalive,
                messageHistory: history,
              ),
            ),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: WsRecentlySent(
              templates: const [],
              onReuse: (_) {},
              onSaveTemplate: (_, __) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('hi'), findsOneWidget);
    expect(find.text(keepalive), findsNothing);
  });
}
