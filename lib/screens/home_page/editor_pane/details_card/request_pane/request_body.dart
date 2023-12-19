import 'dart:math';

import 'package:apidash/consts.dart';
import 'package:apidash/models/form_data_model.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/extensions/file_extension.dart';
import 'package:apidash/widgets/form_data_field.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:davi/davi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditRequestBody extends ConsumerStatefulWidget {
  const EditRequestBody({super.key});

  @override
  ConsumerState<EditRequestBody> createState() => _EditRequestBodyState();
}

class _EditRequestBodyState extends ConsumerState<EditRequestBody> {
  List<FormDataModel> rows = [];
  final random = Random.secure();
  late int seed;
  late FilePicker filePicker;
  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
    filePicker = FilePicker.platform;
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!);
    ContentType? requestBodyStateWatcher = (ref
            .watch(collectionStateNotifierProvider)![activeId]
            ?.requestBodyContentType) ??
        ContentType.values.first;
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
                keyId: "$activeId-$idx-form-v-$seed",
                initialValue: rows[idx].value,
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
                      padding: kPs2,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                FilePickerResult? pickedResult =
                                    await filePicker.pickFiles();
                                if (pickedResult != null &&
                                    pickedResult.files.isNotEmpty) {
                                  rows[idx] = rows[idx].copyWith(
                                    value: pickedResult.files.first.path,
                                  );
                                  _onFieldChange(activeId);
                                }
                              },
                              child: Text(
                                "Select File",
                                style: kTextStyleButton.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: kPs2,
                              child: Text(
                                rows[idx].type == FormDataType.file
                                    ? (rows[idx].value != null
                                        ? rows[idx].value.toString().fileName
                                        : "")
                                    : "",
                                style: kTextStyleButton,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : CellField(
                    keyId: "$activeId-$idx-form-v-$seed",
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
                seed = random.nextInt(kRandMax);
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      margin: kPt5o10,
      child: Column(
        children: [
          const SizedBox(
            height: kHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select Content Type:",
                ),
                DropdownButtonBodyContentType(),
              ],
            ),
          ),
          Expanded(
            child: requestBodyStateWatcher == ContentType.formdata
                ? Stack(
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
                  )
                : TextFieldEditor(
                    key: Key("$activeId-body"),
                    fieldKey: "$activeId-body-editor",
                    initialValue: requestModel?.requestBody,
                    onChanged: (String value) {
                      ref
                          .read(collectionStateNotifierProvider.notifier)
                          .update(activeId, requestBody: value);
                    },
                  ),
          )
        ],
      ),
    );
  }

  void _onFieldChange(String activeId) {
    ref.read(collectionStateNotifierProvider.notifier).update(
          activeId,
          formDataList: rows,
        );
  }
}

class DropdownButtonBodyContentType extends ConsumerStatefulWidget {
  const DropdownButtonBodyContentType({
    super.key,
  });

  @override
  ConsumerState<DropdownButtonBodyContentType> createState() =>
      _DropdownButtonBodyContentTypeState();
}

class _DropdownButtonBodyContentTypeState
    extends ConsumerState<DropdownButtonBodyContentType> {
  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final requestBodyContentType = ref.watch(activeRequestModelProvider
        .select((value) => value?.requestBodyContentType));
    return DropdownButtonContentType(
      contentType: requestBodyContentType,
      onChanged: (ContentType? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId!, requestBodyContentType: value);
      },
    );
  }
}
