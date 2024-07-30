import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/button_clear_response.dart';

import '../test_consts.dart';

void main() {
  testWidgets('Testing for ClearResponseButton', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'ClearResponseButton',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: ClearResponseButton(),
        ),
      ),
    );

    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}
