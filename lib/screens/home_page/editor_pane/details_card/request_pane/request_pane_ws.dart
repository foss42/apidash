import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

/// Editor pane shown when `APIType.websocket` is selected.
///
/// Provides tabs for composing a message, editing custom handshake headers,
/// and toggling connection settings (e.g. auto-reconnect).
class EditWSRequestPane extends ConsumerStatefulWidget {
  const EditWSRequestPane({
    super.key,
    this.showViewCodeButton = true,
  });

  final bool showViewCodeButton;

  @override
  ConsumerState<EditWSRequestPane> createState() => _EditWSRequestPaneState();
}

class _EditWSRequestPaneState extends ConsumerState<EditWSRequestPane> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref.watch(selectedRequestModelProvider);
    final wsModel = requestModel?.wsRequestModel;

    if (wsModel == null) return kSizedBoxEmpty;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: "Message"),
              Tab(text: "Headers"),
              Tab(text: "Settings"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // ── Message Tab ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: kCodeStyle,
                          decoration: InputDecoration(
                            hintText: "Enter message to send...",
                            hintStyle: kCodeStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      kVSpacer10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.send, size: 16),
                            label: const Text("Send"),
                            onPressed: () {
                              final value = _controller.text;
                              if (value.isNotEmpty) {
                                ref
                                    .read(collectionStateNotifierProvider
                                        .notifier)
                                    .sendWebSocketMessage(
                                        selectedId!, value);
                                _controller.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ── Headers Tab ──────────────────────────────────
                Padding(
                  padding: kP8,
                  child: ListView.builder(
                    itemCount: wsModel.customHeaders.length + 1,
                    itemBuilder: (context, index) {
                      if (index == wsModel.customHeaders.length) {
                        return ListTile(
                          title: const Text("Add Header"),
                          trailing: const Icon(Icons.add),
                          onTap: () {
                            // TODO: implement header add dialog
                          },
                        );
                      }
                      final key =
                          wsModel.customHeaders.keys.elementAt(index);
                      return ListTile(
                        title: Text(key),
                        subtitle:
                            Text(wsModel.customHeaders[key] ?? ""),
                      );
                    },
                  ),
                ),
                // ── Settings Tab ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text("Auto Reconnect"),
                        subtitle: const Text(
                            "Automatically reconnect when the server closes the connection"),
                        value: wsModel.autoReconnect,
                        onChanged: (val) {
                          ref
                              .read(collectionStateNotifierProvider.notifier)
                              .update(
                                wsRequestModel:
                                    wsModel.copyWith(autoReconnect: val),
                              );
                        },
                      ),
                      SwitchListTile(
                        title: const Text("WebSocket Heartbeat"),
                        subtitle: const Text(
                            "Send periodic keep-alive pings every 30 seconds"),
                        value: wsModel.enableHeartbeat,
                        onChanged: (val) {
                          ref
                              .read(collectionStateNotifierProvider.notifier)
                              .update(
                                wsRequestModel:
                                    wsModel.copyWith(enableHeartbeat: val),
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
