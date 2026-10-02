import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/code_pane.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  HistoryRequestModel historyEntry(
    String id,
    APIType apiType, {
    WebSocketRequestModel? ws,
    MQTTRequestModel? mqtt,
  }) => HistoryRequestModel(
    historyId: id,
    metaData: HistoryMetaModel(
      historyId: id,
      requestId: 'req-$id',
      timeStamp: DateTime.now(),
      method: HTTPVerb.get,
      url: 'example.com',
      apiType: apiType,
      responseStatus: 200,
    ),
    wsRequestModel: ws,
    mqttRequestModel: mqtt,
  );

  Future<void> pumpHistoryCodePane(
    WidgetTester tester,
    HistoryRequestModel entry,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedHistoryRequestModelProvider.overrideWith((ref) => entry),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CodePane(isHistoryRequest: true)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('editor WebSocket code pane keeps the not-available card', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith(
            (ref) => RequestModel(
              id: 'ws-1',
              apiType: APIType.websocket,
              wsRequestModel: const WebSocketRequestModel(url: 'wss://a.b'),
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: CodePane())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(kMsgCodegenWebSocketNotAvailable), findsOneWidget);
    expect(find.text('Raise Issue'), findsOneWidget);
    expect(find.text(kLabelGenerateCodeDashbot), findsNothing);
  });

  testWidgets('history WebSocket code pane offers DashBot codegen', (
    tester,
  ) async {
    await pumpHistoryCodePane(
      tester,
      historyEntry(
        'h-ws',
        APIType.websocket,
        ws: const WebSocketRequestModel(url: 'wss://a.b'),
      ),
    );

    expect(
      find.text('Code for WebSocket requests is generated with DashBot.'),
      findsOneWidget,
    );
    expect(find.text(kLabelGenerateCodeDashbot), findsOneWidget);
    expect(find.text('Raise Issue'), findsNothing);
  });

  testWidgets('history MQTT code pane offers DashBot codegen', (
    tester,
  ) async {
    await pumpHistoryCodePane(
      tester,
      historyEntry(
        'h-mqtt',
        APIType.mqtt,
        mqtt: const MQTTRequestModel(brokerUrl: 'broker.example'),
      ),
    );

    expect(find.text(APIType.mqtt.codegenViaDashbotMessage), findsOneWidget);
    expect(find.text(kLabelGenerateCodeDashbot), findsOneWidget);
    expect(find.text('Raise Issue'), findsNothing);
  });
}
