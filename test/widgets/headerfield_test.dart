import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/headerfield.dart';

void main() {
  testWidgets('Testing Header Field', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Header Field',
        home: Scaffold(
          body: Column(children: [
            HeaderField(
              keyId: "1",
              initialValue: "X",
            )
          ]),
        ),
      ),
    );

    expect(find.byKey(const Key("1")), findsOneWidget);
    expect(find.text('X'), findsOneWidget);
  });
}
