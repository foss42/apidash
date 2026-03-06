import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/utils/utils.dart';

class EditRequestURLParams extends ConsumerStatefulWidget {
  const EditRequestURLParams({super.key});

  @override
  ConsumerState<EditRequestURLParams> createState() =>
      EditRequestURLParamsState();
}

class EditRequestURLParamsState extends ConsumerState<EditRequestURLParams> {
  late int seed;
  final random = Random.secure();
  late List<NameValueModel> paramRows;
  late List<bool> isRowEnabledList;
  bool isAddingRow = false;
  bool isBulkMode = false;
  final TextEditingController bulkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange() {
    ref.read(collectionStateNotifierProvider.notifier).update(
          params: paramRows.sublist(0, paramRows.length - 1),
          isParamEnabledList: isRowEnabledList.sublist(0, paramRows.length - 1),
        );
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.params?.length));
    var rP = ref.read(selectedRequestModelProvider)?.httpRequestModel?.params;
    bool isParamsEmpty = rP == null || rP.isEmpty;
    paramRows = isParamsEmpty
        ? [
            kNameValueEmptyModel,
          ]
        : rP + [kNameValueEmptyModel];
    isRowEnabledList = [
      ...(ref
              .read(selectedRequestModelProvider)
              ?.httpRequestModel
              ?.isParamEnabledList ??
          List.filled(rP?.length ?? 0, true, growable: true))
    ];
    isRowEnabledList.add(false);
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text(kNameCheckbox),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text(kNameURLParam),
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
      paramRows.length,
      (index) {
        bool isLast = index + 1 == paramRows.length;
        return DataRow(
          key: ValueKey("$selectedId-$index-params-row-$seed"),
          cells: <DataCell>[
            DataCell(
              ADCheckBox(
                keyId: "$selectedId-$index-params-c-$seed",
                value: isRowEnabledList[index],
                onChanged: isLast
                    ? null
                    : (value) {
                        setState(() {
                          isRowEnabledList[index] = value!;
                        });
                        _onFieldChange();
                      },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              EnvCellField(
                keyId: "$selectedId-$index-params-k-$seed",
                initialValue: paramRows[index].name,
                hintText: kHintAddURLParam,
                onChanged: (value) {
                  paramRows[index] = paramRows[index].copyWith(name: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    isRowEnabledList[index] = true;
                    paramRows.add(kNameValueEmptyModel);
                    isRowEnabledList.add(false);
                  }
                  _onFieldChange();
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
                keyId: "$selectedId-$index-params-v-$seed",
                initialValue: paramRows[index].value,
                hintText: kHintAddValue,
                onChanged: (value) {
                  paramRows[index] = paramRows[index].copyWith(value: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    isRowEnabledList[index] = true;
                    paramRows.add(kNameValueEmptyModel);
                    isRowEnabledList.add(false);
                  }
                  _onFieldChange();
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
                        if (paramRows.length == 2) {
                          setState(() {
                            paramRows = [
                              kNameValueEmptyModel,
                            ];
                            isRowEnabledList = [false];
                          });
                        } else {
                          paramRows.removeAt(index);
                          isRowEnabledList.removeAt(index);
                        }
                        _onFieldChange();
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Bulk Edit",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              kHSpacer5,
              Switch.adaptive(
                value: isBulkMode,
                onChanged: (value) {
                  setState(() {
                    isBulkMode = value;
                    if (isBulkMode) {
                      var rP = ref.read(selectedRequestModelProvider)
                              ?.httpRequestModel
                              ?.params ??
                          [];
                      bulkController.text = nameValueModelsToText(rP);
                    }
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: isBulkMode
              ? Padding(
                  padding: kPh20,
                  child: TextField(
                    controller: bulkController,
                    onChanged: (value) {
                      var rows = textToNameValueModels(value);
                      ref.read(collectionStateNotifierProvider.notifier).update(
                            params: rows,
                            isParamEnabledList: List.filled(rows.length, true),
                          );
                    },
                    style: kCodeStyle,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "KEY: VALUE\nKEY: VALUE",
                      hintStyle: kCodeStyle.copyWith(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      border: InputBorder.none,
                    ),
                  ),
                )
              : Container(
                  margin: kPh10t10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              scrollbarTheme: kDataTableScrollbarTheme),
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
                      if (!kIsMobile) kVSpacer40,
                    ],
                  ),
                ),
        ),
        if (!kIsMobile && !isBulkMode)
          Padding(
            padding: kPb15,
            child: ElevatedButton.icon(
              onPressed: () {
                paramRows.add(kNameValueEmptyModel);
                isRowEnabledList.add(false);
                _onFieldChange();
              },
              icon: const Icon(Icons.add),
              label: const Text(
                kLabelAddParam,
                style: kTextStyleButton,
              ),
            ),
          ),
      ],
    );
  }
}
