import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/intro_message.dart';

void main() {
  testWidgets('Testing Intro Message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Intro Message',
        home: Scaffold(
          body: IntroMessage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Welcome to API Dash ⚡️'), findsOneWidget);

    expect(find.byType(RichText), findsAtLeastNWidgets(1));
    expect(
        find.textContaining("Please support this project by giving us a ",
            findRichText: true),
        findsOneWidget);

    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('Star on GitHub'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.star));
  });
}
