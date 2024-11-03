//import 'package:spot/spot.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/screens/dashboard.dart';
import 'package:apidash/screens/envvar/environment_page.dart';
import 'package:apidash/screens/home_page/collection_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/response_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_default.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/home_page/home_page.dart';
import 'package:apidash/screens/settings_page.dart';
import 'package:apidash/screens/history/history_page.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../extensions/widget_tester_extensions.dart';
import '../test_consts.dart';
import 'helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
    // FIXME: Font file moved to design system so this must be fixed if spot screenshot is used
    // final flamante = rootBundle.load('google_fonts/OpenSans-Medium.ttf');
    // final fontLoader = FontLoader('OpenSans')..addFont(flamante);
    // await fontLoader.load();
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
      expect(find.byType(EnvironmentPage), findsNothing);
      expect(find.byType(HistoryPage), findsNothing);
      expect(find.byType(SettingsPage), findsNothing);
    });

    testWidgets(
        "Dashboard should display EnvironmentPage when navRailIndexStateProvider is 1",
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

      // Verify that the EnvironmentPage is displayed
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(EnvironmentPage), findsOneWidget);
      expect(find.byType(HistoryPage), findsNothing);
      expect(find.byType(SettingsPage), findsNothing);
    });

    testWidgets(
        "Dashboard should display HistorPage when navRailIndexStateProvider is 2",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navRailIndexStateProvider.overrideWith((ref) => 2),
          ],
          child: const Portal(
            child: MaterialApp(
              home: Dashboard(),
            ),
          ),
        ),
      );

      // Verify that the SettingsPage is displayed
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(EnvironmentPage), findsNothing);
      expect(find.byType(HistoryPage), findsOneWidget);
      expect(find.byType(SettingsPage), findsNothing);
    });
    testWidgets(
        "Dashboard should display SettingsPage when navRailIndexStateProvider is 3",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navRailIndexStateProvider.overrideWith((ref) => 3),
          ],
          child: const Portal(
            child: MaterialApp(
              home: Dashboard(),
            ),
          ),
        ),
      );

      // Verify that the SettingsPage is displayed
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(EnvironmentPage), findsNothing);
      expect(find.byType(HistoryPage), findsNothing);
      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets(
        'navRailIndexStateProvider should update when icon button is pressed',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: Portal(
            child: MaterialApp(
              home: Dashboard(),
            ),
          ),
        ),
      );

      // Tap on the Settings icon
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pump();

      // Verify that the navRailIndexStateProvider is updated
      final dashboard = tester.element(find.byType(Dashboard));
      final container = ProviderScope.containerOf(dashboard);
      expect(container.read(navRailIndexStateProvider), 3);
    });

    testWidgets(
        'navRailIndexStateProvider should persist across widget rebuilds',
        (tester) async {
      // Pump the initial widget tree
      await tester.pumpWidget(
        const ProviderScope(
          child: Portal(
            child: MaterialApp(
              home: Dashboard(),
            ),
          ),
        ),
      );

      // Tap on the Settings icon to change the index to 3
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pump();

      // Rebuild the widget tree with the same ProviderScope
      await tester.pumpWidget(
        const ProviderScope(
          child: Portal(
            child: MaterialApp(
              home: Dashboard(),
            ),
          ),
        ),
      );

      // Verify that the navRailIndexStateProvider still has the updated value
      final dashboard = tester.element(find.byType(Dashboard));
      final container = ProviderScope.containerOf(dashboard);
      expect(container.read(navRailIndexStateProvider), 3);

      // Verify that the SettingsPage is still displayed after the rebuild
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(EnvironmentPage), findsNothing);
    });

    testWidgets(
        'UI should update correctly when navRailIndexStateProvider changes',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: Portal(
            child: MaterialApp(
              home: Dashboard(),
            ),
          ),
        ),
      );

      // Grab the Dashboard widget and its ProviderContainer
      final dashboard = tester.element(find.byType(Dashboard));
      final container = ProviderScope.containerOf(dashboard);

      // Go to EnvironmentPage
      container.read(navRailIndexStateProvider.notifier).state = 1;
      await tester.pump();

      // Verify that the EnvironmentPage is displayed
      expect(find.byType(EnvironmentPage), findsOneWidget);
      // Verify that the selected icon is the filled version (selectedIcon)
      expect(find.byIcon(Icons.laptop_windows), findsOneWidget);

      // Go to HistoryPage
      container.read(navRailIndexStateProvider.notifier).state = 2;
      await tester.pump();

      // Verify that the HistoryPage is displayed
      expect(find.byType(HistoryPage), findsOneWidget);
      // Verify that the selected icon is the filled version (selectedIcon)
      expect(find.byIcon(Icons.history_rounded), findsOneWidget);

      // Go to SettingsPage
      container.read(navRailIndexStateProvider.notifier).state = 3;
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
          child: Portal(
            child: MaterialApp(
              home: Dashboard(),
            ),
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
        'selectedIdEditStateProvider should not be null after Duplicate button has been tapped',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(
              fontFamily: 'OpenSans',
            ),
            home: const Scaffold(
              body: CollectionPane(),
            ),
          ),
        ),
      );

      final collectionPane = tester.element(find.byType(CollectionPane));
      final container = ProviderScope.containerOf(collectionPane);
      var orig = container.read(selectedIdStateProvider);
      expect(orig, isNotNull);

      // Tap on the three dots to open the request card menu
      await tester.tap(find.byType(RequestList));
      await tester.pump();
      await tester.tap(find.byType(RequestItem));
      await tester.pump();
      //await tester.tap(find.byIcon(Icons.more_vert).at(1));
      await tester.tap(
        find.byType(RequestItem),
        buttons: kSecondaryButton,
      );
      await tester.pumpAndSettle();

      // Tap on the "Duplicate" option in the menu
      var byType = find.text('Duplicate', findRichText: true);
      expect(byType, findsOneWidget);

      await tester.tap(byType);
      await tester.pumpAndSettle();
      // INFO: Screenshot using spot
      // await takeScreenshot();

      var dupId = container.read(selectedIdStateProvider);
      expect(dupId, isNotNull);
      expect(dupId.runtimeType, String);
      expect(dupId != orig, isTrue);
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
      await tester.tap(find.byIcon(Icons.more_vert).at(1));
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
      await tester.setScreenSize(largeWidthDevice);
      await tester.pumpWidget(
        const ProviderScope(
          child: Portal(
            child: MaterialApp(
              home: Material(
                child: RequestEditorPane(),
              ),
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
        of: find.byType(EnvURLField),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(field);
      tester.testTextInput.enterText(kTestUrl);
      await tester.pump();

      // Tap on the "Send" button
      Finder sendButton = find.byType(SendRequestButton);
      await tester.tap(sendButton);
      await tester.pump();

      final editorPane = tester.element(find.byType(RequestEditorPane));
      final container = ProviderScope.containerOf(editorPane);
      expect(container.read(codePaneVisibleStateProvider), false);
      expect(find.byType(ResponsePane), findsOneWidget);
    });

    testWidgets("When state is true CodePane should be visible",
        (tester) async {
      await tester.setScreenSize(largeWidthDevice);
      await tester.pumpWidget(
        const ProviderScope(
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: RequestEditorPane(),
              ),
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
        of: find.byType(EnvURLField),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(field);
      tester.testTextInput.enterText(kTestUrl);
      await tester.pump();

      // Tap on the "Send" button
      Finder sendButton = find.byType(SendRequestButton);
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
      await tester.setScreenSize(largeWidthDevice);
      await tester.pumpWidget(
        const ProviderScope(
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: RequestEditorPane(),
              ),
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
        of: find.byType(EnvURLField),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(field);
      tester.testTextInput.enterText(kTestUrl);
      await tester.pump();

      // Tap on the "Send" button
      Finder sendButton = find.byType(SendRequestButton);
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
      await tester.setScreenSize(largeWidthDevice);
      await tester.pumpWidget(
        const ProviderScope(
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: RequestEditorPane(),
              ),
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
        of: find.byType(EnvURLField),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(field);
      tester.testTextInput.enterText(kTestUrl);
      await tester.pump();

      // Tap on the "Send" button
      Finder sendButton = find.byType(SendRequestButton);
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: RequestEditorPane(),
              ),
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
