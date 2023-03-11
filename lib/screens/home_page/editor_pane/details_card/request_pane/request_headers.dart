import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:davi/davi.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class EditRequestHeaders extends ConsumerStatefulWidget {
  const EditRequestHeaders({Key? key}) : super(key: key);

  @override
  ConsumerState<EditRequestHeaders> createState() => EditRequestHeadersState();
}

class EditRequestHeadersState extends ConsumerState<EditRequestHeaders> {
  late List<KVRow> rows;
  final random = Random.secure();
  late int seed;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(randRange);
  }

  Widget _buildHeaderField(BuildContext context, DaviRow<KVRow> row) {
    String? activeId = ref.read(activeIdStateProvider);
    int idx = row.index;
    return TextFormField(
        key: Key("$activeId-$idx-headers-k-$seed"),
        initialValue: rows[idx].k,
        style: codeStyle,
        decoration: InputDecoration(
          hintStyle: codeHintStyle,
          hintText: "Add Header Name",
        ),
        onChanged: (value) {
          rows[idx] = rows[idx].copyWith(k: value);
          _onFieldChange(activeId!);
        });
  }

  Widget _buildValueField(BuildContext context, DaviRow<KVRow> row) {
    String? activeId = ref.read(activeIdStateProvider);
    int idx = row.index;
    return TextFormField(
        key: Key("$activeId-$idx-headers-v-$seed"),
        initialValue: rows[idx].v,
        style: codeStyle,
        decoration: InputDecoration(
          hintStyle: codeHintStyle,
          hintText: "Add Header Value",
        ),
        onChanged: (value) {
          rows[idx] = rows[idx].copyWith(v: value);
          _onFieldChange(activeId!);
        });
  }

  void _onFieldChange(String activeId) {
    ref
        .read(collectionStateNotifierProvider.notifier)
        .update(activeId, requestHeaders: rows);
  }

  @override
  Widget build(BuildContext context) {
    final tableThemeData = DaviThemeData(
      columnDividerThickness: 1,
      columnDividerColor: colorGrey100,
      row: RowThemeData(dividerColor: colorGrey100),
      decoration: const BoxDecoration(
        border: Border(),
      ),
      header: HeaderThemeData(
        color: Theme.of(context).colorScheme.surface,
        columnDividerColor: colorGrey100,
        bottomBorderHeight: 1,
        bottomBorderColor: colorGrey100,
      ),
      headerCell: const HeaderCellThemeData(
        alignment: Alignment.center,
        textStyle: null,
      ),
    );

    final activeId = ref.watch(activeIdStateProvider);
    /*final collection = ref.watch(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    rows = collection[idIdx].requestHeaders ?? [const KVRow("", "")];*/
    final collection = ref.read(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final length = ref.watch(collectionStateNotifierProvider
        .select((value) => value[idIdx].requestHeaders?.length));
    rows = collection[idIdx].requestHeaders ?? [const KVRow("", "")];
    DaviModel<KVRow> model = DaviModel<KVRow>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'Header Name',
          grow: 1,
          cellBuilder: _buildHeaderField,
          sortable: false,
        ),
        DaviColumn(
          name: 'Header Value',
          grow: 1,
          cellBuilder: _buildValueField,
          sortable: false,
        ),
        DaviColumn(
          pinStatus: PinStatus.none,
          width: 30,
          cellBuilder: (BuildContext context, DaviRow<KVRow> row) {
            return InkWell(
              child: Icon(
                Icons.remove_circle,
                size: 16,
                color: Colors.red.withOpacity(0.9),
              ),
              onTap: () {
                rows.removeAt(row.index);
                seed = random.nextInt(randRange);
                _onFieldChange(activeId!);
              },
            );
          },
        ),
      ],
    );
    return Stack(
      children: [
        Container(
          decoration: tableContainerDecoration,
          margin: p5,
          child: Column(
            children: [
              Expanded(
                child: DaviTheme(
                  data: tableThemeData,
                  child: Davi<KVRow>(model),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton.icon(
              onPressed: () {
                rows.add(const KVRow("", ""));
                _onFieldChange(activeId!);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Header",
                style: textStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
