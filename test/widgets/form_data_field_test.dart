import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/form_data_field.dart';

void main() {
  testWidgets('Testing for Form Data Widget', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Form Data Field Widget',
        home: Scaffold(
          body: FormDataField(
            keyId: "1",
            initialValue: "Test Field",
          ),
        ),
      ),
    );

    expect(find.text("Test Field"), findsOneWidget);
  });
}
