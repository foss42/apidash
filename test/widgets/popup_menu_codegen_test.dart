import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/popup_menu_codegen.dart';

void main() {
  testWidgets('CodegenPopupMenu displays initial value',
      (WidgetTester tester) async {
    const codegenLanguage = CodegenLanguage.dartDio;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CodegenPopupMenu(
            value: codegenLanguage,
            items: [codegenLanguage],
          ),
        ),
      ),
    );

    expect(find.text(codegenLanguage.label), findsOneWidget);
  });

  testWidgets('CodegenPopupMenu displays popup menu items',
      (WidgetTester tester) async {
    const codegenLanguage1 = CodegenLanguage.dartDio;
    const codegenLanguage2 = CodegenLanguage.pythonRequests;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CodegenPopupMenu(
            items: [codegenLanguage1, codegenLanguage2],
            value: codegenLanguage1,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    expect(find.text(codegenLanguage1.label), findsExactly(2));
    expect(find.text(codegenLanguage2.label), findsOneWidget);
  });

  testWidgets('CodegenPopupMenu calls onChanged when an item is selected',
      (WidgetTester tester) async {
    const codegenLanguage1 = CodegenLanguage.dartDio;
    const codegenLanguage2 = CodegenLanguage.pythonRequests;
    CodegenLanguage? selectedLanguage;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CodegenPopupMenu(
            value: codegenLanguage1,
            items: const [codegenLanguage1, codegenLanguage2],
            onChanged: (value) {
              selectedLanguage = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    await tester.tap(find.text(codegenLanguage2.label).last);
    await tester.pumpAndSettle();

    expect(selectedLanguage, codegenLanguage2);
  });
}
