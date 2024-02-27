import 'package:apidash/consts.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/websocket_message_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_headers.dart';
import 'request_params.dart';
import 'request_body.dart';

class EditRequestPane extends ConsumerWidget {
  const EditRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final protocol = ref
        .watch(selectedRequestModelProvider.select((value) => value?.protocol));
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));

    final headerLength = ref.watch(selectedRequestModelProvider
        .select((value) => value?.headersMap.length));
    final paramLength = ref.watch(selectedRequestModelProvider
        .select((value) => value?.paramsMap.length));
    final bodyLength = ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestBody?.length));
    final messageLength = ref.watch(
        selectedRequestModelProvider.select((value) => value?.message?.length));

    if (protocol == ProtocolType.websocket) {
      return WebSocketRequestPane(
          selectedId: selectedId,
          codePaneVisible: codePaneVisible,
          tabIndex: tabIndex,
          paramLength: paramLength,
          headerLength: headerLength,
          messageLength: messageLength,
          ref: ref);
    } else {
      return HTTPRequestPane(
          selectedId: selectedId,
          codePaneVisible: codePaneVisible,
          tabIndex: tabIndex,
          paramLength: paramLength,
          headerLength: headerLength,
          bodyLength: bodyLength,
          ref: ref);
    }
  }
}

class HTTPRequestPane extends StatelessWidget {
  const HTTPRequestPane({
    super.key,
    required this.selectedId,
    required this.codePaneVisible,
    required this.tabIndex,
    required this.paramLength,
    required this.headerLength,
    required this.bodyLength,
    required this.ref,
  });

  final String? selectedId;
  final bool codePaneVisible;
  final int? tabIndex;
  final int? paramLength;
  final int? headerLength;
  final int? bodyLength;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return RequestPane(
      selectedId: selectedId,
      codePaneVisible: codePaneVisible,
      tabIndex: tabIndex,
      tabs: const ['URL Params', 'Headers', 'Body'],
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
        paramLength != null && paramLength! > 0,
        headerLength != null && headerLength! > 0,
        bodyLength != null && bodyLength! > 0,
      ],
      children: const [
        EditRequestURLParams(),
        EditRequestHeaders(),
        EditRequestBody(),
      ],
    );
  }
}

class WebSocketRequestPane extends StatelessWidget {
  const WebSocketRequestPane({
    super.key,
    required this.selectedId,
    required this.codePaneVisible,
    required this.tabIndex,
    required this.messageLength,
    required this.headerLength,
    required this.paramLength,
    required this.ref,
  });

  final String? selectedId;
  final bool codePaneVisible;
  final int? tabIndex;
  final int? paramLength;
  final int? headerLength;
  final int? messageLength;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return RequestPane(
      selectedId: selectedId,
      codePaneVisible: codePaneVisible,
      tabs: const ['Message', 'URL Params', 'Headers'],
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
        messageLength != null && messageLength! > 0,
        paramLength != null && paramLength! > 0,
        headerLength != null && headerLength! > 0,
      ],
      children: const [
        EditWebsocketMessage(),
        EditRequestURLParams(),
        EditRequestHeaders(),
      ],
    );
  }
}
