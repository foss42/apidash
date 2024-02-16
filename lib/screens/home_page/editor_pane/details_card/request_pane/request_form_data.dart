import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:davi/davi.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
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
  late List<FormDataModel> rows;
  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    var formRows = ref.read(selectedRequestModelProvider)?.requestFormDataList;
    rows =
        formRows == null || formRows.isEmpty ? [kFormDataEmptyModel] : formRows;

    DaviModel<FormDataModel> daviModelRows = DaviModel<FormDataModel>(
      rows: rows,
      columns: [
        DaviColumn(
          cellPadding: kpsV5,
          name: 'Key',
          grow: 4,
          cellBuilder: (_, row) {
            int idx = row.index;
            return Theme(
              data: Theme.of(context),
              child: FormDataField(
                keyId: "$selectedId-$idx-form-v-$seed",
                initialValue: rows[idx].name,
                hintText: " Add Key",
                onChanged: (value) {
                  rows[idx] = rows[idx].copyWith(
                    name: value,
                  );
                  _onFieldChange(selectedId!);
                },
                colorScheme: Theme.of(context).colorScheme,
                formDataType: rows[idx].type,
                onFormDataTypeChanged: (value) {
                  rows[idx] = rows[idx].copyWith(
                    type: value ?? FormDataType.text,
                  );
                  rows[idx] = rows[idx].copyWith(value: "");
                  setState(() {});
                  _onFieldChange(selectedId!);
                },
              ),
            );
          },
          sortable: false,
        ),
        DaviColumn(
          width: 40,
          cellPadding: kpsV5,
          cellAlignment: Alignment.center,
          cellBuilder: (_, row) {
            return Text(
              "=",
              style: kCodeStyle,
            );
          },
        ),
        DaviColumn(
          name: 'Value',
          grow: 4,
          cellPadding: kpsV5,
          cellBuilder: (_, row) {
            int idx = row.index;
            return rows[idx].type == FormDataType.file
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Theme(
                            data: Theme.of(context),
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.snippet_folder_rounded,
                                size: 20,
                              ),
                              style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                var pickedResult = await pickFile();
                                if (pickedResult != null &&
                                    pickedResult.files.isNotEmpty &&
                                    pickedResult.files.first.path != null) {
                                  rows[idx] = rows[idx].copyWith(
                                    value: pickedResult.files.first.path!,
                                  );
                                  setState(() {});
                                  _onFieldChange(selectedId!);
                                }
                              },
                              label: Text(
                                (rows[idx].type == FormDataType.file &&
                                        rows[idx].value.isNotEmpty)
                                    ? rows[idx].value.toString()
                                    : "Select File",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: kFormDataButtonLabelTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : CellField(
                    keyId: "$selectedId-$idx-form-v-$seed",
                    initialValue: rows[idx].value,
                    hintText: " Add Value",
                    onChanged: (value) {
                      rows[idx] = rows[idx].copyWith(value: value);
                      _onFieldChange(selectedId!);
                    },
                    colorScheme: Theme.of(context).colorScheme,
                  );
          },
          sortable: false,
        ),
        DaviColumn(
          pinStatus: PinStatus.none,
          width: 30,
          cellBuilder: (_, row) {
            return InkWell(
              child: Theme.of(context).brightness == Brightness.dark
                  ? kIconRemoveDark
                  : kIconRemoveLight,
              onTap: () {
                seed = random.nextInt(kRandMax);
                if (rows.length == 1) {
                  setState(() {
                    rows = [kFormDataEmptyModel];
                  });
                } else {
                  rows.removeAt(row.index);
                }
                _onFieldChange(selectedId!);
                setState(() {});
              },
            );
          },
        ),
      ],
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
            children: [
              Expanded(
                child: DaviTheme(
                  data: kTableThemeData,
                  child: Davi<FormDataModel>(daviModelRows),
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
                setState(() {
                  rows.add(kFormDataEmptyModel);
                });
                _onFieldChange(selectedId!);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Form Data",
                style: kTextStyleButton,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onFieldChange(String selectedId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          selectedId,
          requestFormDataList: rows,
        );
  }
}
