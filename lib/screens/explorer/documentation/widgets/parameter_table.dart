import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';
import 'parameter_location.dart';

class ParameterTable extends StatelessWidget {
  final List<ApiParameter> parameters;

  const ParameterTable({super.key, required this.parameters});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outline.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 16,
            dividerThickness: 1,
            dataRowMinHeight: 48,
            dataRowMaxHeight: 72,
            columns: [
              DataColumn(label: Text('Name', style: _headerTextStyle(theme))),
              DataColumn(label: Text('Location', style: _headerTextStyle(theme))),
              DataColumn(label: Text('Required', style: _headerTextStyle(theme))),
              DataColumn(label: Text('Type', style: _headerTextStyle(theme))),
              DataColumn(label: Text('Description', style: _headerTextStyle(theme))),
            ],
            rows: parameters.map((param) => DataRow(
              cells: [
                DataCell(Text(param.name, style: _cellTextStyle(theme, true))),
                DataCell(ParameterLocation(location: param.inLocation)),
                DataCell(param.required
                  ? const Icon(Icons.check, size: 18, color: Colors.green)
                  : const Icon(Icons.close, size: 18, color: Colors.grey)),
                DataCell(Text(param.schema?.type ?? 'string', 
                    style: _cellTextStyle(theme, true))),
                DataCell(Text(param.description ?? '-',
                    style: _cellTextStyle(theme, false))),
              ],
            )).toList(),
          ),
        ),
      ),
    );
  }

  TextStyle _headerTextStyle(ThemeData theme) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withOpacity(0.7),
    );
  }

  TextStyle _cellTextStyle(ThemeData theme, bool monospace) {
    return TextStyle(
      fontFamily: monospace ? 'RobotoMono' : null,
      color: theme.colorScheme.onSurface,
    );
  }
}