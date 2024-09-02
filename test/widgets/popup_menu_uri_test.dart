import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/popup_menu_uri.dart';

void main() {
  testWidgets('URIPopupMenu displays initial value',
      (WidgetTester tester) async {
    const uriScheme = 'https';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: URIPopupMenu(
            value: uriScheme,
            items: [uriScheme],
          ),
        ),
      ),
    );

    expect(find.text(uriScheme), findsOneWidget);
  });

  testWidgets('URIPopupMenu displays popup menu items',
      (WidgetTester tester) async {
    const uriScheme1 = 'https';
    const uriScheme2 = 'http';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: URIPopupMenu(
            items: [uriScheme1, uriScheme2],
            value: uriScheme1,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    expect(find.text(uriScheme1), findsExactly(2));
    expect(find.text(uriScheme2), findsOneWidget);
  });

  testWidgets('URIPopupMenu calls onChanged when an item is selected',
      (WidgetTester tester) async {
    const uriScheme1 = 'https';
    const uriScheme2 = 'http';
    String? selectedScheme;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: URIPopupMenu(
            value: uriScheme1,
            items: const [uriScheme1, uriScheme2],
            onChanged: (value) {
              selectedScheme = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    await tester.tap(find.text(uriScheme2).last);
    await tester.pumpAndSettle();

    expect(selectedScheme, uriScheme2);
  });
}
