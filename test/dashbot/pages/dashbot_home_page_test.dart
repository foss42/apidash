import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/pages/pages.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/routes/routes.dart';
import 'package:apidash/dashbot/widgets/widgets.dart';
import 'package:apidash/models/mqtt_request_model.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widgets/action_buttons/test_utils.dart';

Finder _taskButton(String snippet) => find.byWidgetPredicate(
  (widget) => widget is HomeScreenTaskButton && widget.label.contains(snippet),
);

Future<RecordingDashbotWindowNotifier> _pumpHomePage(
  WidgetTester tester, {
  RequestModel? selectedModel,
  void Function(String? name, Object? arguments)? onRoute,
}) async {
  final windowNotifier = RecordingDashbotWindowNotifier();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dashbotWindowNotifierProvider.overrideWith((ref) => windowNotifier),
        selectedRequestModelProvider.overrideWith((ref) => selectedModel),
      ],
      child: MaterialApp(
        onGenerateRoute: (settings) {
          onRoute?.call(settings.name, settings.arguments);
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const SizedBox.shrink(),
          );
        },
        home: const Scaffold(body: DashbotHomePage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return windowNotifier;
}

void main() {
  testWidgets('DashbotHomePage renders greeting and quick actions', (
    tester,
  ) async {
    await _pumpHomePage(tester, onRoute: (_, __) {});

    expect(find.textContaining('Hello there'), findsOneWidget);
    expect(find.textContaining('How can I help you today'), findsOneWidget);
    // Note: 'Chat with Dashbot' is only available in debug mode, so we don't test for it here
    expect(find.textContaining('Explain me this response'), findsOneWidget);
    expect(find.textContaining('Generate documentation'), findsOneWidget);
  });

  testWidgets('Chat with Dashbot button appears and works in debug mode', (
    tester,
  ) async {
    // In debug mode (which tests run in), the button should be present
    String? capturedRoute;
    Object? capturedArgs;

    await _pumpHomePage(
      tester,
      onRoute: (name, arguments) {
        capturedRoute = name;
        capturedArgs = arguments;
      },
    );

    // The button should be visible in debug mode
    final buttonFinder = _taskButton('Chat with Dashbot');
    expect(buttonFinder, findsOneWidget);

    // Tap the button
    await tester.tap(
      find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
    );
    await tester.pumpAndSettle();

    // Should navigate to chat without any initial task arguments
    expect(capturedRoute, DashbotRoutes.dashbotChat);
    expect(capturedArgs, isNull);
  });

  group('Quick action buttons navigate with correct arguments', () {
    testWidgets('Explain me this response button', (tester) async {
      String? capturedRoute;
      Object? capturedArgs;

      await _pumpHomePage(
        tester,
        onRoute: (name, arguments) {
          capturedRoute = name;
          capturedArgs = arguments;
        },
      );

      final buttonFinder = _taskButton('Explain me this response');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(
        find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
      );
      await tester.pumpAndSettle();

      expect(capturedRoute, DashbotRoutes.dashbotChat);
      expect(capturedArgs, ChatMessageType.explainResponse);
    });

    testWidgets('Help me debug this error button', (tester) async {
      String? capturedRoute;
      Object? capturedArgs;

      await _pumpHomePage(
        tester,
        onRoute: (name, arguments) {
          capturedRoute = name;
          capturedArgs = arguments;
        },
      );

      final buttonFinder = _taskButton('Help me debug this error');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(
        find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
      );
      await tester.pumpAndSettle();

      expect(capturedRoute, DashbotRoutes.dashbotChat);
      expect(capturedArgs, ChatMessageType.debugError);
    });

    testWidgets('Generate documentation button', (tester) async {
      String? capturedRoute;
      Object? capturedArgs;

      await _pumpHomePage(
        tester,
        onRoute: (name, arguments) {
          capturedRoute = name;
          capturedArgs = arguments;
        },
      );

      final buttonFinder = _taskButton('Generate documentation');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(
        find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
      );
      await tester.pumpAndSettle();

      expect(capturedRoute, DashbotRoutes.dashbotChat);
      expect(capturedArgs, ChatMessageType.generateDoc);
    });

    testWidgets('Generate Tests button', (tester) async {
      String? capturedRoute;
      Object? capturedArgs;

      await _pumpHomePage(
        tester,
        onRoute: (name, arguments) {
          capturedRoute = name;
          capturedArgs = arguments;
        },
      );

      final buttonFinder = _taskButton('Generate Tests');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(
        find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
      );
      await tester.pumpAndSettle();

      expect(capturedRoute, DashbotRoutes.dashbotChat);
      expect(capturedArgs, ChatMessageType.generateTest);
    });

    testWidgets('Generate Code button', (tester) async {
      String? capturedRoute;
      Object? capturedArgs;

      await _pumpHomePage(
        tester,
        onRoute: (name, arguments) {
          capturedRoute = name;
          capturedArgs = arguments;
        },
      );

      final buttonFinder = _taskButton('Generate Code');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(
        find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
      );
      await tester.pumpAndSettle();

      expect(capturedRoute, DashbotRoutes.dashbotChat);
      expect(capturedArgs, ChatMessageType.generateCode);
    });

    testWidgets('Import cURL button', (tester) async {
      String? capturedRoute;
      Object? capturedArgs;

      await _pumpHomePage(
        tester,
        onRoute: (name, arguments) {
          capturedRoute = name;
          capturedArgs = arguments;
        },
      );

      final buttonFinder = _taskButton('Import cURL');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(
        find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
      );
      await tester.pumpAndSettle();

      expect(capturedRoute, DashbotRoutes.dashbotChat);
      expect(capturedArgs, ChatMessageType.importCurl);
    });

    testWidgets('Import OpenAPI button', (tester) async {
      String? capturedRoute;
      Object? capturedArgs;

      await _pumpHomePage(
        tester,
        onRoute: (name, arguments) {
          capturedRoute = name;
          capturedArgs = arguments;
        },
      );

      final buttonFinder = _taskButton('Import OpenAPI');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(
        find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
      );
      await tester.pumpAndSettle();

      expect(capturedRoute, DashbotRoutes.dashbotChat);
      expect(capturedArgs, ChatMessageType.importOpenApi);
    });
  });

  testWidgets(
    'Generate Tool hides and shows dashbot window even without response',
    (tester) async {
      final notifier = await _pumpHomePage(tester, onRoute: (_, __) {});

      await tester.tap(find.text('🛠️ Generate Tool'));
      await tester.pumpAndSettle();

      expect(notifier.hideCalls, 1);
      expect(notifier.showCalls, 1);
    },
  );

  testWidgets('Generate UI opens dialog and restores dashbot window', (
    tester,
  ) async {
    final responseModel = const HttpResponseModel(
      body: 'example response',
      formattedBody: 'formatted',
    );
    final requestModel = RequestModel(
      id: 'req-1',
      httpRequestModel: const HttpRequestModel(),
      httpResponseModel: responseModel,
    );

    final notifier = await _pumpHomePage(
      tester,
      selectedModel: requestModel,
      onRoute: (_, __) {},
    );

    await tester.tap(find.text('📱 Generate UI'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);

    final dialogElement = find.byType(Dialog);
    if (dialogElement.evaluate().isNotEmpty) {
      Navigator.of(dialogElement.evaluate().first).pop();
      await tester.pumpAndSettle();
    }

    expect(notifier.hideCalls, 1);
    expect(notifier.showCalls, 1);
  });

  testWidgets('Generate UI uses sseOutput if available', (tester) async {
    final responseModel = const HttpResponseModel(
      sseOutput: ['event1', 'event2'],
    );
    final requestModel = RequestModel(
      id: 'req-2',
      httpRequestModel: const HttpRequestModel(),
      httpResponseModel: responseModel,
    );

    final notifier = await _pumpHomePage(
      tester,
      selectedModel: requestModel,
      onRoute: (_, __) {},
    );

    await tester.tap(find.text('📱 Generate UI'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);

    final dialogElement = find.byType(Dialog);
    if (dialogElement.evaluate().isNotEmpty) {
      Navigator.of(dialogElement.evaluate().first).pop();
      await tester.pumpAndSettle();
    }

    expect(notifier.hideCalls, 1);
    expect(notifier.showCalls, 1);
  });

  group('DashbotHomePage WebSocket task set', () {
    final wsRequest = RequestModel(
      id: 'ws-1',
      apiType: APIType.websocket,
      wsRequestModel: const WebSocketRequestModel(
        url: 'wss://api.apidash.dev/ws/echo',
      ),
    );

    // Label -> chat route argument, verified against
    // lib/dashbot/pages/dashbot_home_page.dart.
    const wsRouteArgs = {
      '🔌 Explain this connection': ChatMessageType.explainWsConnection,
      '🛠️ Help me fix my connection': ChatMessageType.debugWsConnection,
      '📡 What is the server sending?': ChatMessageType.summarizeWsMessages,
      '🔍 Find in messages': ChatMessageType.findInWsMessages,
      '✉️ Explain my message': ChatMessageType.explainWsMessage,
      '❓ Why did my message fail?': ChatMessageType.debugWsMessage,
      '❤️ Connection health': ChatMessageType.wsConnectionHealth,
      '📄 Generate documentation': ChatMessageType.generateWsDoc,
      '📝 Generate Tests': ChatMessageType.generateWsTest,
      '🧩 Generate Code': ChatMessageType.generateWsCode,
    };

    void useLargeSurface(WidgetTester tester) {
      tester.view.physicalSize = const Size(1400, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('WS request shows all WS quick actions, no HTTP-only ones', (
      tester,
    ) async {
      useLargeSurface(tester);
      await _pumpHomePage(tester, selectedModel: wsRequest, onRoute: (_, _) {});

      for (final label in wsRouteArgs.keys) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      // Shared tasks stay available.
      expect(find.text('📥 Import cURL'), findsOneWidget);
      expect(find.text('📄 Import OpenAPI'), findsOneWidget);
      expect(find.text('🛠️ Generate Tool'), findsOneWidget);
      // HTTP-only tasks are hidden for WS.
      expect(find.text('🔎 Explain me this response'), findsNothing);
      expect(find.text('🐞 Help me debug this error'), findsNothing);
      expect(find.text('📱 Generate UI'), findsNothing);
    });

    testWidgets('WS quick actions navigate to chat with the task argument', (
      tester,
    ) async {
      useLargeSurface(tester);

      for (final entry in wsRouteArgs.entries) {
        String? capturedRoute;
        Object? capturedArgs;

        // Fresh tree per button: unmount first so the Navigator stack from
        // the previous tap is not reused by element preservation.
        await tester.pumpWidget(const SizedBox.shrink());
        await _pumpHomePage(
          tester,
          selectedModel: wsRequest,
          onRoute: (name, arguments) {
            capturedRoute = name;
            capturedArgs = arguments;
          },
        );

        final buttonFinder = _taskButton(entry.key);
        expect(buttonFinder, findsOneWidget, reason: entry.key);

        await tester.tap(
          find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
        );
        await tester.pumpAndSettle();

        expect(capturedRoute, DashbotRoutes.dashbotChat, reason: entry.key);
        expect(capturedArgs, entry.value, reason: entry.key);
      }
    });

    testWidgets('REST request keeps HTTP quick actions, no WS labels', (
      tester,
    ) async {
      useLargeSurface(tester);
      final restRequest = RequestModel(
        id: 'rest-1',
        httpRequestModel: const HttpRequestModel(),
      );
      await _pumpHomePage(
        tester,
        selectedModel: restRequest,
        onRoute: (_, _) {},
      );

      expect(find.text('🔎 Explain me this response'), findsOneWidget);
      expect(find.text('🐞 Help me debug this error'), findsOneWidget);
      expect(find.text('📄 Generate documentation'), findsOneWidget);
      expect(find.text('📝 Generate Tests'), findsOneWidget);
      expect(find.text('🧩 Generate Code'), findsOneWidget);
      expect(find.text('📱 Generate UI'), findsOneWidget);
      for (final label in [
        '🔌 Explain this connection',
        '🛠️ Help me fix my connection',
        '📡 What is the server sending?',
        '🔍 Find in messages',
        '✉️ Explain my message',
        '❓ Why did my message fail?',
        '❤️ Connection health',
      ]) {
        expect(find.text(label), findsNothing, reason: label);
      }
    });
  });

  group('DashbotHomePage MQTT task set', () {
    final mqttRequest = RequestModel(
      id: 'mqtt-1',
      apiType: APIType.mqtt,
      mqttRequestModel: const MQTTRequestModel(brokerUrl: 'test.mosquitto.org'),
    );

    // Label -> chat route argument, verified against
    // lib/dashbot/pages/dashbot_home_page.dart.
    const mqttRouteArgs = {
      '🔌 Explain this connection': ChatMessageType.explainMqttConnection,
      '🛠️ Help me fix my connection': ChatMessageType.debugMqttConnection,
      '📭 Why am I not receiving messages?': ChatMessageType.whyNoMqttMessages,
      '📊 What\'s on my topics?': ChatMessageType.summarizeMqttMessages,
      '🌳 Topics & wildcards': ChatMessageType.explainMqttTopics,
      '💾 Session & offline messages': ChatMessageType.mqttSessionAdvisor,
      '🧩 Generate Code': ChatMessageType.generateMqttCode,
      '📜 Last Will': ChatMessageType.explainMqttLwt,
      '✨ v5 features': ChatMessageType.explainMqttV5,
      '🔍 Find in messages': ChatMessageType.findInMqttMessages,
    };

    void useLargeSurface(WidgetTester tester) {
      tester.view.physicalSize = const Size(1400, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('MQTT request shows MQTT quick actions, no WS/HTTP-only ones', (
      tester,
    ) async {
      useLargeSurface(tester);
      await _pumpHomePage(
        tester,
        selectedModel: mqttRequest,
        onRoute: (_, _) {},
      );

      for (final label in mqttRouteArgs.keys) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      // Shared tasks stay available.
      expect(find.text('📥 Import cURL'), findsOneWidget);
      expect(find.text('📄 Import OpenAPI'), findsOneWidget);
      expect(find.text('🛠️ Generate Tool'), findsOneWidget);
      // HTTP-only and WS-only tasks are hidden for MQTT.
      expect(find.text('🔎 Explain me this response'), findsNothing);
      expect(find.text('🐞 Help me debug this error'), findsNothing);
      expect(find.text('📱 Generate UI'), findsNothing);
      expect(find.text('📡 What is the server sending?'), findsNothing);
      expect(find.text('❤️ Connection health'), findsNothing);
    });

    testWidgets('MQTT quick actions navigate to chat with the task argument', (
      tester,
    ) async {
      useLargeSurface(tester);

      for (final entry in mqttRouteArgs.entries) {
        String? capturedRoute;
        Object? capturedArgs;

        await tester.pumpWidget(const SizedBox.shrink());
        await _pumpHomePage(
          tester,
          selectedModel: mqttRequest,
          onRoute: (name, arguments) {
            capturedRoute = name;
            capturedArgs = arguments;
          },
        );

        final buttonFinder = _taskButton(entry.key);
        expect(buttonFinder, findsOneWidget, reason: entry.key);

        await tester.tap(
          find.descendant(of: buttonFinder, matching: find.byType(TextButton)),
        );
        await tester.pumpAndSettle();

        expect(capturedRoute, DashbotRoutes.dashbotChat, reason: entry.key);
        expect(capturedArgs, entry.value, reason: entry.key);
      }
    });
  });
}
