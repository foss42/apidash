import 'package:flutter/material.dart';
import 'package:apidash/models/api_explorer_models.dart';

class PropertiesTable extends StatelessWidget {
  final Map<String, ApiSchema> properties;

  const PropertiesTable({super.key, required this.properties});

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
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(3),
          },
          border: TableBorder(
            horizontalInside: BorderSide(
              color: colors.outline.withOpacity(0.1),
            ),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: colors.surfaceVariant.withOpacity(0.3),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Type',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            ...properties.entries.map((entry) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    entry.value.type ?? 'unknown',
                    style: const TextStyle(fontFamily: 'RobotoMono'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(entry.value.description ?? '-'),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}