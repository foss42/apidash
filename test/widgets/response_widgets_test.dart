import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/response_widgets.dart';
import 'package:lottie/lottie.dart';

void main() {
  testWidgets('Testing for lottie', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Send',
        home: Scaffold(
          body: SendingWidget(),
        ),
      ),
    );

    expect(find.byType(Lottie), findsOneWidget);
  });
  testWidgets('Testing for Not Sent', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Not Sent',
        home: Scaffold(
          body: NotSentWidget(),
        ),
      ),
    );

    expect(find.byIcon(Icons.north_east_rounded), findsOneWidget);
    expect(find.text('Not Sent'), findsOneWidget);
  });
}
