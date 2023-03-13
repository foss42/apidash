import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class ResponseHeaders extends ConsumerStatefulWidget {
  const ResponseHeaders({super.key});

  @override
  ConsumerState<ResponseHeaders> createState() => _ResponseHeadersState();
}

class _ResponseHeadersState extends ConsumerState<ResponseHeaders> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final collection = ref.watch(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final requestHeaders =
        collection[idIdx].responseModel?.requestHeaders ?? {};
    final responseHeaders = collection[idIdx].responseModel?.headers ?? {};
    return Padding(
      padding: kPh20v5,
      child: ListView(
        children: [
          getHeaderBox(context, responseHeaders, "Response Headers"),
          if (responseHeaders.isNotEmpty) kVSpacer5,
          if (responseHeaders.isNotEmpty)
            getTable(
              context,
              responseHeaders,
              ["Header Name", "Header Value"],
            ),
          kVSpacer10,
          getHeaderBox(context, requestHeaders, "Request Headers"),
          if (requestHeaders.isNotEmpty) kVSpacer5,
          if (requestHeaders.isNotEmpty)
            getTable(
              context,
              requestHeaders,
              ["Header Name", "Header Value"],
            ),
        ],
      ),
    );
  }

  Widget getHeaderBox(BuildContext context, Map map, String name) {
    return SizedBox(
      height: kHeaderHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$name (${map.length} items)",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (map.isNotEmpty)
            TextButton(
              onPressed: () async {
                await Clipboard.setData(
                    ClipboardData(text: encoder.convert(map)));
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.content_copy,
                    size: 20,
                  ),
                  Text("Copy")
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget getTable(BuildContext context, Map map, List<String> headers) {
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
        getHeaderRow(context, headers),
        ...getTableRowsFromMap(context, map),
      ],
    );
  }

  TableRow getHeaderRow(BuildContext context, List<String> headers) {
    return TableRow(
      children: headers
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
    );
  }

  List<TableRow> getTableRowsFromMap(BuildContext context, Map map) {
    return map.entries
        .map<TableRow>(
          (entry) => TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: kP1,
                  child: SelectableText(
                    entry.key,
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
        )
        .toList();
  }
}
