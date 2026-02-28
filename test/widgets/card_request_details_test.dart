import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';

void main() {
  testWidgets('Testing Request Details Card', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Request Details Card',
        home: Scaffold(
            body: RequestDetailsCard(child: SizedBox(height: 10, width: 10))),
      ),
    );

    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
