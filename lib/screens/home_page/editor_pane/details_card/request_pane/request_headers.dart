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
  late int seed;
  final random = Random.secure();
  late List<NameValueModel> headerRows;
  late List<bool> isRowEnabledList;
  bool isAddingRow = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          selectedId,
          requestHeaders: headerRows.sublist(0, headerRows.length - 1),
          isHeaderEnabledList:
              isRowEnabledList.sublist(0, headerRows.length - 1),
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestHeaders?.length));
    var rH = ref.read(selectedRequestModelProvider)?.requestHeaders;
    bool isHeadersEmpty = rH == null || rH.isEmpty;
    List<NameValueModel> rows = (isHeadersEmpty)
        ? [
            kNameValueEmptyModel,
          ]
        : rH;
    headerRows = isHeadersEmpty ? rows : rows + [kNameValueEmptyModel];
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isHeaderEnabledList ??
            List.filled(rH?.length ?? 0, true, growable: true);
    isRowEnabledList.add(false);
    isAddingRow = false;

    DaviModel<NameValueModel> model = DaviModel<NameValueModel>(
      rows: headerRows,
      columns: [
        DaviColumn(
          name: 'Checkbox',
          width: 30,
          cellBuilder: (_, row) {
            int idx = row.index;
            bool isLast = idx + 1 == headerRows.length;
            return CheckBox(
              keyId: "$selectedId-$idx-headers-c-$seed",
              value: isRowEnabledList[idx],
              onChanged: isLast
                  ? null
                  : (value) {
                      setState(() {
                        isRowEnabledList[idx] = value!;
                      });
                      _onFieldChange(selectedId!);
                    },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
        ),
        DaviColumn(
          name: 'Header Name',
          width: 70,
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            bool isLast = idx + 1 == headerRows.length;
            return HeaderField(
              keyId: "$selectedId-$idx-headers-k-$seed",
              initialValue: headerRows[idx].name,
              hintText: "Add Header Name",
              onChanged: (value) {
                headerRows[idx] = headerRows[idx].copyWith(name: value);
                if (isLast && !isAddingRow) {
                  isAddingRow = true;
                  isRowEnabledList[idx] = true;
                  headerRows.add(kNameValueEmptyModel);
                  isRowEnabledList.add(false);
                }
                _onFieldChange(selectedId!);
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
            bool isLast = idx + 1 == headerRows.length;
            return CellField(
              keyId: "$selectedId-$idx-headers-v-$seed",
              initialValue: headerRows[idx].value,
              hintText: " Add Header Value",
              onChanged: (value) {
                headerRows[idx] = headerRows[idx].copyWith(value: value);
                if (isLast && !isAddingRow) {
                  isAddingRow = true;
                  isRowEnabledList[idx] = true;
                  headerRows.add(kNameValueEmptyModel);
                  isRowEnabledList.add(false);
                }
                _onFieldChange(selectedId!);
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
            bool isLast = row.index + 1 == headerRows.length;
            return InkWell(
              onTap: isLast
                  ? null
                  : () {
                      seed = random.nextInt(kRandMax);
                      if (headerRows.length == 2) {
                        setState(() {
                          headerRows = [
                            kNameValueEmptyModel,
                          ];
                          isRowEnabledList = [false];
                        });
                      } else {
                        headerRows.removeAt(row.index);
                        isRowEnabledList.removeAt(row.index);
                      }
                      _onFieldChange(selectedId!);
                    },
              child: Theme.of(context).brightness == Brightness.dark
                  ? kIconRemoveDark
                  : kIconRemoveLight,
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
              kVSpacer40,
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: kPb15,
            child: ElevatedButton.icon(
              onPressed: () {
                headerRows.add(kNameValueEmptyModel);
                isRowEnabledList.add(false);
                _onFieldChange(selectedId!);
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
