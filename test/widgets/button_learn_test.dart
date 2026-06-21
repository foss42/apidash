import 'package:apidash/widgets/button_learn.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing LearnButton default label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LearnButton(),
        ),
      ),
    );

    expect(find.byType(ADFilledButton), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
  });

  testWidgets('Testing LearnButton custom label and url tap', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LearnButton(
            label: 'Custom Learn',
            url: 'https://apidash.dev',
          ),
        ),
      ),
    );

    expect(find.text('Custom Learn'), findsOneWidget);

    await tester.tap(find.byType(ADFilledButton));
    await tester.pumpAndSettle();
  });
}
