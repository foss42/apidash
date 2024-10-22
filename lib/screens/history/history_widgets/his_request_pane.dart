import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class HistoryRequestPane extends ConsumerWidget {
  const HistoryRequestPane({
    super.key,
    this.isCompact = false,
  });

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedHistoryIdStateProvider);
    final codePaneVisible = ref.watch(historyCodePaneVisibleStateProvider);

    final headersMap = ref.watch(selectedHistoryRequestModelProvider
            .select((value) => value?.httpRequestModel.headersMap)) ??
        {};
    final headerLength = headersMap.length;

    final paramsMap = ref.watch(selectedHistoryRequestModelProvider
            .select((value) => value?.httpRequestModel.paramsMap)) ??
        {};
    final paramLength = paramsMap.length;

    final hasBody = ref.watch(selectedHistoryRequestModelProvider
            .select((value) => value?.httpRequestModel.hasBody)) ??
        false;

    return RequestPane(
      selectedId: selectedId,
      codePaneVisible: codePaneVisible,
      onPressedCodeButton: () {
        ref.read(historyCodePaneVisibleStateProvider.notifier).state =
            !codePaneVisible;
      },
      showViewCodeButton: !isCompact,
      showIndicators: [
        paramLength > 0,
        headerLength > 0,
        hasBody,
      ],
      children: [
        RequestDataTable(
          rows: paramsMap,
          keyName: kNameURLParam,
        ),
        RequestDataTable(
          rows: headersMap,
          keyName: kNameHeader,
        ),
        const HisRequestBody(),
      ],
    );
  }
}

class HisRequestBody extends ConsumerWidget {
  const HisRequestBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel = ref.watch(selectedHistoryRequestModelProvider);
    final requestModel = selectedHistoryModel?.httpRequestModel;
    final contentType = requestModel?.bodyContentType;

    return Column(
      children: [
        kVSpacer5,
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.labelLarge,
            children: [
              const TextSpan(
                text: "Content Type: ",
              ),
              TextSpan(
                  text: contentType?.name ?? "text",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      )),
            ],
          ),
        ),
        kVSpacer5,
        Expanded(
          child: switch (contentType) {
            ContentType.formdata => Padding(
                padding: kPh4,
                child:
                    RequestFormDataTable(rows: requestModel?.formData ?? [])),
            // TODO: Fix JsonTextFieldEditor & plug it here
            ContentType.json => Padding(
                padding: kPt5o10,
                child: TextFieldEditor(
                  key: Key("${selectedHistoryModel?.historyId}-json-body"),
                  fieldKey:
                      "${selectedHistoryModel?.historyId}-json-body-viewer",
                  initialValue: requestModel?.body,
                  readOnly: true,
                ),
              ),
            _ => Padding(
                padding: kPt5o10,
                child: TextFieldEditor(
                  key: Key("${selectedHistoryModel?.historyId}-body"),
                  fieldKey: "${selectedHistoryModel?.historyId}-body-viewer",
                  initialValue: requestModel?.body,
                  readOnly: true,
                ),
              ),
          },
        )
      ],
    );
  }
}
