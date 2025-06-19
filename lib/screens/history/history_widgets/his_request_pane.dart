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
    final apiType = ref.watch(selectedHistoryRequestModelProvider
        .select((value) => value?.metaData.apiType));
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

    final hasQuery = ref.watch(selectedHistoryRequestModelProvider
            .select((value) => value?.httpRequestModel.hasQuery)) ??
        false;

    return switch (apiType) {
      APIType.rest => RequestPane(
          key: const Key("history-request-pane-rest"),
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
          tabLabels: const [
            kLabelURLParams,
            kLabelHeaders,
            kLabelBody,
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
        ),
      APIType.graphql => RequestPane(
          key: const Key("history-request-pane-graphql"),
          selectedId: selectedId,
          codePaneVisible: codePaneVisible,
          onPressedCodeButton: () {
            ref.read(historyCodePaneVisibleStateProvider.notifier).state =
                !codePaneVisible;
          },
          showViewCodeButton: !isCompact,
          showIndicators: [
            headerLength > 0,
            hasQuery,
          ],
          tabLabels: const [
            kLabelHeaders,
            kLabelQuery,
          ],
          children: [
            RequestDataTable(
              rows: headersMap,
              keyName: kNameHeader,
            ),
            const HisRequestBody(),
          ],
        ),
      _ => kSizedBoxEmpty,
    };
  }
}

class HisRequestBody extends ConsumerWidget {
  const HisRequestBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel = ref.watch(selectedHistoryRequestModelProvider);
    final apiType = selectedHistoryModel?.metaData.apiType;
    final requestModel = selectedHistoryModel?.httpRequestModel;
    final contentType = requestModel?.bodyContentType;

    return switch (apiType) {
      APIType.rest => Column(
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
                    child: RequestFormDataTable(
                        rows: requestModel?.formData ?? []),
                  ),
                ContentType.json => Padding(
                    padding: kPt5o10,
                    child: JsonTextFieldEditor(
                      key: Key("${selectedHistoryModel?.historyId}-json-body"),
                      fieldKey:
                          "${selectedHistoryModel?.historyId}-json-body-viewer",
                      initialValue: requestModel?.body,
                      readOnly: true,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                _ => Padding(
                    padding: kPt5o10,
                    child: TextFieldEditor(
                      key: Key("${selectedHistoryModel?.historyId}-body"),
                      fieldKey:
                          "${selectedHistoryModel?.historyId}-body-viewer",
                      initialValue: requestModel?.body,
                      readOnly: true,
                    ),
                  ),
              },
            )
          ],
        ),
      APIType.graphql => Padding(
          padding: kPt5o10,
          child: TextFieldEditor(
            key: Key("${selectedHistoryModel?.historyId}-query"),
            fieldKey: "${selectedHistoryModel?.historyId}-query-viewer",
            initialValue: requestModel?.query,
            readOnly: true,
          ),
        ),
      _ => kSizedBoxEmpty,
    };
  }
}
