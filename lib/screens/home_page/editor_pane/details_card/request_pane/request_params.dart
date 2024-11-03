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

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          selectedId,
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
              CheckBox(
                keyId: "$selectedId-$index-params-c-$seed",
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                paramRows.add(kNameValueEmptyModel);
                isRowEnabledList.add(false);
                _onFieldChange(selectedId!);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                kLabelAddParam,
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
