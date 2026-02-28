import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/dialog_history_retention.dart';

void main() {
  group('showHistoryRetentionDialog Tests', () {
    testWidgets('Testing History Retention dialog content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showHistoryRetentionDialog(
                    context,
                    HistoryRetentionPeriod.forever,
                    (period) {},
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

      expect(find.text('Manage History'), findsOneWidget);
      expect(find.byIcon(Icons.manage_history_rounded), findsOneWidget);

      expect(find.byType(RadioListTile<HistoryRetentionPeriod>),
          findsNWidgets(HistoryRetentionPeriod.values.length));
    });

    testWidgets('updates selected retention period correctly', (tester) async {
      HistoryRetentionPeriod selectedPeriod = HistoryRetentionPeriod.forever;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showHistoryRetentionDialog(
                    context,
                    selectedPeriod,
                    (period) {
                      selectedPeriod = period;
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

      await tester.tap(find.text(HistoryRetentionPeriod.oneWeek.label));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(selectedPeriod, HistoryRetentionPeriod.oneWeek);
    });

    testWidgets('Cancel button closes dialog without changing retention period',
        (tester) async {
      HistoryRetentionPeriod selectedPeriod = HistoryRetentionPeriod.oneWeek;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showHistoryRetentionDialog(
                    context,
                    selectedPeriod,
                    (period) {
                      selectedPeriod = period;
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

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(selectedPeriod, HistoryRetentionPeriod.oneWeek);
    });

    testWidgets(
        'Confirm button closes dialog and calls onRetentionPeriodChange',
        (tester) async {
      HistoryRetentionPeriod selectedPeriod =
          HistoryRetentionPeriod.threeMonths;
      HistoryRetentionPeriod newPeriod = HistoryRetentionPeriod.oneWeek;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showHistoryRetentionDialog(
                    context,
                    selectedPeriod,
                    (period) {
                      selectedPeriod = period;
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

      await tester.tap(find.text(newPeriod.label));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(selectedPeriod, newPeriod);
    });
  });
}
