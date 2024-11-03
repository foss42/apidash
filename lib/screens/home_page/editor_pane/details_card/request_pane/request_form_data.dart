import 'dart:math';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class FormDataWidget extends ConsumerStatefulWidget {
  const FormDataWidget({super.key});
  @override
  ConsumerState<FormDataWidget> createState() => _FormDataBodyState();
}

class _FormDataBodyState extends ConsumerState<FormDataWidget> {
  late int seed;
  final random = Random.secure();
  late List<FormDataModel> formRows;
  bool isAddingRow = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          selectedId,
          formData: formRows.sublist(0, formRows.length - 1),
        );
  }

  @override
  Widget build(BuildContext context) {
    dataTableShowLogs = false;
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.formData?.length));
    var rF = ref.read(selectedRequestModelProvider)?.httpRequestModel?.formData;
    bool isFormDataEmpty = rF == null || rF.isEmpty;
    formRows = isFormDataEmpty
        ? [
            kFormDataEmptyModel,
          ]
        : rF +
            [
              kFormDataEmptyModel,
            ];
    isAddingRow = false;

    List<DataColumn> columns = const [
      DataColumn2(
        label: Text(kNameField),
        size: ColumnSize.M,
      ),
      DataColumn2(
        label: Text('='),
        fixedWidth: 20,
      ),
      DataColumn2(
        label: Text(''),
        fixedWidth: 70,
      ),
      DataColumn2(
        label: Text(kNameValue),
        size: ColumnSize.L,
      ),
      DataColumn2(
        label: Text(''),
        fixedWidth: 32,
      ),
    ];

    List<DataRow> dataRows = List<DataRow>.generate(
      formRows.length,
      (index) {
        bool isLast = index + 1 == formRows.length;
        return DataRow(
          key: ValueKey("$selectedId-$index-form-row-$seed"),
          cells: <DataCell>[
            DataCell(
              CellField(
                keyId: "$selectedId-$index-form-k-$seed",
                initialValue: formRows[index].name,
                hintText: kHintAddFieldName,
                onChanged: (value) {
                  formRows[index] = formRows[index].copyWith(name: value);
                  if (isLast && !isAddingRow) {
                    isAddingRow = true;
                    formRows.add(kFormDataEmptyModel);
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
              DropdownButtonFormData(
                formDataType: formRows[index].type,
                onChanged: (value) {
                  bool hasChanged = formRows[index].type != value;
                  formRows[index] = formRows[index].copyWith(
                    type: value ?? FormDataType.text,
                  );
                  formRows[index] = formRows[index].copyWith(value: "");
                  if (isLast && hasChanged) {
                    formRows.add(kFormDataEmptyModel);
                  }
                  setState(() {});
                  _onFieldChange(selectedId!);
                },
              ),
            ),
            DataCell(
              formRows[index].type == FormDataType.file
                  ? FormDataFileButton(
                      onPressed: () async {
                        var pickedResult = await pickFile();
                        if (pickedResult != null &&
                            pickedResult.path.isNotEmpty) {
                          formRows[index] = formRows[index].copyWith(
                            value: pickedResult.path,
                          );
                          setState(() {});
                          _onFieldChange(selectedId!);
                        }
                      },
                      initialValue: formRows[index].value,
                    )
                  : CellField(
                      keyId: "$selectedId-$index-form-v-$seed",
                      initialValue: formRows[index].value,
                      hintText: kHintAddValue,
                      onChanged: (value) {
                        formRows[index] =
                            formRows[index].copyWith(value: value);
                        if (isLast && !isAddingRow) {
                          isAddingRow = true;
                          formRows.add(kFormDataEmptyModel);
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
                        if (formRows.length == 2) {
                          setState(() {
                            formRows = [
                              kFormDataEmptyModel,
                            ];
                          });
                        } else {
                          formRows.removeAt(index);
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
                formRows.add(kFormDataEmptyModel);
                _onFieldChange(selectedId!);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                kLabelAddFormField,
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
