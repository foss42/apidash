import 'package:apidash/dashbot/dashbot_dashboard.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/routes/routes.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../providers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  Future<ProviderContainer> pumpDashbotWindow(WidgetTester tester) async {
    tester.view.physicalSize = const Size(2000, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: DashbotWindow(onClose: () {})),
        ),
      ),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(DashbotWindow)),
    );
    // Grow the window so the home page's button Wrap fits without overflow.
    container
        .read(dashbotWindowNotifierProvider.notifier)
        .updateSize(-1200, -1285, const Size(2000, 2000));
    // The collection notifier's constructor selects the first id in a
    // microtask (creating a default request on an empty box) — let it run.
    container.read(collectionStateNotifierProvider.notifier);
    await tester.pumpAndSettle();
    return container;
  }

  /// A WS request model that has "connected at least once": the real connect
  /// flow (`_connectWebSocket`, collection_providers.dart) appends a connected
  /// lifecycle event to [WebSocketRequestModel.messageHistory], so any connect
  /// attempt leaves it non-empty. This is the WS equivalent of HTTP's
  /// "a response exists" gate in `computeDashbotBaseRoute`.
  WebSocketRequestModel wsModelWithConnectActivity() => WebSocketRequestModel(
    url: 'wss://api.apidash.dev/ws/echo',
    messageHistory: [
      WebSocketMessage(
        payload: 'Connected to wss://api.apidash.dev/ws/echo',
        timestamp: DateTime(2026, 7, 7, 12),
        outgoing: false,
        messageType: WebSocketMessageType.connected,
      ),
    ],
  );

  testWidgets('floating-icon entry shows the WS task buttons for a WS request '
      'with connection activity', (tester) async {
    final container = await pumpDashbotWindow(tester);
    final notifier = container.read(collectionStateNotifierProvider.notifier);
    final id = container.read(selectedIdStateProvider)!;

    // Turn the selected request into a WebSocket request through the real
    // notifier, exactly as the app does, and seed the connected lifecycle
    // event a real connect attempt would leave in messageHistory.
    notifier.update(id: id, apiType: APIType.websocket);
    notifier.update(id: id, wsRequestModel: wsModelWithConnectActivity());
    await tester.pumpAndSettle();

    // The active route must resolve to the home page, not the default page.
    expect(
      container.read(dashbotActiveRouteProvider),
      DashbotRoutes.dashbotHome,
    );
    expect(
      find.textContaining("haven't made any Requests yet"),
      findsNothing,
      reason: 'DashBot landed on the default page for a WS request',
    );

    // All 10 WS task buttons are visible.
    for (final label in [
      '🔌 Explain this connection',
      '🛠️ Help me fix my connection',
      '📡 What is the server sending?',
      '🔍 Find in messages',
      '✉️ Explain my message',
      '❓ Why did my message fail?',
      '❤️ Connection health',
      '📄 Generate documentation',
      '📝 Generate Tests',
      '🧩 Generate Code',
    ]) {
      expect(
        find.text(label),
        findsOneWidget,
        reason: 'WS task button "$label" missing on the DashBot home page',
      );
    }

    // HTTP-only tasks stay hidden for WS; shared imports remain.
    expect(find.text('🔎 Explain me this response'), findsNothing);
    expect(find.text('🐞 Help me debug this error'), findsNothing);
    expect(find.text('📱 Generate UI'), findsNothing);
    expect(find.text('📥 Import cURL'), findsOneWidget);
    expect(find.text('📄 Import OpenAPI'), findsOneWidget);
  });

  testWidgets(
    'floating-icon entry shows the default page for a WS request with NO '
    'connection activity (never connected)',
    (tester) async {
      final container = await pumpDashbotWindow(tester);
      final notifier = container.read(collectionStateNotifierProvider.notifier);
      final id = container.read(selectedIdStateProvider)!;

      // A WS request that has never been connected: empty messageHistory,
      // not streaming. Same semantics as a REST request without a response.
      notifier.update(id: id, apiType: APIType.websocket);
      notifier.update(
        id: id,
        wsRequestModel: const WebSocketRequestModel(
          url: 'wss://api.apidash.dev/ws/echo',
        ),
      );
      await tester.pumpAndSettle();

      expect(
        container.read(dashbotActiveRouteProvider),
        DashbotRoutes.dashbotDefault,
      );
      expect(
        find.textContaining("haven't made any Requests yet"),
        findsOneWidget,
      );
      expect(find.text('🤖 Open Chat'), findsOneWidget);
      // No task buttons of either protocol on the default page.
      expect(find.text('🔌 Explain this connection'), findsNothing);
      expect(find.text('❤️ Connection health'), findsNothing);
      expect(find.text('🔎 Explain me this response'), findsNothing);
      expect(find.text('🐞 Help me debug this error'), findsNothing);
      expect(find.text('📱 Generate UI'), findsNothing);
    },
  );

  testWidgets(
    'floating-icon entry still shows the default page for a REST request '
    'without a response',
    (tester) async {
      final container = await pumpDashbotWindow(tester);

      // The freshly created default request is REST with no response.
      expect(
        container.read(dashbotActiveRouteProvider),
        DashbotRoutes.dashbotDefault,
      );
      expect(
        find.textContaining("haven't made any Requests yet"),
        findsOneWidget,
      );
      expect(find.text('🤖 Open Chat'), findsOneWidget);
      // No task buttons of either protocol on the default page.
      expect(find.text('🔌 Explain this connection'), findsNothing);
      expect(find.text('❤️ Connection health'), findsNothing);
      expect(find.text('🔎 Explain me this response'), findsNothing);
      expect(find.text('🐞 Help me debug this error'), findsNothing);
      expect(find.text('📱 Generate UI'), findsNothing);
    },
  );

  
  /// The 3 HTTP-exclusive task labels (absent from the WS set).
  const httpOnlyLabels = [
    '🔎 Explain me this response',
    '🐞 Help me debug this error',
    '📱 Generate UI',
  ];

  /// Two WS-exclusive task labels (absent from the HTTP set).
  const wsOnlyLabels = ['🔌 Explain this connection', '❤️ Connection health'];

  void expectHomeWithHttpTaskSet(ProviderContainer container) {
    expect(
      container.read(dashbotActiveRouteProvider),
      DashbotRoutes.dashbotHome,
    );
    for (final label in httpOnlyLabels) {
      expect(
        find.text(label),
        findsOneWidget,
        reason: 'HTTP task button "$label" missing on the DashBot home page',
      );
    }
    for (final label in wsOnlyLabels) {
      expect(
        find.text(label),
        findsNothing,
        reason: 'WS-only button "$label" leaked into the HTTP task set',
      );
    }
  }

  void expectHomeWithWsTaskSet(ProviderContainer container) {
    expect(
      container.read(dashbotActiveRouteProvider),
      DashbotRoutes.dashbotHome,
    );
    for (final label in wsOnlyLabels) {
      expect(
        find.text(label),
        findsOneWidget,
        reason: 'WS task button "$label" missing on the DashBot home page',
      );
    }
    for (final label in httpOnlyLabels) {
      expect(
        find.text(label),
        findsNothing,
        reason: 'HTTP-only button "$label" leaked into the WS task set',
      );
    }
  }

  void expectDefaultPage(ProviderContainer container) {
    expect(
      container.read(dashbotActiveRouteProvider),
      DashbotRoutes.dashbotDefault,
    );
    expect(find.text('🤖 Open Chat'), findsOneWidget);
    for (final label in [...httpOnlyLabels, ...wsOnlyLabels]) {
      expect(
        find.text(label),
        findsNothing,
        reason: 'task button "$label" visible on the default page',
      );
    }
  }

  testWidgets(
    'floating-icon entry shows home + HTTP task set for a REST request '
    'WITH a response (regression lock)',
    (tester) async {
      final container = await pumpDashbotWindow(tester);
      final notifier = container.read(collectionStateNotifierProvider.notifier);
      final id = container.read(selectedIdStateProvider)!;

      // Seed a response on the default REST request through the real
      // notifier, exactly as `sendRequest` does on completion.
      notifier.update(id: id, responseStatus: 200);
      await tester.pumpAndSettle();

      expectHomeWithHttpTaskSet(container);
      expect(
        find.textContaining("haven't made any Requests yet"),
        findsNothing,
        reason:
            'DashBot stayed on the default page for a REST request '
            'with a response',
      );
      // Shared buttons remain.
      expect(find.text('📥 Import cURL'), findsOneWidget);
      expect(find.text('📄 Import OpenAPI'), findsOneWidget);
    },
  );

  for (final apiType in [APIType.graphql, APIType.ai]) {
    testWidgets(
      'floating-icon entry shows home + HTTP task set for a ${apiType.name} '
      'request WITH a response (regression lock)',
      (tester) async {
        final container = await pumpDashbotWindow(tester);
        final notifier = container.read(
          collectionStateNotifierProvider.notifier,
        );
        final id = container.read(selectedIdStateProvider)!;

        // Two calls on purpose: `update`'s apiType-SWITCH branch ignores the
        // response params, so the response must be seeded in a second call.
        notifier.update(id: id, apiType: apiType);
        notifier.update(id: id, responseStatus: 200);
        await tester.pumpAndSettle();

        expectHomeWithHttpTaskSet(container);
      },
    );

    testWidgets(
      'floating-icon entry shows the default page for a ${apiType.name} '
      'request WITHOUT a response (regression lock)',
      (tester) async {
        final container = await pumpDashbotWindow(tester);
        final notifier = container.read(
          collectionStateNotifierProvider.notifier,
        );
        final id = container.read(selectedIdStateProvider)!;

        notifier.update(id: id, apiType: apiType);
        await tester.pumpAndSettle();

        expectDefaultPage(container);
      },
    );
  }

  testWidgets(
    'switching selection with the window open flips route + button set '
    'every time (WS ↔ REST±response)',
    (tester) async {
      final container = await pumpDashbotWindow(tester);
      final notifier = container.read(collectionStateNotifierProvider.notifier);

      // Request 1: the freshly created default request — REST, NO response.
      final restNoRespId = container.read(selectedIdStateProvider)!;

      // Request 2: REST with a seeded response. `add()` selects the new id.
      notifier.add();
      final restWithRespId = container.read(selectedIdStateProvider)!;
      notifier.update(id: restWithRespId, responseStatus: 200);

      // Request 3: WebSocket WITH connection activity (two calls: apiType
      // switch, then ws model carrying a connected lifecycle event).
      notifier.add();
      final wsId = container.read(selectedIdStateProvider)!;
      notifier.update(id: wsId, apiType: APIType.websocket);
      notifier.update(id: wsId, wsRequestModel: wsModelWithConnectActivity());
      await tester.pumpAndSettle();

      // Switch selection exactly as the request list does: write the
      // selected id, letting selectedRequestModelProvider recompute.
      Future<void> select(String id) async {
        container.read(selectedIdStateProvider.notifier).state = id;
        await tester.pumpAndSettle();
      }

      // Currently selected: WS → home + WS set.
      expectHomeWithWsTaskSet(container);

      // WS → REST-with-response: route stays home, button set flips.
      await select(restWithRespId);
      expectHomeWithHttpTaskSet(container);

      // Back to WS: WS set again.
      await select(wsId);
      expectHomeWithWsTaskSet(container);

      // And flip once more to prove it is not a one-shot.
      await select(restWithRespId);
      expectHomeWithHttpTaskSet(container);

      // REST-without-response leg: route falls back to the default page.
      await select(wsId);
      expectHomeWithWsTaskSet(container);
      await select(restNoRespId);
      expectDefaultPage(container);

      // …and back to WS lands on home with the WS set again.
      await select(wsId);
      expectHomeWithWsTaskSet(container);
    },
  );

  testWidgets('connecting a WS request while the window is open navigates '
      'default → home live', (tester) async {
    final container = await pumpDashbotWindow(tester);
    final notifier = container.read(collectionStateNotifierProvider.notifier);
    final id = container.read(selectedIdStateProvider)!;

    // Never-connected WS request: DashBot sits on the default page.
    notifier.update(id: id, apiType: APIType.websocket);
    notifier.update(
      id: id,
      wsRequestModel: const WebSocketRequestModel(
        url: 'wss://api.apidash.dev/ws/echo',
      ),
    );
    await tester.pumpAndSettle();
    expectDefaultPage(container);

    // Now "connect": mirror exactly what `_connectWebSocket` writes on a
    // successful connection — isStreaming true + a connected lifecycle
    // event appended to messageHistory — through the same notifier.
    final ws = container.read(selectedRequestModelProvider)!.wsRequestModel!;
    notifier.update(
      id: id,
      isStreaming: true,
      wsRequestModel: ws.copyWith(
        messageHistory: [
          ...ws.messageHistory,
          WebSocketMessage(
            payload: 'Connected to wss://api.apidash.dev/ws/echo',
            timestamp: DateTime(2026, 7, 7, 12),
            outgoing: false,
            messageType: WebSocketMessageType.connected,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // The open window must navigate to home with the WS task set, without
    // reopening — same live behavior HTTP gets when a response arrives.
    expectHomeWithWsTaskSet(container);
  });
}
