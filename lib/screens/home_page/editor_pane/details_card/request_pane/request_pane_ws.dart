import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_headers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_params.dart';
import 'ws/ws_message_editor.dart';
import 'ws/ws_connection_settings.dart';

/// Editor pane shown when `APIType.websocket` is selected.
///
/// Provides tabs for composing a message, editing URL params, custom
/// handshake headers, and toggling connection settings (e.g. auto-reconnect).
class EditWSRequestPane extends ConsumerWidget {
  const EditWSRequestPane({
    super.key,
    this.showViewCodeButton = true,
  });

  final bool showViewCodeButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));
    final hasWsModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.wsRequestModel != null));
    final paramLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.params?.length)) ??
        0;
    final headerLength = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.headers?.length)) ??
        0;

    if (!hasWsModel) return kSizedBoxEmpty;

    return RequestPane(
      selectedId: selectedId,
      // WebSocket requests have no code generation, so the
      // "View Code" button is always hidden regardless of platform.
      showViewCodeButton: false,
      codePaneVisible: false,
      tabIndex: tabIndex,
      onTapTabBar: (index) {
        ref
            .read(activeCollectionProvider.notifier)
            .update(requestTabIndex: index);
      },
      showIndicators: [
        false,
        paramLength > 0,
        headerLength > 0,
        false,
      ],
      tabLabels: const [
        "Message",
        kLabelURLParams,
        kLabelHeaders,
        kLabelSettings,
      ],
      children: [
        WsMessageEditor(key: ValueKey("$selectedId-ws-message")),
        const EditRequestURLParams(),
        const EditRequestHeaders(),
        WsConnectionSettings(key: ValueKey("$selectedId-ws-settings")),
      ],
    );
  }
}
