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
    seed = random.nextInt(kRandMax);
  }

  Widget _buildHeaderField(BuildContext context, DaviRow<KVRow> row) {
    String? activeId = ref.read(activeIdStateProvider);
    int idx = row.index;
    return TextFormField(
        key: Key("$activeId-$idx-headers-k-$seed"),
        initialValue: rows[idx].k,
        style: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintStyle: kCodeStyle.copyWith(
            color: Theme.of(context).colorScheme.outline.withOpacity(
                  kHintOpacity,
                ),
          ),
          hintText: "Add Header Name",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(
                    kHintOpacity,
                  ),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
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
        style: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintStyle: kCodeStyle.copyWith(
            color: Theme.of(context).colorScheme.outline.withOpacity(
                  kHintOpacity,
                ),
          ),
          hintText: " Add Header Value",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(
                    kHintOpacity,
                  ),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
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
    final activeId = ref.watch(activeIdStateProvider);
    final collection = ref.read(collectionStateNotifierProvider)!;
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final length = ref.watch(collectionStateNotifierProvider
        .select((value) => value![idIdx].requestHeaders?.length));
    rows = collection[idIdx].requestHeaders ?? [const KVRow("", "")];

    DaviModel<KVRow> model = DaviModel<KVRow>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'Header Name',
          grow: 1,
          cellBuilder: (_, row) => _buildHeaderField(context, row),
          sortable: false,
        ),
        DaviColumn(
          width: 30,
          cellBuilder: (BuildContext context, DaviRow<KVRow> row) {
            return Text(
              "=",
              style: kCodeStyle,
            );
          },
        ),
        DaviColumn(
          name: 'Header Value',
          grow: 1,
          cellBuilder: (_, row) => _buildValueField(context, row),
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
                seed = random.nextInt(kRandMax);
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
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: kBorderRadius12,
          ),
          margin: kP10,
          child: Column(
            children: [
              Expanded(
                child: DaviTheme(
                  data: kTableThemeData,
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
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
