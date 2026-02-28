import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/widgets/widgets.dart';

void main() {
  dataTableShowLogs = false;
  testWidgets('Testing RequestFormDataTable', (WidgetTester tester) async {
    const List<FormDataModel> sampleData = [
      FormDataModel(name: 'Key1', value: 'Value1', type: FormDataType.file),
      FormDataModel(name: 'Key2', value: 'Value2', type: FormDataType.text),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RequestFormDataTable(
            rows: sampleData,
            keyName: 'Key',
            valueName: 'Value',
          ),
        ),
      ),
    );

    expect(find.byType(DataTable2), findsOneWidget);
    expect(find.byType(ReadOnlyTextField), findsNWidgets(3));
    expect(find.byType(FormDataFileButton), findsOneWidget);

    expect(find.text('Key1'), findsOneWidget);
    expect(find.text('Value1'), findsOneWidget);
    expect(find.text('Key2'), findsOneWidget);
    expect(find.text('Value2'), findsOneWidget);
  });
}
