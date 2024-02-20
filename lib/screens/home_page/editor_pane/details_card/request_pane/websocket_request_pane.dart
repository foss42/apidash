import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_headers.dart';
import 'request_params.dart';
import 'request_body.dart';

class EditWebsocketRequestPane extends ConsumerWidget {
  const EditWebsocketRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));

    final messageLength = ref.watch(
        selectedRequestModelProvider.select((value) => value?.message?.length));
    final headerLength = ref.watch(selectedRequestModelProvider
        .select((value) => value?.headersMap.length));
    final paramLength = ref.watch(selectedRequestModelProvider
        .select((value) => value?.paramsMap.length));
    final bodyLength = ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestBody?.length));

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
            .update(selectedId!, requestTabIndex: index);
      },
      showIndicators: [
        messageLength != null && messageLength > 0,
        paramLength != null && paramLength > 0,
        headerLength != null && headerLength > 0,
        bodyLength != null && bodyLength > 0,
      ],
      tabLabels: const [
        'Message',
        'URL Params',
        'Headers',
        'Body',
      ],
      children: const [
        EditRequestMessage(),
        EditRequestURLParams(),
        EditRequestHeaders(),
        EditRequestBody(),
      ],
    );
  }
}
