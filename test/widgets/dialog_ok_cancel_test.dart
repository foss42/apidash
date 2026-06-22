import 'package:apidash/widgets/dialog_ok_cancel.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing showOkCancelDialog default labels', (tester) async {
    bool okClicked = false;
    bool cancelClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showOkCancelDialog(
                  context,
                  dialogTitle: 'Test Title',
                  content: 'Test Content',
                  onClickOk: () => okClicked = true,
                  onClickCancel: () => cancelClicked = true,
                );
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
    expect(find.text(kLabelOk), findsOneWidget);
    expect(find.text(kLabelCancel), findsOneWidget);

    // Click OK
    await tester.tap(find.text(kLabelOk));
    await tester.pumpAndSettle();

    expect(okClicked, isTrue);
    expect(cancelClicked, isFalse);
    expect(find.byType(AlertDialog), findsNothing); // Dialog dismissed
  });

  testWidgets('Testing showOkCancelDialog custom labels and Cancel', (
    tester,
  ) async {
    bool cancelClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showOkCancelDialog(
                  context,
                  buttonLabelOk: 'Yes',
                  buttonLabelCancel: 'No',
                  onClickCancel: () => cancelClicked = true,
                );
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);

    // Click Cancel
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();

    expect(cancelClicked, isTrue);
    expect(find.byType(AlertDialog), findsNothing); // Dialog dismissed
  });
}
