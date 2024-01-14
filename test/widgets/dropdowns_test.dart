import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/dropdowns.dart';
import 'package:apidash/consts.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing Dropdowns', (tester) async {
    dynamic changedValue;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Dropdown testing',
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
