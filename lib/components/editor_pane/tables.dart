import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:davi/davi.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../styles.dart';

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
        style: codeStyle,
        decoration: InputDecoration(
          hintStyle: codeStyle,
          hintText: "Add URL Parameter",
        ),
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
        style: codeStyle,
        decoration: InputDecoration(
          hintStyle: codeStyle,
          hintText: "Add Value",
        ),
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
                model.addRow(const KVRow("", ""));
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Param",
                style: textStyleButton,
              ),
            ),
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
        style: codeStyle,
        decoration: InputDecoration(
          hintStyle: codeStyle,
          hintText: "Add Header Name",
        ),
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
        style: codeStyle,
        decoration: InputDecoration(
          hintStyle: codeStyle,
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
                model.addRow(const KVRow("", ""));
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
