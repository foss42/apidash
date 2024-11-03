import 'dart:math';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';

class EditEnvironmentSecrets extends ConsumerStatefulWidget {
  const EditEnvironmentSecrets({super.key});

  @override
  ConsumerState<EditEnvironmentSecrets> createState() =>
      EditEnvironmentSecretsState();
}

class EditEnvironmentSecretsState
    extends ConsumerState<EditEnvironmentSecrets> {
  late int seed;
  final random = Random.secure();
  late List<EnvironmentVariableModel> secretRows;
  bool isAddingRow = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    final environment = ref.read(selectedEnvironmentModelProvider);
    final variables = getEnvironmentVariables(environment);
    ref.read(environmentsStateNotifierProvider.notifier).updateEnvironment(
      selectedId,
      values: [...variables, ...secretRows.sublist(0, secretRows.length - 1)],
    );
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedEnvironmentIdStateProvider);
    ref.watch(selectedEnvironmentModelProvider
        .select((environment) => getEnvironmentSecrets(environment).length));
    var rows =
        getEnvironmentSecrets(ref.read(selectedEnvironmentModelProvider));
    secretRows = rows.isEmpty
        ? [
            kEnvironmentSecretEmptyModel,
          ]
        : rows + [kEnvironmentSecretEmptyModel];
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text(kNameCheckbox),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text("Variable name"),
      ),
      DataColumn2(
        label: Text('='),
        fixedWidth: 30,
      ),
      DataColumn2(
        label: Text("Secret value"),
      ),
      DataColumn2(
        label: Text(''),
        fixedWidth: 32,
      ),
    ];

    List<DataRow> dataRows = List<DataRow>.generate(
      secretRows.length,
      (index) {
        bool isLast = index + 1 == secretRows.length;
        return DataRow(
          key: ValueKey("$selectedId-$index-secrets-row-$seed"),
          cells: <DataCell>[
            DataCell(
              CheckBox(
                keyId: "$selectedId-$index-secrets-c-$seed",
                value: secretRows[index].enabled,
                onChanged: isLast
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            secretRows[index] =
                                secretRows[index].copyWith(enabled: value);
                          });
                        }
                        _onFieldChange(selectedId!);
                      },
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
            DataCell(
              CellField(
                keyId: "$selectedId-$index-secrets-k-$seed",
                initialValue: secretRows[index].key,
                hintText: "Add Variable",
                onChanged: (value) {
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    secretRows[index] =
                        secretRows[index].copyWith(key: value, enabled: true);
                    secretRows.add(kEnvironmentSecretEmptyModel);
                  } else {
                    secretRows[index] = secretRows[index].copyWith(key: value);
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
              ObscurableCellField(
                keyId: "$selectedId-$index-secrets-v-$seed",
                initialValue: secretRows[index].value,
                hintText: "Add Secret Value",
                onChanged: (value) {
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    secretRows[index] =
                        secretRows[index].copyWith(value: value, enabled: true);
                    secretRows.add(kEnvironmentSecretEmptyModel);
                  } else {
                    secretRows[index] =
                        secretRows[index].copyWith(value: value);
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
                        if (secretRows.length == 2) {
                          setState(() {
                            secretRows = [
                              kEnvironmentSecretEmptyModel,
                            ];
                          });
                        } else {
                          secretRows.removeAt(index);
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
            color: Theme.of(context).colorScheme.surface,
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
                secretRows.add(kEnvironmentSecretEmptyModel);
                _onFieldChange(selectedId!);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Secret",
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
