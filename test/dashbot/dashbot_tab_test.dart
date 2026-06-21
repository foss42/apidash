import 'package:apidash/dashbot/dashbot_tab.dart';
import 'package:apidash/dashbot/models/dashbot_window_model.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/routes/routes.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDashbotActiveRouteNotifier extends DashbotActiveRouteNotifier {
  @override
  String build() {
    return DashbotRoutes.dashbotDefault;
  }
}

void main() {
  group('DashbotTab Tests', () {
    testWidgets('renders DashbotTab correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashbotActiveRouteProvider.overrideWith(() => MockDashbotActiveRouteNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DashbotTab(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(DashbotTab), findsOneWidget);
      expect(find.byType(ADIconButton), findsWidgets);
    });

    testWidgets('toggles popped window correctly', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashbotWindowNotifierProvider.overrideWith((ref) => DashbotWindowNotifier()),
          dashbotActiveRouteProvider.overrideWith(() => MockDashbotActiveRouteNotifier()),
        ],
      );
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: DashbotTab(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      final closeFullscreenBtn = find.widgetWithIcon(ADIconButton, Icons.close_fullscreen);
      expect(closeFullscreenBtn, findsOneWidget);

      final button = tester.widget<ADIconButton>(closeFullscreenBtn);
      button.onPressed?.call();
      await tester.pump();
      
      expect(container.read(dashbotWindowNotifierProvider).isPopped, false);
    });

    testWidgets('toggles active window correctly on close', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashbotWindowNotifierProvider.overrideWith((ref) => DashbotWindowNotifier()..toggleActive()),
          dashbotActiveRouteProvider.overrideWith(() => MockDashbotActiveRouteNotifier()),
        ],
      );
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: DashbotTab(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      final closeBtn = find.widgetWithIcon(ADIconButton, Icons.close);
      expect(closeBtn, findsOneWidget);

      final button = tester.widget<ADIconButton>(closeBtn);
      button.onPressed?.call();
      await tester.pump();
      
      expect(container.read(dashbotWindowNotifierProvider).isActive, false);
      expect(container.read(dashbotWindowNotifierProvider).isPopped, false);
    });

    testWidgets('navigates when route provider changes', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dashbotActiveRouteProvider.overrideWith(() => MockDashbotActiveRouteNotifier()),
        ],
      );
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: DashbotTab(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      container.read(dashbotActiveRouteProvider.notifier).state = DashbotRoutes.dashbotHome;
      await tester.pumpAndSettle();
      
      expect(find.byType(DashbotTab), findsOneWidget);
    });
  });
}
