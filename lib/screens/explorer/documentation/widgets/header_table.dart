import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';

class HeaderTable extends StatelessWidget {
  final Map<String, ApiHeader> headers;

  const HeaderTable({super.key, required this.headers});

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
            columns: [
              DataColumn(label: Text('Header', style: _headerTextStyle(theme))),
              DataColumn(label: Text('Required', style: _headerTextStyle(theme))),
              DataColumn(label: Text('Type', style: _headerTextStyle(theme))),
              DataColumn(label: Text('Example', style: _headerTextStyle(theme))),
            ],
            rows: headers.entries.map((entry) => DataRow(
              cells: [
                DataCell(Text(entry.key, style: _cellTextStyle(theme, true))),
                DataCell(entry.value.required
                  ? const Icon(Icons.check, size: 18, color: Colors.green)
                  : const Icon(Icons.close, size: 18, color: Colors.grey)),
                DataCell(Text(entry.value.schema?.type ?? 'string',
                    style: _cellTextStyle(theme, true))),
                DataCell(Text(
                  entry.value.example ?? entry.value.schema?.example ?? '-',
                  style: _cellTextStyle(theme, true))),
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