import 'dart:math';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class MQTTEditRequestProperties extends ConsumerStatefulWidget {
  const MQTTEditRequestProperties({super.key});

  @override
  ConsumerState<MQTTEditRequestProperties> createState() =>
      MQTTEditRequestPropertiesState();
}

class MQTTEditRequestPropertiesState
    extends ConsumerState<MQTTEditRequestProperties> {
  final random = Random.secure();
  late List<NameValueModel> headerRows;
  late List<bool> isRowEnabledList;
  late int seed;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          selectedId,
          requestHeaders: headerRows,
          isHeaderEnabledList: isRowEnabledList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final length = ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestHeaders?.length));
    var rH = ref.read(selectedRequestModelProvider)?.requestHeaders;
    headerRows = (rH == null || rH.isEmpty)
        ? [
            kNameValueEmptyModel,
          ]
        : rH;
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isHeaderEnabledList ??
            List.filled(headerRows.length, true, growable: true);
    bool isAddingRow = false;
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
                  child: DataTable2(
                columnSpacing: 12,
                dividerThickness: 0,
                horizontalMargin: 0,
                headingRowHeight: 0,
                dataRowHeight: kDataTableRowHeight,
                bottomMargin: kDataTableBottomPadding,
                isVerticalScrollBarVisible: true,
                columns: const [
                  DataColumn2(
                    label: Text('Checkbox'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Header Name'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    size: ColumnSize.S,
                    label: Text('='),
                  ),
                  DataColumn2(
                    size: ColumnSize.L,
                    label: Text('Header Value'),
                  ),
                  DataColumn2(
                    size: ColumnSize.S,
                    label: Text(" "),
                  ),
                ],
                rows: List<DataRow>.generate(
                  headerRows.length,
                  (index) {
                    bool isLast = index + 1 == headerRows.length;
                    return DataRow(
                      key: ValueKey("$selectedId-$index-headers-row-$seed"),
                      cells: [
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
                              headerRows[index] =
                                  headerRows[index].copyWith(name: value);
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
                          CellField(
                            keyId: "$selectedId-$index-headers-v-$seed",
                            initialValue: headerRows[index].value,
                            hintText: kHintAddValue,
                            onChanged: (value) {
                              headerRows[index] =
                                  headerRows[index].copyWith(value: value);
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
                            child:
                                Theme.of(context).brightness == Brightness.dark
                                    ? kIconRemoveDark
                                    : kIconRemoveLight,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )),
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
                "Add Properties",
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
