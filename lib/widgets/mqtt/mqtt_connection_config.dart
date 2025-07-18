import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/consts.dart';

class MQTTConnectionConfig extends StatelessWidget {
  final TextEditingController clientIdController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isConnected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const MQTTConnectionConfig({
    super.key,
    required this.clientIdController,
    required this.usernameController,
    required this.passwordController,
    required this.isConnected,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final clrScheme = Theme.of(context).colorScheme;

    final List<DataColumn> columns = [
      const DataColumn2(
        label: Text(''),
        fixedWidth: 30,
      ),
      const DataColumn2(
        label: Text('Parameter'),
      ),
      const DataColumn2(
        label: Text('='),
        fixedWidth: 30,
      ),
      const DataColumn2(
        label: Text('Value'),
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

    final List<DataRow> dataRows = [
      DataRow(
        cells: <DataCell>[
          const DataCell(SizedBox.shrink()),
          const DataCell(Text('Username')),
          const DataCell(Text('=')),
          DataCell(
            TextFormField(
              controller: usernameController,
              decoration: fieldDecoration.copyWith(
                hintText: 'Optional',
              ),
              enabled: !isConnected,
              onChanged: (value) {
                // Update username in RequestModel.mqttRequestModel
                // (Assume context has access to ref or pass a callback)
              },
            ),
          ),
          const DataCell(SizedBox.shrink()),
        ],
      ),
      DataRow(
        cells: <DataCell>[
          const DataCell(SizedBox.shrink()),
          const DataCell(Text('Password')),
          const DataCell(Text('=')),
          DataCell(
            TextFormField(
              controller: passwordController,
              decoration: fieldDecoration.copyWith(
                hintText: 'Optional',
              ),
              obscureText: true,
              enabled: !isConnected,
              onChanged: (value) {
                // Update password in RequestModel.mqttRequestModel
              },
            ),
          ),
          const DataCell(SizedBox.shrink()),
        ],
      ),
      // ... Keep Alive, Last-Will, etc. ...
    ];

    return Column(
      children: [
        Expanded(
          child: Container(
            margin: kPh10t10,
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
        ),
      ],
    );
  }
} 