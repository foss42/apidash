import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_headers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_params.dart';

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
            .read(collectionStateNotifierProvider.notifier)
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
        _WsMessageEditor(key: ValueKey("$selectedId-ws-message")),
        const EditRequestURLParams(),
        const EditRequestHeaders(),
        _WsConnectionSettings(key: ValueKey("$selectedId-ws-settings")),
      ],
    );
  }
}

/// Message composer tab. Owns all ephemeral UI state (message draft,
/// template search, hover preview, loaded templates) so it survives
/// rebuilds of the surrounding pane. Only watches `messageHistory`
/// (for "Recently Sent"), which is untouched by URL edits.
// templates are temporary for now. They should be stored in database.
class _WsMessageEditor extends ConsumerStatefulWidget {
  const _WsMessageEditor({super.key});

  @override
  ConsumerState<_WsMessageEditor> createState() => _WsMessageEditorState();
}

class _WsMessageEditorState extends ConsumerState<_WsMessageEditor> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _dropdownController = TextEditingController();
  String? _hoveredPreviewData;
  List<Map<String, String>> _templates = [];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  @override
  void dispose() {
    _controller.dispose();
    _dropdownController.dispose();
    super.dispose();
  }

  void _loadTemplates() {
    final stored = hiveHandler.getWsTemplates();
    if (stored != null && stored is List) {
      _templates = stored.map((e) => Map<String, String>.from(e)).toList();
    } else {
      _templates = [];
    }
  }

  void _saveTemplates() {
    hiveHandler.setWsTemplates(_templates);
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
          content: SizedBox(
            width: 800,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: "Template Name"),
                  ),
                  kVSpacer10,
                  TextField(
                    controller: dataController,
                    maxLines: 20,
                    style: kCodeStyle,
                    decoration: const InputDecoration(
                      labelText: "JSON Payload",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
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
                  _saveTemplates();
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
    // Narrow watch: only the message history. Its list identity is preserved
    // by copyWith on URL edits, so typing in the URL field does not rebuild
    // this widget.
    final messageHistory = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.messageHistory)) ??
        const <WebSocketMessage>[];

    final sentHistory = messageHistory
        .where((m) => m.outgoing && m.messageType == WebSocketMessageType.sent && m.payload != "Heartbeat ping")
        .map((m) => m.payload)
        .toList()
        .reversed
        .take(10)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MenuAnchor(
                    menuChildren: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: SizedBox(
                          width: 320,
                          child: TextField(
                            controller: _dropdownController,
                            decoration: InputDecoration(
                              hintText: 'Search templates...',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                              isDense: true,
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                              prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onChanged: (val) {
                              setState(() {}); // Rebuild menu with filtered items
                            },
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _templates.asMap().entries
                                .where((e) => (e.value["name"] ?? "").toLowerCase().contains(_dropdownController.text.toLowerCase()))
                                .map((e) {
                              final index = e.key;
                              final t = e.value;
                              return MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    _hoveredPreviewData = t["data"];
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    _hoveredPreviewData = null;
                                  });
                                },
                                child: MenuItemButton(
                                  onPressed: () {
                                    _controller.text = t["data"] ?? "";
                                    _dropdownController.clear();
                                  },
                                  child: SizedBox(
                                    width: 300,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            t["name"] ?? "",
                                            style: kCodeStyle.copyWith(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, size: 14),
                                              tooltip: "Edit Template",
                                              constraints: const BoxConstraints(),
                                              onPressed: () {
                                                _showEditTemplateDialog(context, index, setState);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, size: 14),
                                              tooltip: "Delete Template",
                                              constraints: const BoxConstraints(),
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              onPressed: () {
                                                setState(() {
                                                  _templates.removeAt(index);
                                                  _saveTemplates();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      MenuItemButton(
                        leadingIcon: const Icon(Icons.add, size: 16),
                        onPressed: () {
                          _showEditTemplateDialog(context, null, setState);
                        },
                        child: const Text("Create New Template"),
                      ),
                      const Divider(height: 1),
                      Container(
                        width: 320,
                        height: 120, // Fixed height so the menu size doesn't jump
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            _hoveredPreviewData ?? "Hover over an item to preview JSON...",
                            style: kCodeStyle.copyWith(
                              fontSize: 11,
                              color: _hoveredPreviewData == null ? Colors.grey : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                    builder: (context, controller, child) {
                      return OutlinedButton.icon(
                        icon: const Icon(Icons.bookmark_outline, size: 16),
                        label: const Text("Templates"),
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                      );
                    },
                  ),
                  kHSpacer5,
                  IconButton(
                    icon: const Icon(Icons.save_outlined, size: 20),
                    tooltip: "Save as template",
                    onPressed: () {
                      final payload = _controller.text.trim();
                      if (payload.isNotEmpty) {
                        setState(() {
                          _templates.add({
                            "name": "Template ${_templates.length + 1}",
                            "data": payload,
                          });
                          _saveTemplates();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Saved to Templates"), duration: Duration(milliseconds: 1000)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Message is empty"), duration: Duration(milliseconds: 1000)),
                        );
                      }
                    },
                  ),
                ],
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.send, size: 16),
                label: const Text("Send"),
                onPressed: () {
                  final value = _controller.text;
                  final selectedId = ref.read(selectedIdStateProvider);
                  if (value.isNotEmpty && selectedId != null) {
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .sendWebSocketMessage(selectedId, value);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
          kVSpacer10,
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Recently Sent", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          kVSpacer5,
          if (sentHistory.isEmpty)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("No recently sent messages", style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic)),
            )
          else
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sentHistory.length,
                separatorBuilder: (_, __) => kHSpacer10,
                itemBuilder: (context, index) {
                  final payload = sentHistory[index];

                  Map<String, String>? matchingTemplate;
                  try {
                    matchingTemplate = _templates.firstWhere((t) => t["data"] == payload);
                  } catch (_) {}

                  final title = matchingTemplate?["name"];

                  return Tooltip(
                    message: payload,
                    waitDuration: const Duration(milliseconds: 600),
                    textStyle: kCodeStyle.copyWith(color: Colors.white, fontSize: 11),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        _controller.text = payload;
                      },
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: title != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : SizedBox(
                                        height: 24,
                                        child: TextField(
                                          style: const TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                            hintText: "Name & Enter to save",
                                            hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                                            isDense: true,
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.3),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.3),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 0.5),
                                            ),
                                          ),
                                          onSubmitted: (val) {
                                            if (val.trim().isNotEmpty) {
                                              setState(() {
                                                _templates.add({
                                                  "name": val.trim(),
                                                  "data": payload,
                                                });
                                                _saveTemplates();
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Saved to Templates"), duration: Duration(milliseconds: 1000)),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                payload,
                                style: kCodeStyle.copyWith(fontSize: 11, color: Colors.grey),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Connection settings tab. Stateless; watches only the specific
/// `wsRequestModel` fields it displays, and reads the latest model
/// inside callbacks when writing updates.
class _WsConnectionSettings extends ConsumerWidget {
  const _WsConnectionSettings({super.key});

  void _updateWsModel(
    WidgetRef ref,
    WebSocketRequestModel Function(WebSocketRequestModel) updater,
  ) {
    final wsModel = ref.read(selectedRequestModelProvider)?.wsRequestModel;
    if (wsModel == null) return;
    ref
        .read(collectionStateNotifierProvider.notifier)
        .update(wsRequestModel: updater(wsModel));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoReconnect = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.autoReconnect)) ??
        false;
    final enableHeartbeat = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.enableHeartbeat)) ??
        false;
    final heartbeatInterval = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.heartbeatInterval)) ??
        30;
    final enableMessageHeartbeat = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.enableMessageHeartbeat)) ??
        false;
    final messageHeartbeatInterval = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.messageHeartbeatInterval)) ??
        30;
    final messageHeartbeatPayload = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.messageHeartbeatPayload)) ??
        "ping";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text("Auto Reconnect"),
            subtitle: const Text(
                "Automatically reconnect when the server closes the connection"),
            value: autoReconnect,
            onChanged: (val) {
              _updateWsModel(ref, (ws) => ws.copyWith(autoReconnect: val));
            },
          ),
          // ── Group A: Automatic ping ─────────────────
          SwitchListTile(
            title: const Text("Send automatic pings"),
            subtitle: const Text(
                "Low-level keep-alive most servers understand. You won't see these in the messages."),
            value: enableHeartbeat,
            onChanged: (val) {
              _updateWsModel(ref, (ws) => ws.copyWith(enableHeartbeat: val));
            },
          ),
          if (enableHeartbeat)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                initialValue: heartbeatInterval.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Ping every (seconds)",
                ),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null) {
                    _updateWsModel(
                        ref, (ws) => ws.copyWith(heartbeatInterval: parsed));
                  }
                },
              ),
            ),
          kVSpacer10,
          const Divider(),
          kVSpacer10,
          // ── Group B: Repeating message ──────────────
          SwitchListTile(
            title: const Text("Send a repeating message"),
            subtitle: const Text(
                "Send your own text/JSON on a schedule. Some servers need this instead of pings."),
            value: enableMessageHeartbeat,
            onChanged: (val) {
              _updateWsModel(
                  ref, (ws) => ws.copyWith(enableMessageHeartbeat: val));
            },
          ),
          if (enableMessageHeartbeat) ...[
            kVSpacer10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                initialValue: messageHeartbeatPayload,
                maxLines: 3,
                style: kCodeStyle,
                decoration: const InputDecoration(
                  labelText: "Message",
                  hintText: "ping",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  _updateWsModel(
                      ref, (ws) => ws.copyWith(messageHeartbeatPayload: val));
                },
              ),
            ),
            kVSpacer10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                initialValue: messageHeartbeatInterval.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Send every (seconds)",
                ),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null) {
                    _updateWsModel(ref,
                        (ws) => ws.copyWith(messageHeartbeatInterval: parsed));
                  }
                },
              ),
            ),
            kVSpacer10,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "These appear in the messages as Sent.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
