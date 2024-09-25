import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing Dropdown for Codegen', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Dropdown Codegen Type testing',
        theme: kThemeDataLight,
        home: Scaffold(
          body: Center(
            child: Column(
              children: [
                DropdownButtonCodegenLanguage(
                  codegenLanguage: CodegenLanguage.curl,
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
    expect(find.byType(DropdownButton<CodegenLanguage>), findsOneWidget);
    expect(
        (tester.widget(find.byType(DropdownButton<CodegenLanguage>))
                as DropdownButton)
            .value,
        equals(CodegenLanguage.curl));

    await tester.tap(find.text('cURL'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Dart (dio)').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, CodegenLanguage.dartDio);
  });
}
