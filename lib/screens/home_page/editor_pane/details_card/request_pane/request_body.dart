import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditRequestBody extends ConsumerStatefulWidget {
  const EditRequestBody({super.key});

  @override
  ConsumerState<EditRequestBody> createState() => _EditRequestBodyState();
}

class _EditRequestBodyState extends ConsumerState<EditRequestBody> {
  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final reqestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      margin: kPt5o10,
      child: Column(
        children: [
          SizedBox(
            height: kHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Select Content Type:",
                ),
                DropdownButtonBodyContentType(),
              ],
            ),
          ),
          Expanded(
            child: TextFieldEditor(
              key: Key("$activeId-body"),
              fieldKey: "$activeId-body-editor",
              initialValue: reqestModel.requestBody,
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
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final activeId = ref.watch(activeIdStateProvider);
    final requestBodyContentType = ref.watch(activeRequestModelProvider
        .select((value) => value!.requestBodyContentType));
    return DropdownButton<ContentType>(
      focusColor: surfaceColor,
      value: requestBodyContentType,
      icon: const Icon(
        Icons.unfold_more_rounded,
        size: 16,
      ),
      elevation: 4,
      style: kCodeStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      underline: Container(
        height: 0,
      ),
      onChanged: (ContentType? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId!, requestBodyContentType: value);
      },
      borderRadius: kBorderRadius12,
      items: ContentType.values
          .map<DropdownMenuItem<ContentType>>((ContentType value) {
        return DropdownMenuItem<ContentType>(
          value: value,
          child: Padding(
            padding: kPs8,
            child: Text(
              value.name,
              style: kTextStyleButton,
            ),
          ),
        );
      }).toList(),
    );
  }
}
