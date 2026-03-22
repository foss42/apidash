import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart'; 
import 'field_read_only.dart';

class RequestDataTable extends StatelessWidget {
  const RequestDataTable({
    super.key,
    required this.rows,
    this.keyName,
    this.valueName,
  });

  final List<NameValueModel> rows;
  final String? keyName;
  final String? valueName;

  @override
  Widget build(BuildContext context) {
    final clrScheme = Theme.of(context).colorScheme;

    final List<DataColumn> columns = [
      const DataColumn2(
        label: Text(''),
        fixedWidth: 8,
      ),
      DataColumn2(
        label: Text(keyName ?? kNameField),
      ),
      const DataColumn2(
        label: Text('='),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text(valueName ?? kNameValue),
      ),
      const DataColumn2(
        label: Text(''),
        fixedWidth: 8,
      ),
    ];

    final fieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.only(bottom: 12),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: clrScheme.outlineVariant,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: clrScheme.surfaceContainerHighest,
        ),
      ),
    );

    final List<DataRow> dataRows = rows.map<DataRow>((NameValueModel row) {
      return DataRow(
        cells: <DataCell>[
          const DataCell(kHSpacer5),
          DataCell(
            ReadOnlyTextField(
              initialValue: row.name,
              decoration: fieldDecoration,
            ),
          ),
          const DataCell(
            Text('='),
          ),
          DataCell(
            ReadOnlyTextField(
              initialValue: row.value,
              decoration: fieldDecoration,
            ),
          ),
          const DataCell(kHSpacer5),
        ],
      );
    }).toList();

    return Container(
      margin: kP10,
      child: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context)
                  .copyWith(scrollbarTheme: kDataTableScrollbarTheme),
              child: DataTable2(
                columnSpacing: 12,
                dividerThickness: 0,
                horizontalMargin: 0,
                headingRowHeight: 0,
                dataRowHeight: kDataTableRowHeight,
                bottomMargin: kDataTableBottomPadding,
                isVerticalScrollBarVisible: true,
                columns: columns,
                rows: dataRows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}