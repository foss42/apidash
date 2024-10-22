import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing Dropdown for Content Type', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Dropdown Content Type testing',
        theme: kThemeDataLight,
        home: Scaffold(
          body: Center(
            child: Column(
              children: [
                DropdownButtonContentType(
                  contentType: ContentType.json,
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
    expect(find.byType(DropdownButton<ContentType>), findsOneWidget);
    expect(
        (tester.widget(find.byType(DropdownButton<ContentType>))
                as DropdownButton)
            .value,
        equals(ContentType.json));

    await tester.tap(find.text('json'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('text').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, ContentType.text);
  });
}
