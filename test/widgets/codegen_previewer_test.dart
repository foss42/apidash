import 'package:apidash/widgets/widgets.dart'
    show ViewCodePane, CodeGenPreviewer;
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/consts.dart';
import '../test_consts.dart';

void main() {
  String code = r'''import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/country/codes');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    print('Status Code: ${response.statusCode}');
    print('Result: ${response.body}');
  }
  else{
    print('Error Status Code: ${response.statusCode}');
  }
}
''';
  testWidgets('Testing for CodeGen Previewer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'CodeGen Previewer',
        theme: kThemeDataLight,
        home: Scaffold(
            body: Column(
          children: [
            Expanded(
              child: CodeGenPreviewer(
                code: code,
                theme: kLightCodeTheme,
                language: 'dart',
                textStyle: kCodeStyle,
              ),
            ),
          ],
        )),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Error Status Code', findRichText: true),
        findsOneWidget);
  });
  testWidgets('Testing for View Code Pane', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'ViewCodePane',
        theme: kThemeDataDark,
        home: Scaffold(
            body: Column(
          children: [
            Expanded(
              child: ViewCodePane(
                code: code,
                codegenLanguage: CodegenLanguage.dartHttp,
                onChangedCodegenLanguage: (p0) {},
              ),
            ),
          ],
        )),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(DropdownButton<CodegenLanguage>), findsOneWidget);
    expect(
        (tester.widget(find.byType(DropdownButton<CodegenLanguage>))
                as DropdownButton)
            .value,
        equals(CodegenLanguage.dartHttp));

    await tester.tap(find.text('Dart (http)'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Kotlin (okhttp3)'), findsWidgets);
    expect(find.text('Python (http.client)'), findsWidgets);
    expect(find.text('Python (requests)'), findsWidgets);

    expect(find.textContaining('Error Status Code', findRichText: true),
        findsOneWidget);
    expect(find.byIcon(Icons.content_copy), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
  });
  testWidgets('Testing for View Code Pane Light theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'ViewCodePane',
        theme: kThemeDataLight,
        home: Scaffold(
            body: Column(
          children: [
            Expanded(
              child: ViewCodePane(
                code: code,
                codegenLanguage: CodegenLanguage.dartHttp,
                onChangedCodegenLanguage: (p0) {},
              ),
            ),
          ],
        )),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Dart (http)'), findsOneWidget);

    expect(find.textContaining('Error Status Code', findRichText: true),
        findsOneWidget);
    expect(find.byIcon(Icons.content_copy), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
  });
}
