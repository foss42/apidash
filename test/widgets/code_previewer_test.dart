import 'package:apidash_core/apidash_core.dart' show RandomStringGenerator;
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/code_previewer.dart';
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
  testWidgets('Testing for code previewer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Code Previewer',
        theme: kThemeDataLight,
        home: Scaffold(
            body: Column(
          children: [
            Expanded(
              child: CodePreviewer(
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
  testWidgets('Testing for code previewer when code is of 1000 lines',
      (tester) async {
    String codeLines = RandomStringGenerator.getRandomStringLines(1000, 20);
    await tester.pumpWidget(
      MaterialApp(
        title: 'Code Previewer',
        theme: kThemeDataLight,
        home: Scaffold(
            body: Column(
          children: [
            Expanded(
              child: CodePreviewer(
                code: codeLines,
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

    expect(find.textContaining('Preview ends here', findRichText: true),
        findsOneWidget);
    expect(
        find.textContaining('You can check Raw for full result.',
            findRichText: true),
        findsOneWidget);
  });
  testWidgets('Testing for code previewer when tab is used in the code',
      (tester) async {
    String codeTab = '''for x in ['apple','banana']:
\tprint(x)
\tfor a in [1,2]:
\t\tprint(a)''';
    await tester.pumpWidget(
      MaterialApp(
        title: 'Code Previewer Tab example',
        theme: kThemeDataLight,
        home: Scaffold(
            body: Column(
          children: [
            Expanded(
              child: CodePreviewer(
                code: codeTab,
                theme: kLightCodeTheme,
                language: 'python',
                textStyle: kCodeStyle,
              ),
            ),
          ],
        )),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('    print(x)', findRichText: true),
        findsOneWidget);
    expect(find.textContaining('        print(a)', findRichText: true),
        findsOneWidget);
  });
}
