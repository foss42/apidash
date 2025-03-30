import 'package:flutter/material.dart';

class DynamicTable extends StatelessWidget {
  final Map<String, dynamic> schema;
  final List<Map<String, dynamic>> data;

  const DynamicTable({super.key, required this.schema, required this.data});

  @override
  Widget build(BuildContext context) {
    final columns = schema["columns"] as List;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns.map<DataColumn>((col) {
          return DataColumn(label: Text(col["field"].toString().toUpperCase()));
        }).toList(),
        rows: data.map<DataRow>((row) {
          return DataRow(
            cells: columns.map<DataCell>((col) {
              final value = row[col["field"]];
              final type = col["type"];
              return DataCell(_buildCell(type, value));
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCell(String type, dynamic value) {
    switch (type) {
      case "toggle":
        return Switch(value: value ?? false, onChanged: (_) {});
      case "dropdown":
        return DropdownButton<String>(
          value: value,
          items: [value].map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (_) {},
        );
      case "chart":
        return Text("📊 ${value.toString()}"); // placeholder
      default:
        return Text(value.toString());
    }
  }
}
