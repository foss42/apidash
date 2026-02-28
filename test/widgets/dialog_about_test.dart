import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';

void main() {
  testWidgets(
      'Testing showAboutAppDialog displays the dialog with IntroMessage and Close button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showAboutAppDialog(context);
                  },
                  child: const Text('Show About Dialog'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show About Dialog'));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);

    expect(find.byType(IntroMessage), findsOneWidget);

    expect(find.text('Close'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
