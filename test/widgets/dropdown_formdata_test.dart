import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing Dropdown for FormData', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Dropdown FormData Type testing',
        theme: kThemeDataLight,
        home: Scaffold(
          body: Center(
            child: Column(
              children: [
                DropdownButtonFormData(
                  formDataType: FormDataType.file,
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
    expect(find.byType(DropdownButton<FormDataType>), findsOneWidget);
    expect(
        (tester.widget(find.byType(DropdownButton<FormDataType>))
                as DropdownButton)
            .value,
        equals(FormDataType.file));

    await tester.tap(find.text('file'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('text').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, FormDataType.text);
  });
}
