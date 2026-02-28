import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart'
    show SidebarEnvironmentCard, ItemCardMenu;

import '../test_consts.dart';

Future<void> pumpSidebarEnvironmentCard(
  WidgetTester tester, {
  required ThemeData theme,
  required String id,
  required String selectedId,
  String? editRequestId,
  bool isGlobal = false,
  required String name,
  Function()? onTap,
  Function()? onDoubleTap,
  Function(String)? onChangedNameEditor,
  Function()? onTapOutsideNameEditor,
  Function(dynamic)? onMenuSelected,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      title: 'Sidebar Environment Card',
      theme: theme,
      home: Scaffold(
        body: ListView(
          children: [
            SidebarEnvironmentCard(
              id: id,
              selectedId: selectedId,
              editRequestId: editRequestId,
              isGlobal: isGlobal,
              name: name,
              onTap: onTap,
              onDoubleTap: onDoubleTap,
              onChangedNameEditor: onChangedNameEditor,
              onTapOutsideNameEditor: onTapOutsideNameEditor,
              onMenuSelected: onMenuSelected,
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('Testing Sidebar Environment Card', (tester) async {
    dynamic changedValue;

    await pumpSidebarEnvironmentCard(
      tester,
      theme: kThemeDataLight,
      id: '23',
      selectedId: '2',
      name: 'Production',
      onTap: () {
        changedValue = 'Single Tapped';
      },
      onDoubleTap: () {
        changedValue = 'Double Tapped';
      },
    );

    expect(find.byType(InkWell), findsOneWidget);
    expect(find.text('Production'), findsOneWidget);
    expect(find.widgetWithText(SizedBox, 'Production'), findsOneWidget);
    expect(find.widgetWithText(Card, 'Production'), findsOneWidget);

    var tappable = find.widgetWithText(Card, 'Production');
    await tester.tap(tappable);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(changedValue, 'Single Tapped');
  });

  testWidgets('Testing Sidebar Environment Card dark mode', (tester) async {
    dynamic changedValue;

    await pumpSidebarEnvironmentCard(
      tester,
      theme: kThemeDataDark,
      id: '23',
      selectedId: '2',
      name: 'Production',
      onTap: () {
        changedValue = 'Single Tapped';
      },
      onDoubleTap: () {
        changedValue = 'Double Tapped';
      },
    );

    expect(find.byType(InkWell), findsOneWidget);
    expect(find.text('Production'), findsOneWidget);
    expect(find.widgetWithText(SizedBox, 'Production'), findsOneWidget);
    expect(find.widgetWithText(Card, 'Production'), findsOneWidget);

    var tappable = find.widgetWithText(Card, 'Production');
    await tester.tap(tappable);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(changedValue, 'Single Tapped');
  });

  testWidgets('Testing Sidebar Environment Card inEditMode', (tester) async {
    dynamic changedValue;

    await pumpSidebarEnvironmentCard(
      tester,
      theme: kThemeDataLight,
      id: '23',
      selectedId: '23',
      editRequestId: '23',
      name: 'Production',
      onChangedNameEditor: (value) {
        changedValue = value;
      },
      onTapOutsideNameEditor: () {
        changedValue = 'Tapped Outside';
      },
    );

    expect(find.byType(InkWell), findsOneWidget);

    var tappable = find.byType(TextFormField);
    await tester.enterText(tappable, 'entering 123 for testing');
    await tester.pumpAndSettle();
    expect(changedValue, 'entering 123 for testing');

    await tester.tapAt(const Offset(100, 100));
    await tester.pumpAndSettle();
    expect(changedValue, 'Tapped Outside');

    await tester.enterText(tappable, 'New Name');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(changedValue, "Tapped Outside");
  });

  group("Testing Sidebar Environment Card Item Card Menu visibility", () {
    testWidgets(
        'Environment ItemCardMenu should be visible when not in edit mode',
        (tester) async {
      await pumpSidebarEnvironmentCard(
        tester,
        theme: kThemeDataLight,
        id: '23',
        selectedId: '23',
        isGlobal: false,
        name: 'Production',
        onMenuSelected: (value) {},
      );

      expect(find.byType(ItemCardMenu), findsOneWidget);
    });

    testWidgets(
        'Environment ItemCardMenu should not be visible when in edit mode',
        (tester) async {
      await pumpSidebarEnvironmentCard(
        tester,
        theme: kThemeDataLight,
        id: '23',
        selectedId: '23',
        editRequestId: '23',
        isGlobal: false,
        name: 'Production',
        onMenuSelected: (value) {},
      );

      expect(find.byType(ItemCardMenu), findsNothing);
    });

    testWidgets(
        'Environment ItemCardMenu should not be visible when not selected',
        (tester) async {
      await pumpSidebarEnvironmentCard(
        tester,
        theme: kThemeDataLight,
        id: '23',
        selectedId: '24',
        editRequestId: '24',
        isGlobal: false,
        name: 'Production',
        onMenuSelected: (value) {},
      );

      expect(find.byType(ItemCardMenu), findsNothing);
    });

    testWidgets('Environment ItemCardMenu should not be visible if isGlobal',
        (tester) async {
      await pumpSidebarEnvironmentCard(
        tester,
        theme: kThemeDataLight,
        id: '23',
        selectedId: '23',
        editRequestId: '24',
        isGlobal: true,
        name: 'Production',
        onMenuSelected: (value) {},
      );

      expect(find.byType(ItemCardMenu), findsNothing);
    });
  });
}
