import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/button_group_filled.dart';

void main() {
  testWidgets('Testing FilledButtonGroup', (WidgetTester tester) async {
    final buttons = [
      ButtonData(
        icon: Icons.add,
        label: 'Add',
        tooltip: 'Add Item',
        onPressed: () {},
      ),
      ButtonData(
        icon: Icons.remove,
        label: 'Remove',
        tooltip: 'Remove Item',
        onPressed: () {},
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilledButtonGroup(buttons: buttons),
        ),
      ),
    );

    expect(find.byType(FilledButtonWidget), findsNWidgets(2));
  });

  testWidgets('Testing FilledButtonWidget with label',
      (WidgetTester tester) async {
    final buttonData = ButtonData(
      icon: Icons.add,
      label: 'Add',
      tooltip: 'Add Item',
      onPressed: () {},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilledButtonWidget(buttonData: buttonData, showLabel: true),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('Testing FilledButtonWidget without label',
      (WidgetTester tester) async {
    final buttonData = ButtonData(
      icon: Icons.add,
      label: 'Add',
      tooltip: 'Add Item',
      onPressed: () {},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilledButtonWidget(buttonData: buttonData, showLabel: false),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Add'), findsNothing);
  });

  testWidgets('Testing FilledButtonWidget with onPressed callback',
      (WidgetTester tester) async {
    bool pressed = false;

    final buttonData = ButtonData(
      icon: Icons.add,
      label: 'Add',
      tooltip: 'Add Item',
      onPressed: () {
        pressed = true;
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilledButtonWidget(buttonData: buttonData, showLabel: true),
        ),
      ),
    );

    await tester.tap(find.byType(FilledButtonWidget));
    await tester.pump();

    expect(pressed, isTrue);
  });
}
