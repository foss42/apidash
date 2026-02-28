import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/dialog_rename.dart';

void main() {
  group('showRenameDialog Tests', () {
    testWidgets('displays dialog with correct content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showRenameDialog(
                    context,
                    'Rename Item',
                    'Old Name',
                    (newName) {},
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Rename Item'), findsOneWidget);
      expect(find.byIcon(Icons.edit_rounded), findsOneWidget);

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Old Name'), findsOneWidget);
    });

    testWidgets('calls onRename with new name when Ok is pressed',
        (tester) async {
      String? renamedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showRenameDialog(
                    context,
                    'Rename Item',
                    'Old Name',
                    (newName) {
                      renamedValue = newName;
                    },
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'New Name');
      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(renamedValue, 'New Name');
    });

    testWidgets('does not call onRename when Cancel is pressed',
        (tester) async {
      String? renamedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showRenameDialog(
                    context,
                    'Rename Item',
                    'Old Name',
                    (newName) {
                      renamedValue = newName;
                    },
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'New Name');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(renamedValue, isNull);
    });

    testWidgets('disposes TextEditingController after dialog is closed',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showRenameDialog(
                      context,
                      'Rename Item',
                      'Old Name',
                      (newName) {},
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(textFieldFinder, findsNothing);
    });
  });
}
