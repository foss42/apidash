import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
          items: [value].map((item) {
            return DropdownMenuItem<String>(
              value: item, // item must be a String
              child: Text(item),
            );
          }).toList(),
          onChanged: (_) {},
        );
      case "chart":
        return SizedBox(
          width: 100,
          height: 100,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(toY: (value as num).toDouble(), width: 20)
                ])
              ],
            ),
          ),
        );
      case "date":
        return Text(value.toString().split('T').first);
      case "slider":
        return Slider(
          value: (value as num).toDouble(),
          onChanged: (_) {},
          min: 0,
          max: 100,
        );
      default:
        return Text(value.toString());
    }
  }
}
