import 'package:apidash/widgets/widget_not_sent.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NotSentWidget renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NotSentWidget(),
        ),
      ),
    );

    expect(find.byType(NotSentWidget), findsOneWidget);
    expect(find.byIcon(Icons.north_east_rounded), findsOneWidget);
    expect(find.text(kLabelNotSent), findsOneWidget);
  });
}
