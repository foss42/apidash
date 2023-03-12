import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/editor.dart';
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
        borderRadius: kBorder12,
      ),
      margin: kP5,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
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
              fieldKey: "$activeId-body",
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
    final collection = ref.read(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final requestBodyContentType = ref.watch(collectionStateNotifierProvider
        .select((value) => value[idIdx].requestBodyContentType));
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
      borderRadius: kBorder12,
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
