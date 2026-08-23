import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ws/ws_recently_sent.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows user messages and excludes automatic messages', (
    tester,
  ) async {
    const request = RequestModel(
      id: 'websocket-request',
      apiType: APIType.websocket,
      wsRequestModel: WebSocketRequestModel(
        messageHistory: [
          WebSocketMessage(
            payload: 'Heartbeat ping',
            outgoing: true,
            messageType: WebSocketMessageType.sent,
          ),
          WebSocketMessage(
            payload: 'custom-heartbeat',
            outgoing: true,
            isAutomatic: true,
            messageType: WebSocketMessageType.sent,
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => request),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: WsRecentlySent(
              templates: const [],
              onReuse: (_) {},
              onSaveTemplate: (_, _) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Heartbeat ping'), findsOneWidget);
    expect(find.text('custom-heartbeat'), findsNothing);
  });
}
