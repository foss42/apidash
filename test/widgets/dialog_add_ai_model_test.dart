import 'package:apidash/screens/common_widgets/ai/dialog_add_ai_model.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('addNewModel Tests', () {
    testWidgets('displays dialog with correct title and fields', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => addNewModel(context),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Add Custom Model'), findsOneWidget);
      expect(find.text('Add Model'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('returns Model with id and name when both are provided', (
      tester,
    ) async {
      Model? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await addNewModel(context);
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'gpt-4o');
      await tester.enterText(textFields.last, 'GPT 4o');

      await tester.tap(find.text('Add Model'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.id, 'gpt-4o');
      expect(result!.name, 'GPT 4o');
    });

    testWidgets('defaults name to id when display name is empty', (
      tester,
    ) async {
      Model? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await addNewModel(context);
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'claude-3');

      await tester.tap(find.text('Add Model'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.id, 'claude-3');
      expect(result!.name, 'claude-3');
    });

    testWidgets('returns null when model id is empty', (tester) async {
      Model? result;
      bool callbackExecuted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await addNewModel(context);
                  callbackExecuted = true;
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Leave both fields empty, tap Add Model
      await tester.tap(find.text('Add Model'));
      await tester.pumpAndSettle();

      expect(callbackExecuted, isTrue);
      expect(result, isNull);
    });

    testWidgets('returns null when model id is only whitespace', (
      tester,
    ) async {
      Model? result;
      bool callbackExecuted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await addNewModel(context);
                  callbackExecuted = true;
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, '   ');

      await tester.tap(find.text('Add Model'));
      await tester.pumpAndSettle();

      expect(callbackExecuted, isTrue);
      expect(result, isNull);
    });

    testWidgets('returns null when dialog is dismissed', (tester) async {
      Model? result;
      bool callbackExecuted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await addNewModel(context);
                  callbackExecuted = true;
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dismiss by tapping outside the dialog
      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();

      expect(callbackExecuted, isTrue);
      expect(result, isNull);
    });

    testWidgets('trims whitespace from id and name', (tester) async {
      Model? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await addNewModel(context);
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, '  gpt-4o  ');
      await tester.enterText(textFields.last, '  GPT 4o  ');

      await tester.tap(find.text('Add Model'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.id, 'gpt-4o');
      expect(result!.name, 'GPT 4o');
    });
  });
}
