import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing DropdownButtonImportFormat selection', (tester) async {
    ImportFormat? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        title: 'Dropdown Import Format Testing',
        theme: kThemeDataLight,
        home: Scaffold(
          body: Center(
            child: DropdownButtonImportFormat(
              importFormat: ImportFormat.curl,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      ),
    );

    // Verify initial widget rendering
    expect(find.byIcon(Icons.unfold_more_rounded), findsOneWidget);
    expect(find.byType(DropdownButton<ImportFormat>), findsOneWidget);
    expect(
      (tester.widget(find.byType(DropdownButton<ImportFormat>))
              as DropdownButton<ImportFormat>)
          .value,
      equals(ImportFormat.curl),
    );
    expect(find.text('cURL'), findsOneWidget);

    // Open dropdown menu
    await tester.tap(find.text('cURL'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify all options are present in the open dropdown menu
    expect(find.text('Postman Collection v2.1'), findsOneWidget);
    expect(find.text('Insomnia v4'), findsOneWidget);
    expect(find.text('Har v1.2'), findsOneWidget);

    // Select Postman
    await tester.tap(find.text('Postman Collection v2.1').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, ImportFormat.postman);
  });

  testWidgets('Testing DropdownButtonImportFormat dark theme', (tester) async {
    ImportFormat? changedValue;

    await tester.pumpWidget(
      MaterialApp(
        title: 'Dropdown Import Format Testing (Dark)',
        theme: kThemeDataDark,
        home: Scaffold(
          body: Center(
            child: DropdownButtonImportFormat(
              importFormat: ImportFormat.insomnia,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      ),
    );

    expect(
      (tester.widget(find.byType(DropdownButton<ImportFormat>))
              as DropdownButton<ImportFormat>)
          .value,
      equals(ImportFormat.insomnia),
    );
    expect(find.text('Insomnia v4'), findsOneWidget);

    // Open dropdown and select Har
    await tester.tap(find.text('Insomnia v4'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Har v1.2').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(changedValue, ImportFormat.har);
  });
}
