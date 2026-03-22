import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  dataTableShowLogs = false;
  testWidgets('Testing RequestDataTable', (WidgetTester tester) async {
    final List<NameValueModel> sampleData = [
      const NameValueModel(name: 'key1', value: 'Value1'),
      const NameValueModel(name: 'key2', value: 'value2'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RequestDataTable(
            rows: sampleData,
            keyName: 'Key',
            valueName: 'Value',
          ),
        ),
      ),
    );

    expect(find.byType(DataTable2), findsOneWidget);
    expect(find.byType(ReadOnlyTextField), findsNWidgets(4)); 

    expect(find.text('key1'), findsOneWidget);
    expect(find.text('Value1'), findsOneWidget);
    expect(find.text('key2'), findsOneWidget);
    expect(find.text('value2'), findsOneWidget);
  });
}