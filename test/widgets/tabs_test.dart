import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/tabs.dart';

void main() {
  testWidgets('TabLabel shows indicator when showIndicator is true',
      (tester) async {
    const String labelText = 'URL Params';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TabLabel(
            text: labelText,
            showIndicator: true,
          ),
        ),
      ),
    );

    expect(find.text(labelText), findsOneWidget);
    expect(find.byIcon(Icons.circle), findsOneWidget);
  });

  testWidgets('TabLabel does not show indicator when showIndicator is false',
      (tester) async {
    const String labelText = 'Request';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TabLabel(
            text: labelText,
            showIndicator: false,
          ),
        ),
      ),
    );

    expect(find.text(labelText), findsOneWidget);
    expect(find.byIcon(Icons.circle), findsNothing);
  });
}
