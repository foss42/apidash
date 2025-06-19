import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/popup_menu_uri.dart';

void main() {
  testWidgets('DefaultUriSchemePopupMenu displays initial value',
      (WidgetTester tester) async {
    const uriScheme = SupportedUriSchemes.https;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DefaultUriSchemePopupMenu(
            value: uriScheme,
          ),
        ),
      ),
    );

    expect(find.text(uriScheme.name), findsOneWidget);
  });

  testWidgets('DefaultUriSchemePopupMenu displays popup menu items',
      (WidgetTester tester) async {
    const uriScheme1 = SupportedUriSchemes.https;
    const uriScheme2 = SupportedUriSchemes.http;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DefaultUriSchemePopupMenu(
            value: uriScheme1,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    expect(find.text(uriScheme1.name), findsExactly(2));
    expect(find.text(uriScheme2.name), findsOneWidget);
  });

  testWidgets(
      'DefaultUriSchemePopupMenu calls onChanged when an item is selected',
      (WidgetTester tester) async {
    const uriScheme1 = SupportedUriSchemes.https;
    const uriScheme2 = SupportedUriSchemes.http;
    SupportedUriSchemes? selectedScheme;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DefaultUriSchemePopupMenu(
            value: uriScheme1,
            onChanged: (value) {
              selectedScheme = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    await tester.tap(find.text(uriScheme2.name).last);
    await tester.pumpAndSettle();

    expect(selectedScheme, uriScheme2);
  });
}
