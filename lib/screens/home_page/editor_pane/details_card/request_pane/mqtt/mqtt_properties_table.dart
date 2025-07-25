import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/consts.dart';

class MQTTPropertiesTable extends StatefulWidget {
  const MQTTPropertiesTable({super.key});

  @override
  State<MQTTPropertiesTable> createState() => _MQTTPropertiesTableState();
}

class _MQTTPropertiesTableState extends State<MQTTPropertiesTable> {
  List<_PropertyRow> rows = [
    _PropertyRow(enabled: true, name: '', value: ''),
  ];

  void _addRow() {
    setState(() {
      rows.add(_PropertyRow(enabled: false, name: '', value: ''));
    });
  }

  void _removeRow(int index) {
    setState(() {
      rows.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final clrScheme = Theme.of(context).colorScheme;

    final List<DataColumn> columns = [
      const DataColumn2(
        label: Text(''),
        fixedWidth: 30,
      ),
      const DataColumn2(
        label: Text('Property Name'),
      ),
      const DataColumn2(
        label: Text('='),
        fixedWidth: 30,
      ),
      const DataColumn2(
        label: Text('Property Value'),
      ),
      const DataColumn2(
        label: Text(''),
        fixedWidth: 32,
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

    final List<DataRow> dataRows = rows
        .map<DataRow>(
          (row) => DataRow(
            cells: <DataCell>[
              DataCell(
                Checkbox(
                  value: row.enabled,
                  onChanged: (val) {
                    setState(() {
                      row.enabled = val ?? false;
                    });
                  },
                ),
              ),
              DataCell(
                TextFormField(
                  initialValue: row.name,
                  decoration: fieldDecoration,
                  onChanged: (val) {
                    row.name = val;
                  },
                ),
              ),
              const DataCell(
                Text('='),
              ),
              DataCell(
                TextFormField(
                  initialValue: row.value,
                  decoration: fieldDecoration,
                  onChanged: (val) {
                    row.value = val;
                  },
                ),
              ),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _removeRow(rows.indexOf(row)),
                ),
              ),
            ],
          ),
        )
        .toList();

    return Stack(
      children: [
        Container(
          margin: kPh10t10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              if (!kIsMobile) kVSpacer40,
            ],
          ),
        ),
        if (!kIsMobile)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: kPb15,
              child: ElevatedButton.icon(
                onPressed: _addRow,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add Property',
                  style: kTextStyleButton,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PropertyRow {
  bool enabled;
  String name;
  String value;
  _PropertyRow({required this.enabled, required this.name, required this.value});
} 