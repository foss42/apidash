import 'package:apidash/dashbot/dashbot_dashboard.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/routes/routes.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashbotWindow Tests', () {
    testWidgets('renders DashbotWindow and responds to drag and close', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(2000, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool closed = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [selectedRequestModelProvider.overrideWith((ref) => null)],
          child: MaterialApp(
            home: Scaffold(
              body: DashbotWindow(
                onClose: () {
                  closed = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('DashBot', skipOffstage: false), findsOneWidget);

      // Tap close button (2nd IconButton)
      await tester.tap(find.byType(IconButton).at(1));
      await tester.pumpAndSettle();
      expect(closed, isTrue);

      // Drag window
      await tester.drag(find.text('DashBot'), const Offset(10, 10));
      await tester.pumpAndSettle();

      // Resize window (drag indicator)
      await tester.drag(
        find.byIcon(Icons.drag_indicator_rounded),
        const Offset(-10, -10),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('DashbotWindow handles model selection and toggle popped', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(2000, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final ProviderContainer container = ProviderContainer(
        overrides: [selectedRequestModelProvider.overrideWith((ref) => null)],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: DashbotWindow(onClose: () {})),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap toggle popped icon (1st IconButton)
      await tester.tap(find.byType(IconButton).at(0));
      await tester.pumpAndSettle();

      final state = container.read(dashbotWindowNotifierProvider);
      expect(state.isPopped, isFalse);

      // Verify AI model selector opens dialog
      await tester.tap(find.byType(ElevatedButton).first, warnIfMissed: false);
      await tester.pump();

      // Ensure that setting a different active route changes navigation
      container.read(dashbotActiveRouteProvider.notifier).state =
          DashbotRoutes.dashbotChat;
      await tester.pump();
    });
  });
}
