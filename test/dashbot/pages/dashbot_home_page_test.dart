import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/pages/pages.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/routes/routes.dart';
import 'package:apidash/dashbot/widgets/widgets.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widgets/action_buttons/test_utils.dart';

Finder _taskButton(String snippet) => find.byWidgetPredicate(
      (widget) =>
          widget is HomeScreenTaskButton && widget.label.contains(snippet),
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
  testWidgets('DashbotHomePage renders greeting and quick actions',
      (tester) async {
    await _pumpHomePage(tester, onRoute: (_, __) {});

    expect(find.textContaining('Hello there'), findsOneWidget);
    expect(find.textContaining('How can I help you today'), findsOneWidget);
    // Note: 'Chat with Dashbot' is only available in debug mode, so we don't test for it here
    expect(find.textContaining('Explain me this response'), findsOneWidget);
    expect(find.textContaining('Generate documentation'), findsOneWidget);
  });

  testWidgets('Chat with Dashbot button appears and works in debug mode',
      (tester) async {
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
    await tester.tap(find.descendant(
      of: buttonFinder,
      matching: find.byType(TextButton),
    ));
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

      await tester.tap(find.descendant(
        of: buttonFinder,
        matching: find.byType(TextButton),
      ));
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

      await tester.tap(find.descendant(
        of: buttonFinder,
        matching: find.byType(TextButton),
      ));
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

      await tester.tap(find.descendant(
        of: buttonFinder,
        matching: find.byType(TextButton),
      ));
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

      await tester.tap(find.descendant(
        of: buttonFinder,
        matching: find.byType(TextButton),
      ));
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

      await tester.tap(find.descendant(
        of: buttonFinder,
        matching: find.byType(TextButton),
      ));
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

      await tester.tap(find.descendant(
        of: buttonFinder,
        matching: find.byType(TextButton),
      ));
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

      await tester.tap(find.descendant(
        of: buttonFinder,
        matching: find.byType(TextButton),
      ));
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
  });

  testWidgets('Generate UI opens dialog and restores dashbot window',
      (tester) async {
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
}
