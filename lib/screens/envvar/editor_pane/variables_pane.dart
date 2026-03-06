import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';

class EditEnvironmentVariables extends ConsumerStatefulWidget {
  const EditEnvironmentVariables({super.key});

  @override
  ConsumerState<EditEnvironmentVariables> createState() =>
      EditEnvironmentVariablesState();
}

class EditEnvironmentVariablesState
    extends ConsumerState<EditEnvironmentVariables> {
  late int seed;
  final random = Random.secure();
  late List<EnvironmentVariableModel> variableRows;
  bool isAddingRow = false;
  bool isBulkMode = false;
  final TextEditingController bulkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    final environment = ref.read(selectedEnvironmentModelProvider);
    final secrets = getEnvironmentSecrets(environment);
    ref
        .read(environmentsStateNotifierProvider.notifier)
        .updateEnvironment(
          selectedId,
          values: [
            ...variableRows.sublist(0, variableRows.length - 1),
            ...secrets,
          ],
        );
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedEnvironmentIdStateProvider);
    ref.watch(
      selectedEnvironmentModelProvider.select(
        (environment) => getEnvironmentVariables(environment).length,
      ),
    );
    var rows = getEnvironmentVariables(
      ref.read(selectedEnvironmentModelProvider),
    );
    variableRows = rows.isEmpty
        ? [kEnvironmentVariableEmptyModel]
        : rows + [kEnvironmentVariableEmptyModel];
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(label: Text(kNameCheckbox), fixedWidth: 30),
      DataColumn2(label: Text(kLabelVariableName)),
      DataColumn2(label: Text('='), fixedWidth: 30),
      DataColumn2(label: Text(kLabelVariableValue)),
      DataColumn2(label: Text(''), fixedWidth: 32),
    ];

    List<DataRow> dataRows = List<DataRow>.generate(variableRows.length, (
      index,
    ) {
      bool isLast = index + 1 == variableRows.length;
      return DataRow(
        key: ValueKey("$selectedId-$index-variables-row-$seed"),
        cells: <DataCell>[
          DataCell(
            ADCheckBox(
              keyId: "$selectedId-$index-variables-c-$seed",
              value: variableRows[index].enabled,
              onChanged: isLast
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          variableRows[index] = variableRows[index].copyWith(
                            enabled: value,
                          );
                        });
                      }
                      _onFieldChange(selectedId!);
                    },
              colorScheme: Theme.of(context).colorScheme,
            ),
          ),
          DataCell(
            CellField(
              keyId: "$selectedId-$index-variables-k-$seed",
              initialValue: variableRows[index].key,
              hintText: kHintAddVariable,
              onChanged: (value) {
                if (isLast && !isAddingRow) {
                  isAddingRow = true;
                  variableRows[index] = variableRows[index].copyWith(
                    key: value,
                    enabled: true,
                  );
                  variableRows.add(kEnvironmentVariableEmptyModel);
                } else {
                  variableRows[index] = variableRows[index].copyWith(
                    key: value,
                  );
                }
                _onFieldChange(selectedId!);
              },
              colorScheme: Theme.of(context).colorScheme,
            ),
          ),
          DataCell(Center(child: Text("=", style: kCodeStyle))),
          DataCell(
            CellField(
              keyId: "$selectedId-$index-variables-v-$seed",
              initialValue: variableRows[index].value,
              hintText: kHintAddValue,
              onChanged: (value) {
                if (isLast && !isAddingRow) {
                  isAddingRow = true;
                  variableRows[index] = variableRows[index].copyWith(
                    value: value,
                    enabled: true,
                  );
                  variableRows.add(kEnvironmentVariableEmptyModel);
                } else {
                  variableRows[index] = variableRows[index].copyWith(
                    value: value,
                  );
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
                      if (variableRows.length == 2) {
                        setState(() {
                          variableRows = [kEnvironmentVariableEmptyModel];
                        });
                      } else {
                        variableRows.removeAt(index);
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
    });

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
                      var rV = getEnvironmentVariables(
                          ref.read(selectedEnvironmentModelProvider));
                      bulkController.text = envVarsToText(rV);
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
                      var rows = textToEnvVars(value);
                      final environment = ref.read(selectedEnvironmentModelProvider);
                      final secrets = getEnvironmentSecrets(environment);
                      ref
                          .read(environmentsStateNotifierProvider.notifier)
                          .updateEnvironment(
                            selectedId!,
                            values: [...rows, ...secrets],
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
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: kBorderRadius12,
                  ),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: kPb15,
              child: ElevatedButton.icon(
                onPressed: () {
                  variableRows.add(kEnvironmentVariableEmptyModel);
                  _onFieldChange(selectedId!);
                },
                icon: const Icon(Icons.add),
                label: const Text(kLabelAddVariable, style: kTextStyleButton),
              ),
            ),
          ),
      ],
    );
  }
}
