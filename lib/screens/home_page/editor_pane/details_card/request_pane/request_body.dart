import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'request_form_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditRequestBody extends ConsumerWidget {
  const EditRequestBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
            height: kHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n!.kLabelSelectContentType,
                ),
                const DropdownButtonBodyContentType(),
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
