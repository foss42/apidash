import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/dialog_ok_cancel.dart';

void main() {
  group('Delete Confirmation Dialog Tests', () {
    // Helper to build a simple app that shows the dialog on button tap
    Widget buildTestApp({
      required String dialogTitle,
      required String content,
      String buttonLabelOk = kLabelDelete,
      VoidCallback? onClickOk,
    }) {
      return MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showOkCancelDialog(
                  context,
                  dialogTitle: dialogTitle,
                  content: content,
                  buttonLabelOk: buttonLabelOk,
                  onClickOk: onClickOk,
                );
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      );
    }

    // ─── Request Delete ──────────────────────────────────────────────────

    testWidgets('Request delete dialog renders title and message',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          dialogTitle: kTitleDeleteRequest,
          content: kMsgDeleteRequest,
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(kTitleDeleteRequest), findsOneWidget);
      expect(find.text(kMsgDeleteRequest), findsOneWidget);
      expect(find.text(kLabelDelete), findsOneWidget);
      expect(find.text(kLabelCancel), findsOneWidget);
    });

    testWidgets('Request delete — Cancel closes dialog without calling callback',
        (tester) async {
      bool deleted = false;

      await tester.pumpWidget(
        buildTestApp(
          dialogTitle: kTitleDeleteRequest,
          content: kMsgDeleteRequest,
          onClickOk: () => deleted = true,
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(kLabelCancel));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(deleted, isFalse);
    });

    testWidgets(
        'Request delete — Delete button calls callback and closes dialog',
        (tester) async {
      bool deleted = false;

      await tester.pumpWidget(
        buildTestApp(
          dialogTitle: kTitleDeleteRequest,
          content: kMsgDeleteRequest,
          onClickOk: () => deleted = true,
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(kLabelDelete));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(deleted, isTrue);
    });

    // ─── Environment Delete ──────────────────────────────────────────────

    testWidgets('Environment delete dialog renders title and message',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          dialogTitle: kTitleDeleteEnvironment,
          content: kMsgDeleteEnvironment,
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(kTitleDeleteEnvironment), findsOneWidget);
      expect(find.text(kMsgDeleteEnvironment), findsOneWidget);
      expect(find.text(kLabelDelete), findsOneWidget);
      expect(find.text(kLabelCancel), findsOneWidget);
    });

    testWidgets(
        'Environment delete — Cancel closes dialog without calling callback',
        (tester) async {
      bool deleted = false;

      await tester.pumpWidget(
        buildTestApp(
          dialogTitle: kTitleDeleteEnvironment,
          content: kMsgDeleteEnvironment,
          onClickOk: () => deleted = true,
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(kLabelCancel));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(deleted, isFalse);
    });

    testWidgets(
        'Environment delete — Delete button calls callback and closes dialog',
        (tester) async {
      bool deleted = false;

      await tester.pumpWidget(
        buildTestApp(
          dialogTitle: kTitleDeleteEnvironment,
          content: kMsgDeleteEnvironment,
          onClickOk: () => deleted = true,
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(kLabelDelete));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(deleted, isTrue);
    });
  });
}
