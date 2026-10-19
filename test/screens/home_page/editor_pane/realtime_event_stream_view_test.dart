import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/realtime_event_stream_view.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/response_pane.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

WebSocketMessage received(String payload, int second) => WebSocketMessage(
  payload: payload,
  timestamp: DateTime(2026, 10, 19, 10, 0, second),
  outgoing: false,
  messageType: WebSocketMessageType.received,
);

final sampleMessages = [
  received('{"ticker":{"price":10}}', 1),
  WebSocketMessage(
    payload: '{"ticker":{"price":999}}',
    timestamp: DateTime(2026, 10, 19, 10, 0, 2),
    messageType: WebSocketMessageType.sent,
  ),
  received('{"ticker":{"price":20}}', 3),
];

Future<ValueNotifier<List<WebSocketMessage>>> pumpStream(
  WidgetTester tester,
  List<WebSocketMessage> history, {
  int maxEvents = 1000,
  double width = 1200,
  bool enableJsonWatch = true,
}) async {
  tester.view.physicalSize = Size(width, 850);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final messages = ValueNotifier(history);
  addTearDown(messages.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          (ref) => ThemeStateNotifier(
            settingsModel: SettingsModel(maxConnectionMessages: maxEvents),
          ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<List<WebSocketMessage>>(
            valueListenable: messages,
            builder: (context, value, _) => RealtimeEventStreamView(
              historyMessages: value,
              enableJsonWatch: enableJsonWatch,
            ),
          ),
        ),
      ),
    ),
  );
  return messages;
}

