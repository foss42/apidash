import 'package:apidash/consts.dart';
import 'package:apidash/models/form_data_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/form_data_field.dart';
import 'package:apidash/widgets/textfields.dart';
import 'package:davi/davi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormDataWidget extends ConsumerStatefulWidget {
  const FormDataWidget({
    super.key,
    required this.seed,
    required this.onFormDataRemove,
  });
  final int seed;
  final Function onFormDataRemove;
  @override
  ConsumerState<FormDataWidget> createState() => _FormDataBodyState();
}

class _FormDataBodyState extends ConsumerState<FormDataWidget> {
  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!);
    List<FormDataModel> rows = requestModel?.formDataList ?? [];
    DaviModel<FormDataModel> model = DaviModel<FormDataModel>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'Key',
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return SizedBox(
              child: FormDataField(
                keyId: "$activeId-$idx-form-v-${widget.seed}",
                initialValue: rows[idx].name,
                hintText: " Key",
                onChanged: (value) {
                  rows[idx] = rows[idx].copyWith(
                    name: value,
                  );
                  _onFieldChange(activeId);
                },
                colorScheme: Theme.of(context).colorScheme,
                formDataType: rows[idx].type,
                onFormDataTypeChanged: (value) {
                  rows[idx] = rows[idx].copyWith(
                    type: value ?? FormDataType.text,
                  );
                  rows[idx] = rows[idx].copyWith(value: "");
                  _onFieldChange(activeId);
                },
              ),
            );
          },
          sortable: false,
        ),
        DaviColumn(
          width: 10,
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
          cellBuilder: (_, row) {
            int idx = row.index;
            return rows[idx].type == FormDataType.file
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: kPs8,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButtonTheme(
                              data: const ElevatedButtonThemeData(),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  FilePickerResult? pickedResult =
                                      await FilePicker.platform.pickFiles();
                                  if (pickedResult != null &&
                                      pickedResult.files.isNotEmpty) {
                                    rows[idx] = rows[idx].copyWith(
                                      value: pickedResult.files.first.path,
                                    );
                                    _onFieldChange(activeId);
                                  }
                                },
                                icon: const Icon(
                                  Icons.snippet_folder_rounded,
                                  size: 18,
                                ),
                                label: Text(
                                  rows[idx].type == FormDataType.file
                                      ? (rows[idx].value != null
                                          ? rows[idx].value.toString()
                                          : "Select File")
                                      : "Select File",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStyleButton.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : CellField(
                    keyId: "$activeId-$idx-form-v-${widget.seed}",
                    initialValue: rows[idx].value,
                    hintText: " Value",
                    onChanged: (value) {
                      rows[idx] = rows[idx].copyWith(value: value);
                      _onFieldChange(activeId);
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
                widget.onFormDataRemove();
                if (rows.length == 1) {
                  setState(() {
                    rows = [
                      kFormDataEmptyModel,
                    ];
                  });
                } else {
                  rows.removeAt(row.index);
                }
                _onFieldChange(activeId);
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
                  child: Davi<FormDataModel>(model),
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
                rows.add(kFormDataEmptyModel);
                _onFieldChange(activeId);
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

  void _onFieldChange(String activeId) {
    List<FormDataModel> formDataList =
        ref.read(collectionStateNotifierProvider)?[activeId]?.formDataList ??
            [];
    ref.read(collectionStateNotifierProvider.notifier).update(
          activeId,
          formDataList: formDataList,
        );
  }
}
