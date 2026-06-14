import 'package:apidash/widgets/button_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ShareButton renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ShareButton(toShare: 'test content'),
        ),
      ),
    );

    expect(find.byType(ShareButton), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
  });

  testWidgets('ShareButton tap triggers onPressed logic', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ShareButton(toShare: 'test content'),
        ),
      ),
    );

    // Tap the button. We just want to ensure it doesn't crash when pressed.
    // Testing actual Share plugin might require mocking, but triggering the tap covers the basic async onPressed flow.
    await tester.tap(find.byType(ShareButton));
    await tester.pump();
  });
}
