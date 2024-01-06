import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:davi/davi.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class EditRequestHeaders extends ConsumerStatefulWidget {
  const EditRequestHeaders({super.key});

  @override
  ConsumerState<EditRequestHeaders> createState() => EditRequestHeadersState();
}

class EditRequestHeadersState extends ConsumerState<EditRequestHeaders> {
  late List<NameValueModel> rows;
  late List<bool> isRowEnabledList;
  final random = Random.secure();
  late int seed;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String activeId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          activeId,
          requestHeaders: rows,
          isHeaderEnabledList: isRowEnabledList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final length = ref.watch(activeRequestModelProvider
        .select((value) => value?.requestHeaders?.length));
    var rH = ref.read(activeRequestModelProvider)?.requestHeaders;
    rows = (rH == null || rH.isEmpty)
        ? [
            kNameValueEmptyModel,
          ]
        : rH;
    isRowEnabledList =
        ref.read(activeRequestModelProvider)?.isHeaderEnabledList ??
            List.filled(rows.length, true, growable: true);

    DaviModel<NameValueModel> model = DaviModel<NameValueModel>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'Checkbox',
          width: 36,
          cellBuilder: (_, row) {
            int idx = row.index;
            return CheckBox(
              keyId: "$activeId-$idx-headers-c-$seed",
              value: isRowEnabledList[idx],
              onChanged: (value) {
                setState(() {
                  isRowEnabledList[idx] = value!;
                });
                _onFieldChange(activeId!);
              },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
        ),
        DaviColumn(
          name: 'Header Name',
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return HeaderField(
              keyId: "$activeId-$idx-headers-k-$seed",
              initialValue: rows[idx].name,
              hintText: "Add Header Name",
              onChanged: (value) {
                rows[idx] = rows[idx].copyWith(name: value);
                _onFieldChange(activeId!);
              },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
          sortable: false,
        ),
        DaviColumn(
          width: 30,
          cellBuilder: (_, row) {
            return Text(
              "=",
              style: kCodeStyle,
            );
          },
        ),
        DaviColumn(
          name: 'Header Value',
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return CellField(
              keyId: "$activeId-$idx-headers-v-$seed",
              initialValue: rows[idx].value,
              hintText: " Add Header Value",
              onChanged: (value) {
                rows[idx] = rows[idx].copyWith(value: value);
                _onFieldChange(activeId!);
              },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
          sortable: false,
        ),
        DaviColumn(
          pinStatus: PinStatus.none,
          width: 30,
          cellBuilder: (_, row) {
            return InkWell(
              child: Theme.of(context).brightness == Brightness.dark
                  ? kIconRemoveDark
                  : kIconRemoveLight,
              onTap: () {
                seed = random.nextInt(kRandMax);
                if (rows.length == 1) {
                  setState(() {
                    rows = [
                      kNameValueEmptyModel,
                    ];
                    isRowEnabledList = [true];
                  });
                } else {
                  rows.removeAt(row.index);
                  isRowEnabledList.removeAt(row.index);
                }
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
                  child: Davi<NameValueModel>(model),
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
                rows.add(kNameValueEmptyModel);
                isRowEnabledList.add(true);
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
