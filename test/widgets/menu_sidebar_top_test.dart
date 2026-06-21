import 'package:apidash/consts.dart';
import 'package:apidash/widgets/menu_sidebar_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SidebarTopMenu renders and handles selection', (WidgetTester tester) async {
    SidebarMenuOption? selectedOption;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SidebarTopMenu(
            onSelected: (option) {
              selectedOption = option;
            },
          ),
        ),
      ),
    );

    // Verify button exists
    final buttonFinder = find.byType(PopupMenuButton<SidebarMenuOption>);
    expect(buttonFinder, findsOneWidget);

    // Tap to open menu
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // Verify items
    for (var option in SidebarMenuOption.values) {
      expect(find.text(option.label), findsOneWidget);
    }

    // Tap an option
    await tester.tap(find.text(SidebarMenuOption.values.first.label));
    await tester.pumpAndSettle();

    expect(selectedOption, SidebarMenuOption.values.first);
  });
}
