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
  final random = Random.secure();
  late List<NameValueModel> rows;
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
          requestParams: rows,
          isParamEnabledList: isRowEnabledList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestParams?.length));
    var rP = ref.read(selectedRequestModelProvider)?.requestParams;
    rows = (rP == null || rP.isEmpty)
        ? [
            kNameValueEmptyModel,
          ]
        : rP;
    isRowEnabledList =
        ref.read(selectedRequestModelProvider)?.isParamEnabledList ??
            List.filled(rows.length, true, growable: true);

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
                    dataRowHeight: kDataRowHeight,
                    bottomMargin: kDataTableBottomPadding,
                    isVerticalScrollBarVisible: true,
                    columns: columns,
                    rows: List<DataRow>.generate(
                      rows.length,
                      (index) {
                        return DataRow(
                          key: ValueKey("$selectedId-$index-params-row-$seed"),
                          cells: <DataCell>[
                            DataCell(
                              CheckBox(
                                keyId: "$selectedId-$index-params-c-$seed",
                                value: isRowEnabledList[index],
                                onChanged: (value) {
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
                                initialValue: rows[index].name,
                                hintText: "Add URL Parameter",
                                onChanged: (value) {
                                  rows[index] =
                                      rows[index].copyWith(name: value);
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
                                initialValue: rows[index].value,
                                hintText: "Add Value",
                                onChanged: (value) {
                                  rows[index] =
                                      rows[index].copyWith(value: value);
                                  _onFieldChange(selectedId!);
                                },
                                colorScheme: Theme.of(context).colorScheme,
                              ),
                            ),
                            DataCell(
                              InkWell(
                                child: Theme.of(context).brightness ==
                                        Brightness.dark
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
                                    rows.removeAt(index);
                                    isRowEnabledList.removeAt(index);
                                  }
                                  _onFieldChange(selectedId!);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
                rows.add(kNameValueEmptyModel);
                isRowEnabledList.add(true);
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
