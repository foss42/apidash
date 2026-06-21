import 'package:apidash/widgets/dialog_import.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/drag_and_drop_area.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_selector/file_selector.dart';

void main() {
  testWidgets('Testing showImportDialog', (tester) async {
    ImportFormat? selectedFormat;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showImportDialog(
                  context: context,
                  importFormat: ImportFormat.curl,
                  onImportFormatChange: (format) {
                    selectedFormat = format;
                  },
                );
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(kLabelImport), findsOneWidget);
    expect(find.byType(DragAndDropArea), findsOneWidget);
    expect(find.text('cURL'), findsOneWidget);

    // Change format
    await tester.tap(find.text('cURL'));
    await tester.pumpAndSettle();
    
    await tester.tap(find.byType(DropdownMenuItem<ImportFormat>).last);
    await tester.pumpAndSettle();

    expect(selectedFormat, isNotNull);
  });
}
