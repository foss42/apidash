import 'dart:io';

import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/dashboard.dart';
import 'package:apidash/screens/home_page/collection_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/code_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/response_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_default.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/home_page/home_page.dart';
import 'package:apidash/screens/intro_page.dart';
import 'package:apidash/screens/settings_page.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:apidash/widgets/response_widgets.dart';
import 'package:apidash/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_consts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');
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
        'navRailIndexStateProvider should update when icon button is pressed',
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

    testWidgets(
        'navRailIndexStateProvider should persist across widget rebuilds',
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

    testWidgets(
        'UI should update correctly when navRailIndexStateProvider changes',
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

    testWidgets(
        'navRailIndexStateProvider should be disposed when Dashboard is removed',
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

      // Pumping a different widget to remove the Dashboard from the widget tree
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Text('Different Widget')),
        ),
      );

      // Verify that the ProviderContainer has been disposed
      // by trying to read from disposed container
      bool isDisposed = false;
      try {
        container.read(navRailIndexStateProvider);
      } catch (e) {
        isDisposed = true;
      }
      expect(isDisposed, true);
    });
  });

  group("Testing selectedIdEditStateProvider", () {
    testWidgets('It should have an initial value of null', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CollectionPane(),
            ),
          ),
        ),
      );

      // Verify that the initial value is null
      final collectionPane = tester.element(find.byType(CollectionPane));
      final container = ProviderScope.containerOf(collectionPane);
      expect(container.read(selectedIdEditStateProvider), null);
    });

    testWidgets(
        'selectedIdEditStateProvider should not be null after rename button has been tapped',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CollectionPane(),
            ),
          ),
        ),
      );

      // Tap on the three dots to open the request card menu
      await tester.tap(find.byType(RequestList));
      await tester.pump();
      await tester.tap(find.byType(RequestItem));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      // Tap on the "Rename" option in the menu
      await tester.tap(find.text('Rename'));
      await tester.pumpAndSettle();

      // Verify that the selectedIdEditStateProvider is not null
      final collectionPane = tester.element(find.byType(CollectionPane));
      final container = ProviderScope.containerOf(collectionPane);
      expect(container.read(selectedIdEditStateProvider), isNotNull);
      expect((container.read(selectedIdEditStateProvider)).runtimeType, String);
    });

    testWidgets(
        'It should be set back to null when user taps outside name editor',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CollectionPane(),
            ),
          ),
        ),
      );

      // Grab the CollectionPane widget and its ProviderContainer
      final collectionPane = tester.element(find.byType(CollectionPane));
      final container = ProviderScope.containerOf(collectionPane);

      // Tap on the three dots to open the request card menu
      await tester.tap(find.byType(RequestList));
      await tester.pump();
      await tester.tap(find.byType(RequestItem));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      // Tap on the "Rename" option in the menu
      await tester.tap(find.text('Rename'));
      await tester.pumpAndSettle();

      // Verify that the selectedIdEditStateProvider is not null
      expect(container.read(selectedIdEditStateProvider), isNotNull);
      expect((container.read(selectedIdEditStateProvider)).runtimeType, String);

      // Tap on the screen to simulate tapping outside the name editor
      await tester.tap(find.byType(CollectionPane));
      await tester.pumpAndSettle();

      // Verify that the selectedIdEditStateProvider is null
      expect(container.read(selectedIdEditStateProvider), null);
    });
    testWidgets("It should be properly disposed", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CollectionPane(),
            ),
          ),
        ),
      );

      // Grab the Dashboard widget and its ProviderContainer
      final collectionPane = tester.element(find.byType(CollectionPane));
      final container = ProviderScope.containerOf(collectionPane);

      // Pumping a different widget to remove the CollectionPane from the widget tree
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Text('Foo')),
        ),
      );

      // Verify that the ProviderContainer has been disposed
      // by trying to read from disposed container
      bool isDisposed = false;
      try {
        container.read(selectedIdEditStateProvider);
      } catch (e) {
        isDisposed = true;
      }
      expect(isDisposed, true);
    });
  });

  group('Testing codePaneVisibleStateProvider', () {
    testWidgets("It should have have an initial value of false",
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RequestEditorPane(),
          ),
        ),
      );

      // Verify that the initial value is false
      final editorPane = tester.element(find.byType(RequestEditorPane));
      final container = ProviderScope.containerOf(editorPane);
      expect(container.read(codePaneVisibleStateProvider), false);
    });

    testWidgets("When state is false ResponsePane should be visible",
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RequestEditorPane(),
          ),
        ),
      );

      expect(find.byType(RequestEditorDefault), findsOneWidget);

      // Tap on the "Plus New" button
      Finder plusNewButton = find.descendant(
        of: find.byType(RequestEditorDefault),
        matching: find.byType(ElevatedButton),
      );
      await tester.tap(plusNewButton);
      await tester.pump();

      // Verify that NotSentWidget is visible
      expect(find.byType(NotSentWidget), findsOneWidget);

      // Add some data in URLTextField
      Finder field = find.descendant(
        of: find.byType(URLField),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(field, kTestUrl);
      await tester.pump();

      // Tap on the "Send" button
      Finder sendButton = find.byType(SendButton);
      await tester.tap(sendButton);
      await tester.pump();

      final editorPane = tester.element(find.byType(RequestEditorPane));
      final container = ProviderScope.containerOf(editorPane);
      expect(container.read(codePaneVisibleStateProvider), false);
      expect(find.byType(ResponsePane), findsOneWidget);
    });

    testWidgets("When state is true CodePane should be visible",
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestEditorPane(),
            ),
          ),
        ),
      );

      expect(find.byType(RequestEditorDefault), findsOneWidget);

      // Tap on the "Plus New" button
      Finder plusNewButton = find.descendant(
        of: find.byType(RequestEditorDefault),
        matching: find.byType(ElevatedButton),
      );
      await tester.tap(plusNewButton);
      await tester.pump();

      // Verify that NotSentWidget is visible
      expect(find.byType(NotSentWidget), findsOneWidget);

      // Add some data in URLTextField
      Finder field = find.descendant(
        of: find.byType(URLField),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(field, kTestUrl);
      await tester.pump();

      // Tap on the "Send" button
      Finder sendButton = find.byType(SendButton);
      await tester.tap(sendButton);
      await tester.pump();

      final editorPane = tester.element(find.byType(RequestEditorPane));
      final container = ProviderScope.containerOf(editorPane);
      // Change codePaneVisibleStateProvider state to true
      container.read(codePaneVisibleStateProvider.notifier).state = true;
      await tester.pump();

      // Verify that the CodePane is visible
      expect(container.read(codePaneVisibleStateProvider), true);
      expect(find.byType(CodePane), findsOneWidget);
    });

    testWidgets("Hide/View Code button toggles the state", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestEditorPane(),
            ),
          ),
        ),
      );

      expect(find.byType(RequestEditorDefault), findsOneWidget);

      // Tap on the "Plus New" button
      Finder plusNewButton = find.descendant(
        of: find.byType(RequestEditorDefault),
        matching: find.byType(ElevatedButton),
      );
      await tester.tap(plusNewButton);
      await tester.pump();

      // Verify that NotSentWidget is visible
      expect(find.byType(NotSentWidget), findsOneWidget);

      // Add some data in URLTextField
      Finder field = find.descendant(
        of: find.byType(URLField),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(field, kTestUrl);
      await tester.pump();

      // Tap on the "Send" button
      Finder sendButton = find.byType(SendButton);
      await tester.tap(sendButton);
      await tester.pump();

      final editorPane = tester.element(find.byType(RequestEditorPane));
      final container = ProviderScope.containerOf(editorPane);
      final bool currentValue = container.read(codePaneVisibleStateProvider);

      // Click on View Code button
      await tester.tap(find.byIcon(Icons.code_rounded));
      await tester.pump();

      // Verify that the state value has changed
      expect(container.read(codePaneVisibleStateProvider), !currentValue);
      final bool newValue = container.read(codePaneVisibleStateProvider);

      // Click on Hide Code button
      await tester.tap(find.byIcon(Icons.code_off_rounded));
      await tester.pump();

      // Verify that the state value has changed
      expect(container.read(codePaneVisibleStateProvider), !newValue);
    });

    testWidgets("That state persists across widget rebuilds", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestEditorPane(),
            ),
          ),
        ),
      );

      expect(find.byType(RequestEditorDefault), findsOneWidget);

      // Tap on the "Plus New" button
      Finder plusNewButton = find.descendant(
        of: find.byType(RequestEditorDefault),
        matching: find.byType(ElevatedButton),
      );
      await tester.tap(plusNewButton);
      await tester.pump();

      // Verify that NotSentWidget is visible
      expect(find.byType(NotSentWidget), findsOneWidget);

      // Add some data in URLTextField
      Finder field = find.descendant(
        of: find.byType(URLField),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(field, kTestUrl);
      await tester.pump();

      // Tap on the "Send" button
      Finder sendButton = find.byType(SendButton);
      await tester.tap(sendButton);
      await tester.pump();

      final editorPane = tester.element(find.byType(RequestEditorPane));
      final container = ProviderScope.containerOf(editorPane);
      final bool currentValue = container.read(codePaneVisibleStateProvider);

      // Click on View Code button
      await tester.tap(find.byIcon(Icons.code_rounded));
      await tester.pump();

      // Verify that the state value has changed
      expect(container.read(codePaneVisibleStateProvider), !currentValue);
      bool matcher = !currentValue;

      // Rebuild the widget tree
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestEditorPane(),
            ),
          ),
        ),
      );

      // Verify that the value of codePaneVisibleStateProvider is still true
      final containerAfterRebuild = ProviderScope.containerOf(editorPane);
      bool actual = containerAfterRebuild.read(codePaneVisibleStateProvider);
      expect(actual, matcher);
    });

    testWidgets("That it is properly disposed", (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestEditorPane(),
            ),
          ),
        ),
      );

      // Verify that codePaneVisibleStateProvider is present
      final editorPane = tester.element(find.byType(RequestEditorPane));
      final container = ProviderScope.containerOf(editorPane);
      expect(container.read(codePaneVisibleStateProvider).runtimeType, bool);

      // Update the widget tree to dispose the provider
      await tester.pumpWidget(const MaterialApp());

      // Verify that the provider was disposed
      expect(() => container.read(codePaneVisibleStateProvider),
          throwsA(isA<StateError>()));
      expect(
        () => container.read(codePaneVisibleStateProvider),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('was already disposed'),
          ),
        ),
      );
    });
  });
}
