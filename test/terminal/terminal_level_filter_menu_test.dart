import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/terminal/enums.dart';
import 'package:apidash/terminal/widgets/terminal_level_filter_menu.dart';

void main() {
  testWidgets('TerminalLevelFilterMenu toggles and bulk selects via dialog',
      (tester) async {
    Set<TerminalLevel> selected = TerminalLevel.values.toSet();
    late Set<TerminalLevel> last;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TerminalLevelFilterMenu(
          selected: selected,
          onChanged: (s) => last = s,
        ),
      ),
    ));

    // Open dialog
    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pumpAndSettle();

    // Toggle Info off by tapping its checkbox row, then apply
    await tester.tap(find.text('Info'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(last.contains(TerminalLevel.info), isFalse);

    // Select all
    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select all'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(last.length, TerminalLevel.values.length);

    // Clear selection
    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear selection'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(last, isEmpty);
  });

  testWidgets('Cancel does not apply changes', (tester) async {
    Set<TerminalLevel> selected = TerminalLevel.values.toSet();
    bool called = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TerminalLevelFilterMenu(
          selected: selected,
          onChanged: (_) => called = true,
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pumpAndSettle();

    // Toggle something off
    await tester.tap(find.text('Info'));
    await tester.pumpAndSettle();

    // Cancel instead of apply
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(called, isFalse);
  });
}