Future<void> startWatch(WidgetTester tester, String expression) async {
  await tester.tap(find.byKey(const ValueKey('websocket-watch-button')));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const ValueKey('websocket-watch-field')),
    expression,
  );
  await tester.tap(find.widgetWithText(FilledButton, 'Watch'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'watches received values newest-first and leaves sent events out',
    (tester) async {
      await pumpStream(tester, sampleMessages);
      await startWatch(tester, r'$.ticker.price');
      expect(find.text(r'$.ticker.price (2)'), findsOneWidget);
      expect(find.byKey(const ValueKey('watched-value-999')), findsNothing);
      expect(find.text('10:00:03'), findsOneWidget);
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('watched-value-20'))).dy,
        lessThan(
          tester.getTopLeft(find.byKey(const ValueKey('watched-value-10'))).dy,
        ),
      );
    },
  );

  testWidgets(
    'stopping a watch restores unchanged full history including sent messages',
    (tester) async {
      final messages = List<WebSocketMessage>.unmodifiable(sampleMessages);
      final state = await pumpStream(tester, messages);
      await startWatch(tester, 'price');
      await tester.tap(
        find.byKey(const ValueKey('websocket-stop-watch-button')),
      );
      await tester.pumpAndSettle();
      for (final message in messages) {
        expect(find.text(message.payload), findsOneWidget);
      }
      expect(state.value, same(messages));
      expect(find.text('price (2)'), findsNothing);
    },
  );

  testWidgets('appended incoming messages update an active watch', (
    tester,
  ) async {
    final state = await pumpStream(tester, [sampleMessages.first]);
    await startWatch(tester, 'price');
    state.value = [...state.value, received('{"price":30}', 4)];
    await tester.pumpAndSettle();
    expect(find.text('price (2)'), findsOneWidget);
    expect(find.byKey(const ValueKey('watched-value-30')), findsOneWidget);
  });

  testWidgets(
    'ignores invalid JSON, missing keys and connection events, retains JSON null',
    (tester) async {
      await pumpStream(tester, [
        received('not-json', 1),
        received('{"other":42}', 2),
        received('{"price":null}', 3),
        const WebSocketMessage(
          payload: '{"price":99}',
          messageType: WebSocketMessageType.connected,
        ),
      ]);
      await startWatch(tester, 'price');
      expect(find.text('price (1)'), findsOneWidget);
      expect(find.byKey(const ValueKey('watched-value-null')), findsOneWidget);
      expect(find.byKey(const ValueKey('watched-value-99')), findsNothing);
    },
  );

  testWidgets('invalid path stays in dialog and preserves the current watch', (
    tester,
  ) async {
    await pumpStream(tester, sampleMessages);
    await startWatch(tester, 'price');
    await startWatch(tester, r'$.ticker[');
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Missing closing "]"'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Watching price'), findsOneWidget);
    expect(find.text('price (2)'), findsOneWidget);
  });

  testWidgets('empty expression cannot silently clear a watch', (tester) async {
    await pumpStream(tester, sampleMessages);
    await startWatch(tester, '');
    expect(find.text('Enter a key or JSONPath'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('keyboard submit validates the path', (tester) async {
    await pumpStream(tester, sampleMessages);
    await tester.tap(find.byKey(const ValueKey('websocket-watch-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('websocket-watch-field')),
      r'$.ticker.price',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text(r'$.ticker.price (2)'), findsOneWidget);
  });

  testWidgets('stop action in the dialog restores the stream', (tester) async {
    await pumpStream(tester, sampleMessages);
    await startWatch(tester, 'price');
    await tester.tap(find.byKey(const ValueKey('websocket-watch-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Stop watching'));
    await tester.pumpAndSettle();
    expect(find.text(sampleMessages.first.payload), findsOneWidget);
    expect(find.text('Watching price'), findsNothing);
  });

  testWidgets(
    'message limit retains the newest matching values rather than newest events',
    (tester) async {
      await pumpStream(tester, [
        received('{"price":1}', 1),
        received('{"price":2}', 2),
        received('{"price":3}', 3),
        received('non-json', 4),
        received('{"other":4}', 5),
      ], maxEvents: 2);
      await startWatch(tester, 'price');
      expect(find.text('price (2)'), findsOneWidget);
      expect(find.byKey(const ValueKey('watched-value-1')), findsNothing);
      expect(find.byKey(const ValueKey('watched-value-2')), findsOneWidget);
      expect(find.byKey(const ValueKey('watched-value-3')), findsOneWidget);
    },
  );

  testWidgets(
    'existing payload filter applies while watching and survives stopping',
    (tester) async {
      await pumpStream(tester, [
        received('{"market":"north","price":1}', 1),
        received('{"market":"south","price":2}', 2),
      ]);
      final filter = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Filter messages...',
      );
      await tester.enterText(filter, 'north');
      await tester.pumpAndSettle();
      await startWatch(tester, 'price');
      expect(find.byKey(const ValueKey('watched-value-1')), findsOneWidget);
      expect(find.byKey(const ValueKey('watched-value-2')), findsNothing);
      await tester.tap(
        find.byKey(const ValueKey('websocket-stop-watch-button')),
      );
      await tester.pumpAndSettle();
      expect(find.text('{"market":"north","price":1}'), findsOneWidget);
      expect(find.text('{"market":"south","price":2}'), findsNothing);
    },
  );

  testWidgets('empty-state message updates when matching data arrives', (
    tester,
  ) async {
    final state = await pumpStream(tester, <WebSocketMessage>[]);
    await startWatch(tester, 'price');
    state.value = [received('{"other":1}', 1)];
    await tester.pumpAndSettle();
    expect(
      find.text('No values found for "price" in received JSON messages.'),
      findsOneWidget,
    );
    state.value = [received('{"price":42}', 2)];
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('watched-value-42')), findsOneWidget);
  });

  testWidgets('can edit a running watch without altering the stream', (
    tester,
  ) async {
    await pumpStream(tester, [received('{"price":1,"volume":25}', 1)]);
    await startWatch(tester, 'price');
    await startWatch(tester, 'volume');
    expect(find.text('Watching volume'), findsOneWidget);
    expect(find.byKey(const ValueKey('watched-value-25')), findsOneWidget);
    expect(find.byKey(const ValueKey('watched-value-1')), findsNothing);
  });

  testWidgets('per-value copy places the extracted value on the clipboard', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pumpStream(tester, [received('{"price":42}', 1)]);
    await startWatch(tester, 'price');
    await tester.tap(find.byTooltip('Copy'));
    await tester.pumpAndSettle();
    expect(copied, '42');
  });

  testWidgets('watch dialog and series fit a narrow mobile viewport', (
    tester,
  ) async {
    await pumpStream(tester, sampleMessages, width: 360);
    await startWatch(tester, r'$.ticker.price');
    expect(find.byKey(const ValueKey('watched-value-20')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shared stream views do not expose JSON watch unless enabled', (
    tester,
  ) async {
    await pumpStream(tester, sampleMessages, enableJsonWatch: false);
    expect(find.byKey(const ValueKey('websocket-watch-button')), findsNothing);
  });

  testWidgets('disabling JSON watch on a reused stream restores its log', (
    tester,
  ) async {
    var enabled = true;
    late StateSetter update;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return RealtimeEventStreamView(
                  historyMessages: sampleMessages,
                  enableJsonWatch: enabled,
                );
              },
            ),
          ),
        ),
      ),
    );
    await startWatch(tester, 'price');
    update(() => enabled = false);
    await tester.pumpAndSettle();
    expect(find.text('Watching price'), findsNothing);
    expect(find.text(sampleMessages.first.payload), findsOneWidget);
  });

  for (final apiType in [APIType.websocket, APIType.mqtt]) {
    testWidgets('live response panel gates JSON watch for $apiType', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedRequestModelProvider.overrideWith(
              (ref) => RequestModel(
                id: 'stream',
                apiType: apiType,
                isStreaming: true,
                wsRequestModel: const WebSocketRequestModel(),
                mqttRequestModel: const MQTTRequestModel(
                  brokerUrl: 'localhost',
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: ResponsePane())),
        ),
      );
      expect(
        find.byKey(const ValueKey('websocket-watch-button')),
        apiType == APIType.websocket ? findsOneWidget : findsNothing,
      );
    });
  }
}
