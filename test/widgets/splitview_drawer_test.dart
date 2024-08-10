import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/splitview_drawer.dart';

void main() {
  testWidgets('DrawerSplitView displays main components', (tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    await tester.pumpWidget(
      MaterialApp(
        home: DrawerSplitView(
          scaffoldKey: scaffoldKey,
          mainContent: const Text('Main Content'),
          title: const Text('Title'),
          leftDrawerContent: const Text('Left Drawer Content'),
          rightDrawerContent: const Text('Right Drawer Content'),
        ),
      ),
    );

    // Verify the main content is displayed
    expect(find.text('Main Content'), findsOneWidget);

    // Verify the title is displayed
    expect(find.text('Title'), findsOneWidget);

    // Verify the left drawer content is not displayed initially
    expect(find.text('Left Drawer Content'), findsNothing);

    // Verify the right drawer content is not displayed initially
    expect(find.text('Right Drawer Content'), findsNothing);
  });

  testWidgets('DrawerSplitView opens left drawer', (tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    await tester.pumpWidget(
      MaterialApp(
        home: DrawerSplitView(
          scaffoldKey: scaffoldKey,
          mainContent: const Text('Main Content'),
          title: const Text('Title'),
          leftDrawerContent: const Text('Left Drawer Content'),
        ),
      ),
    );

    // Tap the leading icon to open the left drawer
    await tester.tap(find.byIcon(Icons.format_list_bulleted_rounded));
    await tester.pumpAndSettle();

    // Verify the left drawer content is displayed
    expect(find.text('Left Drawer Content'), findsOneWidget);
  });

  testWidgets('DrawerSplitView opens right drawer', (tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    await tester.pumpWidget(
      MaterialApp(
        home: DrawerSplitView(
          scaffoldKey: scaffoldKey,
          mainContent: const Text('Main Content'),
          title: const Text('Title'),
          rightDrawerContent: const Text('Right Drawer Content'),
        ),
      ),
    );

    // Tap the right drawer icon to open the right drawer
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    // Verify the right drawer content is displayed
    expect(find.text('Right Drawer Content'), findsOneWidget);
  });

  testWidgets('DrawerSplitView displays actions', (tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    await tester.pumpWidget(
      MaterialApp(
        home: DrawerSplitView(
          scaffoldKey: scaffoldKey,
          mainContent: const Text('Main Content'),
          title: const Text('Title'),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {})
          ],
        ),
      ),
    );

    // Verify the action icon is displayed
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
