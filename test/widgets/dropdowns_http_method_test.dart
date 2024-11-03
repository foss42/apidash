import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing Dropdown for Http Method', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Dropdown Http method testing',
        theme: kThemeDataLight,
        home: Scaffold(
          body: Center(
            child: Column(
              children: [
                DropdownButtonHttpMethod(
                  method: HTTPVerb.post,
                  onChanged: (value) {
                    changedValue = value!;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.unfold_more_rounded), findsOneWidget);
    expect(find.byType(DropdownButton<HTTPVerb>), findsOneWidget);
    expect(
        (tester.widget(find.byType(DropdownButton<HTTPVerb>)) as DropdownButton)
            .value,
        equals(HTTPVerb.post));

    await tester.tap(find.text('POST'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('PUT').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, HTTPVerb.put);
  });
}
