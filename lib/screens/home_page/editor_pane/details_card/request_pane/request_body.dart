import 'dart:math';

import 'package:apidash/consts.dart';
import 'package:apidash/models/name_value_model.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditRequestBody extends ConsumerStatefulWidget {
  const EditRequestBody({super.key});

  @override
  ConsumerState<EditRequestBody> createState() => _EditRequestBodyState();
}

class _EditRequestBodyState extends ConsumerState<EditRequestBody> {
  late List<NameValueModel> rows;
  final random = Random.secure();
  late int seed;
  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
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
    DaviModel<NameValueModel> model = DaviModel<NameValueModel>(
      rows: rows,
      columns: [
        DaviColumn(
          name: 'Header Name',
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return HeaderField(
              keyId: "$activeId-$idx-headers-k-$seed",
              initialValue: rows[idx].name,
              hintText: "Add Header Name",
              onChanged: (value) {
                rows[idx] = rows[idx].copyWith(name: value);
                // _onFieldChange(activeId);
              },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
          sortable: false,
        ),
        DaviColumn(
          width: 30,
          cellBuilder: (_, row) {
            return Text(
              "=",
              style: kCodeStyle,
            );
          },
        ),
        DaviColumn(
          name: 'Header Value',
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return CellField(
              keyId: "$activeId-$idx-headers-v-$seed",
              initialValue: rows[idx].value,
              hintText: " Add Header Value",
              onChanged: (value) {
                rows[idx] = rows[idx].copyWith(value: value);
                // _onFieldChange(activeId);
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
                      kNameValueEmptyModel,
                    ];
                  });
                } else {
                  rows.removeAt(row.index);
                }
                // _onFieldChange(activeId);
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
                ? Container(
                    child: const Text("Vidya"),
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
