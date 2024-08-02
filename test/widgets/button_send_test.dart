import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/button_send.dart';

import '../test_consts.dart';

void main() {
  testWidgets('Testing for Send Request button', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Send Request button',
        theme: kThemeDataLight,
        home: Scaffold(
          body: SendButton(
            isWorking: false,
            onTap: () {
              changedValue = 'Send';
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.send), findsOneWidget);
    expect(find.text(kLabelSend), findsOneWidget);
    final button1 = find.byType(FilledButton);
    expect(button1, findsOneWidget);

    await tester.tap(button1);
    expect(changedValue, 'Send');
  });

  testWidgets(
      'Testing for Send Request button when RequestModel is viewed and is waiting for response',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Send Request button',
        theme: kThemeDataLight,
        home: Scaffold(
          body: SendButton(
            isWorking: true,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.send), findsNothing);
    expect(find.text(kLabelSending), findsOneWidget);
    final button1 = find.byType(FilledButton);
    expect(button1, findsOneWidget);

    expect(tester.widget<FilledButton>(button1).enabled, isFalse);
  });
}
