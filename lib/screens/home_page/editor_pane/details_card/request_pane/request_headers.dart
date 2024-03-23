import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
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
    headerRows = isHeadersEmpty
        ? [
            kNameValueEmptyModel,
          ]
        : rH + [kNameValueEmptyModel];
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isHeaderEnabledList ??
            List.filled(rH?.length ?? 0, true, growable: true);
    isRowEnabledList.add(false);
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text('Checkbox'),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text('Header Name'),
      ),
      DataColumn2(
        label: Text('='),
        fixedWidth: 22,
      ),
      DataColumn2(
        label: Text('Header Value'),
      ),
      DataColumn2(
        label: Text('Remove'),
        fixedWidth: 32,
      ),
    ];

    List<DataRow> dataRows = List<DataRow>.generate(
      headerRows.length,
      (index) {
        bool isLast = index + 1 == headerRows.length;
        return DataRow(
          key: ValueKey("$selectedId-$index-headers-row-$seed"),
          cells: <DataCell>[
            DataCell(
              CheckBox(
                keyId: "$selectedId-$index-headers-c-$seed",
                value: isRowEnabledList[index],
                onChanged: isLast
                    ? null
                    : (value) {
                        setState(() {
                          isRowEnabledList[index] = value!;
                        });
                        _onFieldChange(selectedId!);
                      },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              HeaderField(
                keyId: "$selectedId-$index-headers-k-$seed",
                initialValue: headerRows[index].name,
                hintText: "Add Header Name",
                onChanged: (value) {
                  headerRows[index] = headerRows[index].copyWith(name: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    isRowEnabledList[index] = true;
                    headerRows.add(kNameValueEmptyModel);
                    isRowEnabledList.add(false);
                  }
                  _onFieldChange(selectedId!);
                },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              Text(
                "=",
                style: kCodeStyle,
              ),
            ),
            DataCell(
              CellField(
                keyId: "$selectedId-$index-headers-v-$seed",
                initialValue: headerRows[index].value,
                hintText: " Add Header Value",
                onChanged: (value) {
                  headerRows[index] = headerRows[index].copyWith(value: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    isRowEnabledList[index] = true;
                    headerRows.add(kNameValueEmptyModel);
                    isRowEnabledList.add(false);
                  }
                  _onFieldChange(selectedId!);
                },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              InkWell(
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
                          headerRows.removeAt(index);
                          isRowEnabledList.removeAt(index);
                        }
                        _onFieldChange(selectedId!);
                      },
                child: Theme.of(context).brightness == Brightness.dark
                    ? kIconRemoveDark
                    : kIconRemoveLight,
              ),
            ),
          ],
        );
      },
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
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(scrollbarTheme: kDataTableScrollbarTheme),
                  child: DataTable2(
                    columnSpacing: 12,
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    headingRowHeight: 0,
                    dataRowHeight: kDataTableRowHeight,
                    bottomMargin: kDataTableBottomPadding,
                    isVerticalScrollBarVisible: true,
                    columns: columns,
                    rows: dataRows,
                  ),
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
