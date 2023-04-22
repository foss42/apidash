import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/codegen_previewer.dart';
import 'package:apidash/consts.dart';
import '../test_consts.dart';

void main() {
  String code = r'''import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.foss42.com/country/codes');

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
              ),
            ),
          ],
        )),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Code'), findsOneWidget);

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
              ),
            ),
          ],
        )),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Code'), findsOneWidget);

    expect(find.textContaining('Error Status Code', findRichText: true),
        findsOneWidget);
    expect(find.byIcon(Icons.content_copy), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
  });
}
