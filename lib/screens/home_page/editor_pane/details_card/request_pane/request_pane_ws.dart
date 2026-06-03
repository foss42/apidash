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
// templates are temporary for now. They should be stored in database.
class _EditWSRequestPaneState extends ConsumerState<EditWSRequestPane> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _templates = [
    {"name": "Ping Message", "data": '{\n  "type": "ping",\n  "timestamp": 12345\n}'},
    {"name": "Auth Message", "data": '{\n  "type": "auth",\n  "token": "Bearer YOUR_TOKEN_HERE"\n}'}
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showTemplatesModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("Templates"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final template = _templates[index];
                    return ListTile(
                      title: Text(template["name"] ?? ""),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye, size: 18),
                            tooltip: "Preview JSON",
                            onPressed: () {
                              _showJsonPreview(context, template["data"] ?? "");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            tooltip: "Edit Template",
                            onPressed: () {
                              _showEditTemplateDialog(context, index, setModalState);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18),
                            tooltip: "Delete Template",
                            onPressed: () {
                              setModalState(() {
                                _templates.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        _controller.text = template["data"] ?? "";
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () {
                    _showEditTemplateDialog(context, null, setModalState);
                  },
                  label: const Text("Create"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showJsonPreview(BuildContext context, String json) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Preview"),
          content: SingleChildScrollView(
            child: SelectableText(json, style: kCodeStyle),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      }
    );
  }

  void _showEditTemplateDialog(BuildContext context, int? index, StateSetter setModalState) {
    final isEditing = index != null;
    final nameController = TextEditingController(text: isEditing ? _templates[index]["name"] : "");
    final dataController = TextEditingController(text: isEditing ? _templates[index]["data"] : "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Edit Template" : "New Template"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Template Name"),
              ),
              kVSpacer10,
              TextField(
                controller: dataController,
                maxLines: 5,
                style: kCodeStyle,
                decoration: const InputDecoration(
                  labelText: "JSON Payload",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setModalState(() {
                  if (isEditing) {
                    _templates[index] = {
                      "name": nameController.text,
                      "data": dataController.text,
                    };
                  } else {
                    _templates.add({
                      "name": nameController.text,
                      "data": dataController.text,
                    });
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      }
    );
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
                          kHSpacer10,
                          OutlinedButton.icon(
                            icon: const Icon(Icons.list_alt, size: 16),
                            label: const Text("Templates"),
                            onPressed: () => _showTemplatesModal(context),
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
