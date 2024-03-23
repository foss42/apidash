import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'package:data_table_2/data_table_2.dart';

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
          requestParams: paramRows.sublist(0, paramRows.length - 1),
          isParamEnabledList: isRowEnabledList.sublist(0, paramRows.length - 1),
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestParams?.length));
    var rP = ref.read(selectedRequestModelProvider)?.requestParams;
    bool isParamsEmpty = rP == null || rP.isEmpty;
    paramRows = isParamsEmpty
        ? [
            kNameValueEmptyModel,
          ]
        : rP + [kNameValueEmptyModel];
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isParamEnabledList ??
            List.filled(rP?.length ?? 0, true, growable: true);
    isRowEnabledList.add(false);
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text('Checkbox'),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text('URL Parameter'),
      ),
      DataColumn2(
        label: Text('='),
        fixedWidth: 22,
      ),
      DataColumn2(
        label: Text('Parameter Value'),
      ),
      DataColumn2(
        label: Text('Remove'),
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
              CellField(
                keyId: "$selectedId-$index-params-k-$seed",
                initialValue: paramRows[index].name,
                hintText: "Add URL Parameter",
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
              Text(
                "=",
                style: kCodeStyle,
              ),
            ),
            DataCell(
              CellField(
                keyId: "$selectedId-$index-params-v-$seed",
                initialValue: paramRows[index].value,
                hintText: "Add Value",
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
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: kBorderRadius12,
          ),
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
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton.icon(
              onPressed: () {
                paramRows.add(kNameValueEmptyModel);
                isRowEnabledList.add(false);
                _onFieldChange(selectedId!);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Param",
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
