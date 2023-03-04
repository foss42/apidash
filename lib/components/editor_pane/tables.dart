import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:davi/davi.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class EditRequestURLParams extends ConsumerStatefulWidget {
  const EditRequestURLParams({Key? key}) : super(key: key);

  @override
  ConsumerState<EditRequestURLParams> createState() =>
      EditRequestURLParamsState();
}

class EditRequestURLParamsState extends ConsumerState<EditRequestURLParams> {
  late List<KVRow> rows;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildParamField(BuildContext context, DaviRow<KVRow> row) {
    String? activeId = ref.read(activeItemIdStateProvider);
    int idx = row.index;
    return TextFormField(
        key: Key("$activeId-$idx-params-k"),
        initialValue: rows[idx].k,
        decoration: const InputDecoration(hintText: "Add URL Parameter"),
        onChanged: (value) {
          rows[idx] = rows[idx].copyWith(k: value);
          _onFieldChange(activeId!);
        });
  }

  Widget _buildValueField(BuildContext context, DaviRow<KVRow> row) {
    String? activeId = ref.read(activeItemIdStateProvider);
    int idx = row.index;
    return TextFormField(
        key: Key("$activeId-$idx-params-v"),
        initialValue: rows[idx].v,
        decoration: const InputDecoration(hintText: "Add Value"),
        onChanged: (value) {
          rows[idx] = rows[idx].copyWith(v: value);
          _onFieldChange(activeId!);
        });
  }

  void _onFieldChange(String activeId) {
    ref
        .read(collectionStateNotifierProvider.notifier)
        .update(activeId, requestParams: rows);
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeItemIdStateProvider);
    rows = ref
            .read(collectionStateNotifierProvider.notifier)
            .getRequestModel(activeId!)
            .requestParams ??
        [];
    DaviModel<KVRow> model = DaviModel<KVRow>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'URL Parameter',
          grow: 1,
          cellBuilder: _buildParamField,
        ),
        DaviColumn(
          name: 'Value',
          grow: 1,
          cellBuilder: _buildValueField,
        ),
      ],
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  rows.add(const KVRow("", ""));
                  model.addRow(const KVRow("", ""));
                },
                child: const Text("+ Add Param"),
              ),
            ],
          ),
        ),
        Expanded(
          child: DaviTheme(
            data: DaviThemeData(
              columnDividerThickness: 1,
              columnDividerColor: Colors.grey.shade100,
              row: RowThemeData(dividerColor: Colors.grey.shade100),
              decoration: const BoxDecoration(
                border: Border(),
              ),
              header: HeaderThemeData(
                color: Colors.grey.shade100,
                columnDividerColor: Colors.grey.shade100,
                bottomBorderHeight: 1,
              ),
              headerCell: const HeaderCellThemeData(
                alignment: Alignment.center,
              ),
            ),
            child: Davi<KVRow>(model),
          ),
        ),
      ],
    );
  }
}

class EditRequestHeaders extends ConsumerStatefulWidget {
  const EditRequestHeaders({Key? key}) : super(key: key);

  @override
  ConsumerState<EditRequestHeaders> createState() => EditRequestHeadersState();
}

class EditRequestHeadersState extends ConsumerState<EditRequestHeaders> {
  late List<KVRow> rows;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildHeaderField(BuildContext context, DaviRow<KVRow> row) {
    String? activeId = ref.read(activeItemIdStateProvider);
    int idx = row.index;
    return TextFormField(
        key: Key("$activeId-$idx-headers-k"),
        initialValue: rows[idx].k,
        decoration: const InputDecoration(hintText: "Add Header Name"),
        onChanged: (value) {
          rows[idx] = rows[idx].copyWith(k: value);
          _onFieldChange(activeId!);
        });
  }

  Widget _buildValueField(BuildContext context, DaviRow<KVRow> row) {
    String? activeId = ref.read(activeItemIdStateProvider);
    int idx = row.index;
    return TextFormField(
        key: Key("$activeId-$idx-headers-v"),
        initialValue: rows[idx].v,
        decoration: const InputDecoration(hintText: "Add Header Value"),
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
    final activeId = ref.watch(activeItemIdStateProvider);
    rows = ref
            .read(collectionStateNotifierProvider.notifier)
            .getRequestModel(activeId!)
            .requestHeaders ??
        [];
    DaviModel<KVRow> model = DaviModel<KVRow>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'Header Name',
          grow: 1,
          cellBuilder: _buildHeaderField,
        ),
        DaviColumn(
          name: 'Header Value',
          grow: 1,
          cellBuilder: _buildValueField,
        ),
      ],
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  rows.add(const KVRow("", ""));
                  model.addRow(const KVRow("", ""));
                },
                child: const Text("+ Add Header"),
              ),
            ],
          ),
        ),
        Expanded(
          child: DaviTheme(
            data: DaviThemeData(
              columnDividerThickness: 1,
              columnDividerColor: Colors.grey.shade100,
              row: RowThemeData(dividerColor: Colors.grey.shade100),
              decoration: const BoxDecoration(
                border: Border(),
              ),
              header: HeaderThemeData(
                color: Colors.grey.shade100,
                columnDividerColor: Colors.grey.shade100,
                bottomBorderHeight: 1,
              ),
              headerCell: const HeaderCellThemeData(
                alignment: Alignment.center,
              ),
            ),
            child: Davi<KVRow>(model),
          ),
        ),
      ],
    );
  }
}
