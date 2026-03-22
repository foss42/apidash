import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/expandable_section.dart';

void main() {
  testWidgets('ExpandableSection starts collapsed by default', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpandableSection(
            title: 'Test Section',
            child: Text('Content'),
          ),
        ),
      ),
    );

    expect(find.text('Test Section'), findsOneWidget);
    expect(find.text('Content'), findsNothing);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
  });

  testWidgets('ExpandableSection can be expanded by tapping', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpandableSection(
            title: 'Test Section',
            child: Text('Content'),
          ),
        ),
      ),
    );

    // Tap to expand
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Test Section'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
  });

  testWidgets('ExpandableSection respects initiallyOpen parameter',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpandableSection(
            title: 'Test Section',
            initiallyOpen: true,
            child: Text('Content'),
          ),
        ),
      ),
    );

    expect(find.text('Test Section'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
  });

  testWidgets('ExpandableSection respects forceOpen parameter', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpandableSection(
            title: 'Test Section',
            forceOpen: true,
            child: Text('Content'),
          ),
        ),
      ),
    );

    expect(find.text('Test Section'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);

    // Tapping should not close it when forceOpen is true
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Content'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
  });

  testWidgets('ExpandableSection highlights title when highlightQuery matches',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpandableSection(
            title: 'Network Settings',
            highlightQuery: 'network',
            child: Text('Content'),
          ),
        ),
      ),
    );

    // When highlighting is applied, the title is rendered as RichText instead of Text
    final richTexts = tester.widgetList<RichText>(find.byType(RichText));
    final titleRichText = richTexts.firstWhere(
      (rt) => rt.text.toPlainText() == 'Network Settings',
      orElse: () => throw Exception('RichText with title not found'),
    );
    expect(titleRichText.text.toPlainText(), 'Network Settings');
  });

  testWidgets('ExpandableSection updates when forceOpen changes',
      (tester) async {
    bool forceOpen = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                ExpandableSection(
                  title: 'Test Section',
                  forceOpen: forceOpen ? true : null,
                  child: const Text('Content'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => forceOpen = !forceOpen),
                  child: const Text('Toggle Force Open'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Initially collapsed
    expect(find.text('Content'), findsNothing);

    // Tap button to set forceOpen to true
    await tester.tap(find.text('Toggle Force Open'));
    await tester.pumpAndSettle();

    // Should now be open
    expect(find.text('Content'), findsOneWidget);
  });
}
