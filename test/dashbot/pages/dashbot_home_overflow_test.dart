import 'package:apidash/dashbot/pages/dashbot_home_page.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpHomePage(
  WidgetTester tester, {
  RequestModel? selectedModel,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        selectedRequestModelProvider.overrideWith((ref) => selectedModel),
      ],
      child: const MaterialApp(home: Scaffold(body: DashbotHomePage())),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('DashbotHomePage overflow regression', () {
    testWidgets('WS task set on a small surface scrolls instead of '
        'overflowing', (tester) async {
      // Surface far smaller than the 10-task WS button set needs.
      tester.view.physicalSize = const Size(360, 420);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final wsRequest = RequestModel(
        id: 'ws-overflow',
        apiType: APIType.websocket,
        wsRequestModel: const WebSocketRequestModel(
          url: 'wss://api.apidash.dev/ws/echo',
        ),
      );

      await _pumpHomePage(tester, selectedModel: wsRequest);

      // No RenderFlex overflow.
      expect(tester.takeException(), isNull);

      final scrollable = find.byType(SingleChildScrollView);
      expect(scrollable, findsOneWidget);

      // Content taller than the viewport scrolls without errors.
      await tester.drag(scrollable, const Offset(0, -200));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('REST request at default surface size lays out cleanly', (
      tester,
    ) async {
      final restRequest = RequestModel(
        id: 'req-1',
        httpRequestModel: const HttpRequestModel(),
      );

      await _pumpHomePage(tester, selectedModel: restRequest);

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
