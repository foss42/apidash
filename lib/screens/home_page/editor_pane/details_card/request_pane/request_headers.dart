import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';

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
          headers: headerRows.sublist(0, headerRows.length - 1),
          isHeaderEnabledList:
              isRowEnabledList.sublist(0, headerRows.length - 1),
        );
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.headers?.length));
    var rH = ref.read(selectedRequestModelProvider)?.httpRequestModel?.headers;
    bool isHeadersEmpty = rH == null || rH.isEmpty;
    headerRows = isHeadersEmpty
        ? [
            kNameValueEmptyModel,
          ]
        : rH + [kNameValueEmptyModel];
    isRowEnabledList = [
      ...(ref
              .read(selectedRequestModelProvider)
              ?.httpRequestModel
              ?.isHeaderEnabledList ??
          List.filled(rH?.length ?? 0, true, growable: true))
    ];
    isRowEnabledList.add(false);
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text(kNameCheckbox),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text(kNameHeader),
      ),
      DataColumn2(
        label: Text('='),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text(kNameValue),
      ),
      DataColumn2(
        label: Text(''),
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
                hintText: kHintAddName,
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
              Center(
                child: Text(
                  "=",
                  style: kCodeStyle,
                ),
              ),
            ),
            DataCell(
              EnvCellField(
                keyId: "$selectedId-$index-headers-v-$seed",
                initialValue: headerRows[index].value,
                hintText: kHintAddValue,
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
                kLabelAddHeader,
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
