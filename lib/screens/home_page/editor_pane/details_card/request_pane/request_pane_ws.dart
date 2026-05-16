import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/protocols/websocket_model.dart';

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
    final protocolModel = requestModel?.protocolModel;
    final wsModel = protocolModel is WebSocketRequestModel ? protocolModel : null;

    if (wsModel == null) return kSizedBoxEmpty;

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: "Message"),
              Tab(text: "Headers"),
              Tab(text: "Params"),
              Tab(text: "Settings"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Message Tab
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
                            hintText: "Enter message...",
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
                          OutlinedButton(
                            onPressed: () {
                              final value = _controller.text;
                              if (value.isNotEmpty) {
                                ref.read(collectionStateNotifierProvider.notifier).sendWebSocketMessage(selectedId!, value);
                                _controller.clear();
                              }
                            },
                            child: const Text("Send"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Headers Tab
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
                             // Add header logic
                          },
                        );
                      }
                      final key = wsModel.customHeaders.keys.elementAt(index);
                      return ListTile(
                        title: Text(key),
                        subtitle: Text(wsModel.customHeaders[key] ?? ""),
                      );
                    },
                  ),
                ),
                // Params Tab
                const Center(child: Text("URL Parameters")),
                // Settings Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text("Auto Reconnect"),
                        value: wsModel.autoReconnect,
                        onChanged: (val) {
                          ref.read(collectionStateNotifierProvider.notifier).update(
                                protocolModel: wsModel.copyWith(autoReconnect: val),
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

