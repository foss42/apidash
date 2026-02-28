import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/splitview_drawer.dart';

void main() {
  testWidgets('Testing DrawerSplitView displays main components',
      (tester) async {
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

    expect(find.text('Main Content'), findsOneWidget);

    expect(find.text('Title'), findsOneWidget);

    expect(find.text('Left Drawer Content'), findsNothing);

    expect(find.text('Right Drawer Content'), findsNothing);
  });

  testWidgets('Testing DrawerSplitView opens left drawer', (tester) async {
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

    await tester.tap(find.byIcon(Icons.format_list_bulleted_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Left Drawer Content'), findsOneWidget);
  });

  testWidgets('Testing DrawerSplitView opens right drawer', (tester) async {
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

    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    expect(find.text('Right Drawer Content'), findsOneWidget);
  });

  testWidgets('Testing DrawerSplitView displays actions', (tester) async {
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

    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
