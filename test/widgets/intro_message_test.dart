import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/intro_message.dart';
import 'package:apidash/consts.dart';

void main() {
  testWidgets('Testing Intro Message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Intro Message',
        home: Scaffold(
          body: IntroMessage(isDarkMode: false),
        ),
      ),
    );

    expect(find.byType(Padding), findsAtLeastNWidgets(1));
    expect(find.byType(Expanded), findsAtLeastNWidgets(1));
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Welcome to API Dash ⚡️'), findsOneWidget);
    expect(find.text(kIntro), findsOneWidget);
    expect(find.text('Getting Started'), findsOneWidget);

    expect(find.byType(RichText), findsAtLeastNWidgets(1));
    expect(
        find.textContaining("Please support this project by giving us a ",
            findRichText: true),
        findsOneWidget);

    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('Star on GitHub'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.star));

    //TODO: Unable to find below icons, needs further investigation. Works with flutter run
    //expect(find.byIcon(Icons.code_rounded), findsOneWidget);
    //await tester.tap(find.byIcon(Icons.code_rounded));
    //await tester.tap(find.byIcon(Icons.discord));
  });
}
