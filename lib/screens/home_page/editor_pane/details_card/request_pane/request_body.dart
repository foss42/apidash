import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'request_form_data.dart';

class EditRequestBody extends ConsumerStatefulWidget {
  const EditRequestBody({super.key});

  @override
  ConsumerState<EditRequestBody> createState() => _EditRequestBodyState();
}

class _EditRequestBodyState extends ConsumerState<EditRequestBody> {
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
                ? const FormDataWidget()
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
