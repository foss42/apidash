import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_headers.dart';
import 'request_params.dart';
import 'request_body.dart';
import 'request_scripts.dart';

class EditRestRequestPane extends ConsumerWidget {
  const EditRestRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));

    final headerLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.headersMap.length)) ??
        0;
    final paramLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.paramsMap.length)) ??
        0;
    final hasBody = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.hasBody)) ??
        false;

    final scriptsLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.preRequestScript?.length)) ??
        ref.watch(selectedRequestModelProvider
            .select((value) => value?.postRequestScript?.length)) ??
        0;

    return RequestPane(
      selectedId: selectedId,
      codePaneVisible: codePaneVisible,
      tabIndex: tabIndex,
      onPressedCodeButton: () {
        ref.read(codePaneVisibleStateProvider.notifier).state =
            !codePaneVisible;
      },
      onTapTabBar: (index) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(requestTabIndex: index);
      },
      showIndicators: [
        paramLength > 0,
        headerLength > 0,
        hasBody,
        scriptsLength > 0,
      ],
      tabLabels: const [
        kLabelURLParams,
        kLabelHeaders,
        kLabelBody,
        kLabelScripts,
      ],
      children: const [
        EditRequestURLParams(),
        EditRequestHeaders(),
        EditRequestBody(),
        EditRequestScripts(),
      ],
    );
  }
}
