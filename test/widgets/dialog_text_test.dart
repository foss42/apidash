import 'package:apidash/widgets/dialog_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('showTextDialog renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showTextDialog(
                    context,
                    dialogTitle: 'Test Title',
                    content: 'Test Content',
                    buttonLabel: 'Close',
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Tap to open the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog content
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);

    // Tap the close button
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Verify dialog is closed
    expect(find.byType(AlertDialog), findsNothing);
  });
}
