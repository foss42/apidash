import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/terminal/enums.dart';
import 'package:apidash/terminal/widgets/terminal_level_filter_menu.dart';

void main() {
  testWidgets('TerminalLevelFilterMenu toggles and bulk selects',
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

    // Open menu
    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Toggle Info by tapping text within popup
    await tester.tap(find.text('Info').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(last.contains(TerminalLevel.info), isFalse);

    // Select all
    // Reopen menu after it closes
    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Select all').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(last.length, TerminalLevel.values.length);

    // Clear selection
    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Clear selection').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(last, isEmpty);
  });
}
