import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_headers.dart';
import 'request_body.dart';
import 'request_params.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditWebSocketRequestPane extends ConsumerWidget {
  const EditWebSocketRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    var tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final headerLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.webSocketRequestModel?.headersMap.length)) ??
        0;
    final paramLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.webSocketRequestModel?.paramsMap.length)) ??
        0;
    final message = ref.watch(selectedRequestModelProvider
            .select((value) => value?.webSocketRequestModel?.message)) ??
        "";

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
        !kIsWeb && headerLength > 0,
        message.isNotEmpty,
      ],
      tabLabels: const [
        kLabelURLParams,
        if(!kIsWeb) kLabelHeaders,
        kLabelMessage,
      ],
      children: const [
        EditRequestURLParams(),
        if (!kIsWeb) EditRequestHeaders(),
        EditRequestBody(),
      ],
    );
  }
}
