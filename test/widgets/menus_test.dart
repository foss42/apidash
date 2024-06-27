import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/menus.dart';
import 'package:apidash/consts.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing ItemCardMenu', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'CardMenu testing',
        theme: kThemeDataLight,
        home: Scaffold(
          body: Center(
            child: Column(
              children: [
                ItemCardMenu(
                  onSelected: (value) {
                    changedValue = value;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PopupMenuButton<ItemMenuOption>), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<ItemMenuOption>));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Delete').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, ItemMenuOption.delete);

    await tester.tap(find.byType(PopupMenuButton<ItemMenuOption>));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Duplicate').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, ItemMenuOption.duplicate);
  });
}
