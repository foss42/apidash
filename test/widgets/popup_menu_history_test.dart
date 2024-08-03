import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

void main() {
  testWidgets('Testing HistoryRetentionPopupMenu widget',
      (WidgetTester tester) async {
    const historyPeriod1 = HistoryRetentionPeriod.oneMonth;
    const historyPeriod2 = HistoryRetentionPeriod.threeMonths;
    const HistoryRetentionPeriod initialValue = HistoryRetentionPeriod.oneWeek;
    HistoryRetentionPeriod? selectedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HistoryRetentionPopupMenu(
            value: initialValue,
            onChanged: (value) {
              selectedValue = value;
            },
            items: const [historyPeriod1, historyPeriod2],
          ),
        ),
      ),
    );

    expect(find.byType(HistoryRetentionPopupMenu), findsOneWidget);

    expect(find.text(initialValue.label), findsOneWidget);

    await tester.tap(find.byType(HistoryRetentionPopupMenu));
    await tester.pumpAndSettle();

    for (var item in [historyPeriod1, historyPeriod2]) {
      expect(find.text(item.label), findsOneWidget);
    }

    await tester.tap(find.text(historyPeriod2.label));
    await tester.pumpAndSettle();

    expect(selectedValue, historyPeriod2);
  });
}
