import 'dart:io';

import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/dashboard.dart';
import 'package:apidash/screens/home_page/home_page.dart';
import 'package:apidash/screens/intro_page.dart';
import 'package:apidash/screens/settings_page.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPathProviderPlatform extends Mock implements MethodChannel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');
    final MockPathProviderPlatform mock = MockPathProviderPlatform();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        // Create a mock app doc directory for testing
        Directory tempDir =
            await Directory.systemTemp.createTemp('mock_app_doc_dir');
        return tempDir.path; // Return the path to the mock directory
      }
      return null;
    });
    await openBoxes();
  });

  group('Testing navRailIndexStateProvider', () {
    testWidgets('Dashboard should display correct initial page',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Dashboard(),
          ),
        ),
      );

      // Verify that the HomePage is displayed initially
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(IntroPage), findsNothing);
      expect(find.byType(SettingsPage), findsNothing);
    });

    testWidgets(
        "Dashboard should display IntroPage when navRailIndexStateProvider is 1",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navRailIndexStateProvider.overrideWith((ref) => 1),
          ],
          child: const MaterialApp(
            home: Dashboard(),
          ),
        ),
      );

      // Verify that the IntroPage is displayed
      expect(find.byType(IntroPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(SettingsPage), findsNothing);
    });
    testWidgets(
        "Dashboard should display SettingsPage when navRailIndexStateProvider is 2",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navRailIndexStateProvider.overrideWith((ref) => 2),
          ],
          child: const MaterialApp(
            home: Dashboard(),
          ),
        ),
      );

      // Verify that the SettingsPage is displayed
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(IntroPage), findsNothing);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets(
        'Navigation Rail index should update when icon button is pressed',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Dashboard(),
          ),
        ),
      );

      // Tap on the Intro icon
      await tester.tap(find.byIcon(Icons.help_outline));
      await tester.pump();

      // Verify that the navRailIndexStateProvider is updated
      final dashboard = tester.element(find.byType(Dashboard));
      final container = ProviderScope.containerOf(dashboard);
      expect(container.read(navRailIndexStateProvider), 1);
    });

    testWidgets('Navigation Rail index should persist across widget rebuilds',
        (tester) async {
      // Pump the initial widget tree
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Dashboard(),
          ),
        ),
      );

      // Tap on the Settings icon to change the index to 2
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pump();

      // Rebuild the widget tree with the same ProviderScope
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Dashboard(),
          ),
        ),
      );

      // Verify that the navRailIndexStateProvider still has the updated value
      final dashboard = tester.element(find.byType(Dashboard));
      final container = ProviderScope.containerOf(dashboard);
      expect(container.read(navRailIndexStateProvider), 2);

      // Verify that the SettingsPage is still displayed after the rebuild
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(IntroPage), findsNothing);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets('UI should update correctly when Navigation Rail index changes',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Dashboard(),
          ),
        ),
      );

      // Grab the Dashboard widget and its ProviderContainer
      final dashboard = tester.element(find.byType(Dashboard));
      final container = ProviderScope.containerOf(dashboard);

      // Go to IntroPage
      container.read(navRailIndexStateProvider.notifier).state = 1;
      await tester.pump();

      // Verify that the IntroPage is displayed
      expect(find.byType(IntroPage), findsOneWidget);
      // Verify that the selected icon is the filled version (selectedIcon)
      expect(find.byIcon(Icons.help), findsOneWidget);

      // Go to SettingsPage
      container.read(navRailIndexStateProvider.notifier).state = 2;
      await tester.pump();

      // Verify that the SettingsPage is displayed
      expect(find.byType(SettingsPage), findsOneWidget);
      // Verify that the selected icon is the filled version (selectedIcon)
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });
}
