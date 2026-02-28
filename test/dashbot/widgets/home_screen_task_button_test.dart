import 'package:apidash/dashbot/widgets/home_screen_task_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreenTaskButton renders label and invokes callback',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeScreenTaskButton(
            label: 'Perform action',
            textAlign: TextAlign.left,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Perform action'), findsOneWidget);
    final textWidget = tester.widget<Text>(find.text('Perform action'));
    expect(textWidget.textAlign, TextAlign.left);

    await tester.tap(find.byType(TextButton));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
