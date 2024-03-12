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
  });
}
