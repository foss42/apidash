import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'request_form_data.dart';

class EditRequestBody extends ConsumerWidget {
  const EditRequestBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!);
    final contentType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestBodyContentType));

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
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
            child: switch (contentType) {
              ContentType.formdata =>
                const Padding(padding: kPh4, child: FormDataWidget()),
              // TODO: Fix JsonTextFieldEditor & plug it here
              ContentType.json => Padding(
                  padding: kPt5o10,
                  child: TextFieldEditor(
                    key: Key("$selectedId-json-body"),
                    fieldKey: "$selectedId-json-body-editor",
                    initialValue: requestModel?.requestBody,
                    onChanged: (String value) {
                      ref
                          .read(collectionStateNotifierProvider.notifier)
                          .update(selectedId, requestBody: value);
                    },
                  ),
                ),
              _ => Padding(
                  padding: kPt5o10,
                  child: TextFieldEditor(
                    key: Key("$selectedId-body"),
                    fieldKey: "$selectedId-body-editor",
                    initialValue: requestModel?.requestBody,
                    onChanged: (String value) {
                      ref
                          .read(collectionStateNotifierProvider.notifier)
                          .update(selectedId, requestBody: value);
                    },
                  ),
                ),
            },
          )
        ],
      ),
    );
  }
}

class DropdownButtonBodyContentType extends ConsumerWidget {
  const DropdownButtonBodyContentType({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestBodyContentType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestBodyContentType));
    return DropdownButtonContentType(
      contentType: requestBodyContentType,
      onChanged: (ContentType? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(selectedId!, requestBodyContentType: value);
      },
    );
  }
}
