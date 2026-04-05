import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'request_headers.dart';
import 'request_params.dart';
import 'ws_message_tab.dart';

/// The request-side pane when APIType is [APIType.websocket].
///
/// Layout:
///   Tabs: Message | URL Params | Headers
class EditWSRequestPane extends ConsumerStatefulWidget {
  const EditWSRequestPane({super.key});

  @override
  ConsumerState<EditWSRequestPane> createState() => _EditWSRequestPaneState();
}

class _EditWSRequestPaneState extends ConsumerState<EditWSRequestPane>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final wsState = ref.watch(wsStateProvider(selectedId));

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter, meta: true): () {
          if (wsState.canSend) {
            ref.read(wsStateProvider(selectedId).notifier).send();
          }
        },
        const SingleActivator(LogicalKeyboardKey.enter, control: true): () {
          if (wsState.canSend) {
            ref.read(wsStateProvider(selectedId).notifier).send();
          }
        },
      },
      child: Focus(
        autofocus: true,
        child: Column(
      children: [
        kVSpacer10,
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: kLabelWsMessage),
            Tab(text: kLabelWsUrlParams),
            Tab(text: kLabelWsHeaders),
          ],
        ),
        kVSpacer8,
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              WsMessageTab(),
              EditRequestURLParams(),
              EditRequestHeaders(),
            ],
          ),
        ),
        // Send button bar — always visible, mirrors MQTT's MqttBottomBar pattern
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.icon(
                onPressed: wsState.canSend
                    ? () =>
                        ref.read(wsStateProvider(selectedId).notifier).send()
                    : null,
                icon: const Icon(Icons.send, size: 16),
                label: const Text(kLabelWsSend),
              ),
              kHSpacer8,
              Text(
                '⌘↵',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
      ),
    );
  }
}

