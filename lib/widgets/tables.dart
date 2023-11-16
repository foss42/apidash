import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class MapTable extends StatefulWidget {
  const MapTable(
      {super.key,
      required this.map,
      required this.colNames,
      this.firstColumnHeaderCase = false});

  final Map map;
  final List<String> colNames;
  final bool firstColumnHeaderCase;

  @override
  State<MapTable> createState() => _MapTableState();
}

class _MapTableState extends State<MapTable> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ),
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: widget.colNames
              .map<TableCell>(
                (e) => TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: kP1,
                    child: SelectableText(
                      e,
                      style: kCodeStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        ...widget.map.entries.map<TableRow>(
          (entry) => TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: kP1,
                  child: SelectableText(
                    widget.firstColumnHeaderCase
                        ? formatHeaderCase(entry.key)
                        : entry.key,
                    style: kCodeStyle.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: kP1,
                  child: SelectableText(
                    entry.value,
                    style: kCodeStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
