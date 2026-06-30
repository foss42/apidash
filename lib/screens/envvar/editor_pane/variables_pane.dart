import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
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

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    ref
        .read(environmentsStateNotifierProvider.notifier)
        .updateEnvironment(
          selectedId,
          values: [
            ...variableRows.sublist(0, variableRows.length - 1),
          ],
        );
  }

  void _toggleSecret(String selectedId, int index) {
    final current = variableRows[index];
    final notifier = ref.read(environmentsStateNotifierProvider.notifier);
    if (current.type == EnvironmentVariableType.variable) {
      if (current.key.isNotEmpty && current.value.isNotEmpty) {
        notifier.persistSecretValue(selectedId, current.key, current.value);
      }
      setState(() {
        variableRows[index] = current.copyWith(
          type: EnvironmentVariableType.secret,
        );
      });
    } else {
      if (current.key.isNotEmpty) {
        notifier.removeSecretValue(selectedId, current.key);
      }
      setState(() {
        variableRows[index] = current.copyWith(
          type: EnvironmentVariableType.variable,
        );
      });
    }
    _onFieldChange(selectedId);
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedEnvironmentIdStateProvider);
    ref.watch(
      selectedEnvironmentModelProvider.select((environment) => environment?.values.length),
    );
    final env = ref.read(selectedEnvironmentModelProvider);
    final rows = env?.values ?? <EnvironmentVariableModel>[];
    variableRows = rows.isEmpty ? [kEnvironmentVariableEmptyModel] : [...rows, kEnvironmentVariableEmptyModel];
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(label: Text(kNameCheckbox), fixedWidth: 30),
      DataColumn2(label: Text(kLabelVariableName), size: ColumnSize.M),
      DataColumn2(label: Text('='), fixedWidth: 30),
      DataColumn2(label: Text(kLabelVariableValue), size: ColumnSize.M),
      DataColumn2(label: Text('Secret'), size: ColumnSize.S),
      DataColumn2(label: Text(''), fixedWidth: 40),
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
            variableRows[index].type == EnvironmentVariableType.secret
                ? ObscurableCellField(
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
                  )
                : CellField(
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
            isLast
                ? const SizedBox.shrink()
                : Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: ADCheckBox(
                        keyId: "$selectedId-$index-variables-secret-c-$seed",
                        value: variableRows[index].type == EnvironmentVariableType.secret,
                        onChanged: (value) {
                          if (value != null) {
                            _toggleSecret(selectedId!, index);
                          }
                        },
                        colorScheme: Theme.of(context).colorScheme,
                      ),
                    ),
                  ),
          ),
          DataCell(
            Align(
              alignment: Alignment.centerRight,
              child: isLast
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () {
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
          ),
        ],
      );
    });

    return Stack(
      children: [
        Container(
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
                  data: Theme.of(
                    context,
                  ).copyWith(scrollbarTheme: kDataTableScrollbarTheme),
                  child: DataTable2(
                    columnSpacing: 12,
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    headingRowHeight: 0,
                    dataRowHeight: kDataTableRowHeight,
                    bottomMargin: kDataTableBottomPadding,
                    isVerticalScrollBarVisible: true,
                    smRatio: 0.25,
                    columns: columns,
                    rows: dataRows,
                  ),
                ),
              ),
              if (!kIsMobile) kVSpacer40,
            ],
          ),
        ),
        if (!kIsMobile)
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
