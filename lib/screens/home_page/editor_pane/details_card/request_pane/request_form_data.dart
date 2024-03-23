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
  late List<FormDataModel> formRows;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _onFieldChange(String selectedId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          selectedId,
          requestFormDataList: formRows.sublist(0, formRows.length - 1),
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestFormDataList?.length));
    var rF = ref.read(selectedRequestModelProvider)?.requestFormDataList;
    bool isFormDataEmpty = rF == null || rF.isEmpty;
    List<FormDataModel> rows = (isFormDataEmpty)
        ? [
            kFormDataEmptyModel,
          ]
        : rF;
    formRows = isFormDataEmpty ? rows : rows + [kFormDataEmptyModel];

    DaviModel<FormDataModel> daviModelRows = DaviModel<FormDataModel>(
      rows: formRows,
      columns: [
        DaviColumn(
          cellPadding: kpsV5,
          name: 'Key',
          grow: 4,
          cellBuilder: (_, row) {
            int idx = row.index;
            bool isLast = idx + 1 == formRows.length;
            return Theme(
              data: Theme.of(context),
              child: FormDataField(
                keyId: "$selectedId-$idx-form-v-$seed",
                initialValue: formRows[idx].name,
                hintText: " Add Key",
                onChanged: (value) {
                  formRows[idx] = formRows[idx].copyWith(name: value);
                  if (isLast) formRows.add(kFormDataEmptyModel);
                  _onFieldChange(selectedId!);
                },
                colorScheme: Theme.of(context).colorScheme,
                formDataType: formRows[idx].type,
                onFormDataTypeChanged: (value) {
                  bool hasChanged = formRows[idx].type != value;
                  formRows[idx] = formRows[idx].copyWith(
                    type: value ?? FormDataType.text,
                  );
                  formRows[idx] = formRows[idx].copyWith(value: "");
                  if (idx == formRows.length - 1 && hasChanged) {
                    formRows.add(kFormDataEmptyModel);
                  }
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
            bool isLast = idx + 1 == formRows.length;
            return formRows[idx].type == FormDataType.file
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
                                  formRows[idx] = formRows[idx].copyWith(
                                    value: pickedResult.files.first.path!,
                                  );
                                  setState(() {});
                                  _onFieldChange(selectedId!);
                                }
                              },
                              label: Text(
                                (formRows[idx].type == FormDataType.file &&
                                        formRows[idx].value.isNotEmpty)
                                    ? formRows[idx].value.toString()
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
                    initialValue: formRows[idx].value,
                    hintText: " Add Value",
                    onChanged: (value) {
                      formRows[idx] = formRows[idx].copyWith(value: value);
                      if (isLast) formRows.add(kFormDataEmptyModel);
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
            bool isLast = row.index + 1 == formRows.length;
            return InkWell(
              onTap: isLast
                  ? null
                  : () {
                      seed = random.nextInt(kRandMax);
                      if (formRows.length == 2) {
                        setState(() {
                          formRows = [kFormDataEmptyModel];
                        });
                      } else {
                        formRows.removeAt(row.index);
                      }
                      _onFieldChange(selectedId!);
                    },
              child: Theme.of(context).brightness == Brightness.dark
                  ? kIconRemoveDark
                  : kIconRemoveLight,
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
              kVSpacer20,
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ElevatedButton.icon(
              onPressed: () {
                formRows.add(kFormDataEmptyModel);
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
}
