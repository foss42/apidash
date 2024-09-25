import 'package:apidash/widgets/widgets.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  dataTableShowLogs = false;
  testWidgets('Testing RequestDataTable', (WidgetTester tester) async {
    final Map<String, String> sampleData = {
      'Key1': 'Value1',
      'Key2': 'Value2',
    };

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

    expect(find.text('Key1'), findsOneWidget);
    expect(find.text('Value1'), findsOneWidget);
    expect(find.text('Key2'), findsOneWidget);
    expect(find.text('Value2'), findsOneWidget);
  });
}
