import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/pages/pages.dart';
import 'package:apidash/dashbot/routes/routes.dart';
import 'package:apidash/dashbot/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

Finder _taskButton(String snippet) => find.byWidgetPredicate(
      (widget) =>
          widget is HomeScreenTaskButton && widget.label.contains(snippet),
    );

void main() {
  testWidgets('DashbotDefaultPage renders greeting and actions',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashbotDefaultPage()));

    expect(find.textContaining('Hello there'), findsOneWidget);
    expect(find.textContaining('make one'), findsOneWidget);
    expect(find.textContaining('Open Chat'), findsOneWidget);
    expect(find.textContaining('Import cURL'), findsOneWidget);
    expect(find.textContaining('Import OpenAPI'), findsOneWidget);
  });

  testWidgets('Open Chat button pushes chat route without arguments',
      (tester) async {
    final observer = RecordingNavigatorObserver();
    Object? capturedArgs;

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [observer],
        onGenerateRoute: (settings) {
          if (settings.name == DashbotRoutes.dashbotChat) {
            capturedArgs = settings.arguments;
          }
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const SizedBox.shrink(),
          );
        },
        home: const DashbotDefaultPage(),
      ),
    );
    await tester.pump();

    final openChatButton = _taskButton('Open Chat');
    expect(openChatButton, findsOneWidget);
    await tester.tap(find.descendant(
      of: openChatButton,
      matching: find.byType(TextButton),
    ));
    await tester.pumpAndSettle();

    expect(observer.lastRoute?.settings.name, DashbotRoutes.dashbotChat);
    expect(capturedArgs, isNull);
  });

  group('Import buttons push chat route with correct arguments', () {
    testWidgets('Import cURL button', (tester) async {
      final observer = RecordingNavigatorObserver();
      Object? capturedArgs;

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          onGenerateRoute: (settings) {
            if (settings.name == DashbotRoutes.dashbotChat) {
              capturedArgs = settings.arguments;
            }
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const SizedBox.shrink(),
            );
          },
          home: const DashbotDefaultPage(),
        ),
      );
      await tester.pump();

      final importCurlButton = _taskButton('Import cURL');
      expect(importCurlButton, findsOneWidget);
      await tester.tap(find.descendant(
        of: importCurlButton,
        matching: find.byType(TextButton),
      ));
      await tester.pumpAndSettle();

      expect(observer.lastRoute?.settings.name, DashbotRoutes.dashbotChat);
      expect(capturedArgs, ChatMessageType.importCurl);
    });

    testWidgets('Import OpenAPI button', (tester) async {
      final observer = RecordingNavigatorObserver();
      Object? capturedArgs;

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          onGenerateRoute: (settings) {
            if (settings.name == DashbotRoutes.dashbotChat) {
              capturedArgs = settings.arguments;
            }
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const SizedBox.shrink(),
            );
          },
          home: const DashbotDefaultPage(),
        ),
      );
      await tester.pump();

      final importOpenApiButton = _taskButton('Import OpenAPI');
      expect(importOpenApiButton, findsOneWidget);
      await tester.tap(find.descendant(
        of: importOpenApiButton,
        matching: find.byType(TextButton),
      ));
      await tester.pumpAndSettle();

      expect(observer.lastRoute?.settings.name, DashbotRoutes.dashbotChat);
      expect(capturedArgs, ChatMessageType.importOpenApi);
    });
  });
}
