import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../request_form_data.dart';

class EditMessageBody extends ConsumerWidget {
  const EditMessageBody({super.key});

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
      margin: kPt5o10,
      child: Column(
        children: [
          SizedBox(
            height: kTopicHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select Content Type:",
                ),
                const DropdownButtonBodyContentType(),
                kHSpacer20,
                Expanded(
                  child: Padding(
                    padding: kMaterialListPadding,
                    child: TopicField(
                      value:
                          ref.watch(messageTopicStateProvider.notifier).state ??
                              "",
                      hintText: "Topic",
                      onChanged: (String value) {
                        ref.read(messageTopicStateProvider.notifier).state =
                            value;
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: switch (contentType) {
              ContentType.formdata => const FormDataWidget(),
              // TODO: Fix JsonTextFieldEditor & plug it here
              ContentType.json => TextFieldEditor(
                  key: Key("$selectedId-json-body"),
                  fieldKey: "$selectedId-json-body-editor",
                  initialValue: requestModel?.requestBody,
                  onChanged: (String value) {
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .update(selectedId, requestBody: value);
                  },
                ),
              _ => TextFieldEditor(
                  key: Key("$selectedId-body"),
                  fieldKey: "$selectedId-body-editor",
                  initialValue: requestModel?.requestBody,
                  onChanged: (String value) {
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .update(selectedId, requestBody: value);
                  },
                ),
            },
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: SendButton(),
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.surfaceVariant,
            height: 1,
            thickness: 1,
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

class SendButton extends ConsumerWidget {
  const SendButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    return SendMessageButton(
      selectedId: selectedId,
      sentRequestId: sentRequestId,
      onTap: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .sendMessage(selectedId!);
      },
    );
  }
}

class TopicField extends StatelessWidget {
  const TopicField({
    super.key,
    required this.value,
    this.hintText,
    this.onChanged,
    this.colorScheme,
  });

  final String? hintText;
  final String value;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;

  @override
  Widget build(BuildContext context) {
    var clrScheme = colorScheme ?? Theme.of(context).colorScheme;
    return TextFormField(
      initialValue: value,
      style: kCodeStyle.copyWith(
        color: clrScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintStyle: kCodeStyle.copyWith(
          color: clrScheme.outline.withOpacity(
            kHintOpacity,
          ),
        ),
        hintText: hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: clrScheme.primary.withOpacity(
              kHintOpacity,
            ),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: clrScheme.surfaceVariant,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
