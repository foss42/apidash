
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

class EditGraphqlVariables extends ConsumerStatefulWidget {
  const EditGraphqlVariables({super.key});

  @override
  ConsumerState<EditGraphqlVariables> createState() => EditGraphqlVariablesState();
}

class EditGraphqlVariablesState extends ConsumerState<EditGraphqlVariables> {
  late int seed;
  final random = Random.secure();
  late List<NameValueModel> graphqlVariablesRows;
  late List<bool> isRowEnabledList;
  bool isAddingRow = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange() {
    ref.read(collectionStateNotifierProvider.notifier).update(
      graphqlVariables: graphqlVariablesRows.sublist(0, graphqlVariablesRows.length - 1),
      isGraphqlVariablesEnabledList:
      isRowEnabledList.sublist(0, graphqlVariablesRows.length - 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.graphqlVariables?.length));
    var rH = ref.read(selectedRequestModelProvider)?.httpRequestModel?.graphqlVariables;
    bool isHeadersEmpty = rH == null || rH.isEmpty;
    graphqlVariablesRows = isHeadersEmpty
        ? [
      kNameValueEmptyModel,
    ]
        : rH + [kNameValueEmptyModel];
    isRowEnabledList = [
      ...(ref
          .read(selectedRequestModelProvider)
          ?.httpRequestModel
          ?.isGraphqlVariablesEnabledList ??
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
        label: Text(kNameVariables),
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
      graphqlVariablesRows.length,
          (index) {
        bool isLast = index + 1 == graphqlVariablesRows.length;
        return DataRow(
          key: ValueKey("$selectedId-$index-graphqlVariables-row-$seed"),
          cells: <DataCell>[
            DataCell(
              ADCheckBox(
                keyId: "$selectedId-$index-graphqlVariables-c-$seed",
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
              HeaderField(
                keyId: "$selectedId-$index-graphqlVariables-k-$seed",
                initialValue: graphqlVariablesRows[index].name,
                hintText: kHintAddName,
                onChanged: (value) {
                  graphqlVariablesRows[index] = graphqlVariablesRows[index].copyWith(name: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    isRowEnabledList[index] = true;
                    graphqlVariablesRows.add(kNameValueEmptyModel);
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
                keyId: "$selectedId-$index-graphqlVariables-v-$seed",
                initialValue: graphqlVariablesRows[index].value,
                hintText: kHintAddValue,
                onChanged: (value) {
                  graphqlVariablesRows[index] = graphqlVariablesRows[index].copyWith(value: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    isRowEnabledList[index] = true;
                    graphqlVariablesRows.add(kNameValueEmptyModel);
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
                  if (graphqlVariablesRows.length == 2) {
                    setState(() {
                      graphqlVariablesRows = [
                        kNameValueEmptyModel,
                      ];
                      isRowEnabledList = [false];
                    });
                  } else {
                    graphqlVariablesRows.removeAt(index);
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
                graphqlVariablesRows.add(kNameValueEmptyModel);
                isRowEnabledList.add(false);
                _onFieldChange();
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
