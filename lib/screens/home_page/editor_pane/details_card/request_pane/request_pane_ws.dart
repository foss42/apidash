import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_headers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_params.dart';

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
  final TextEditingController _dropdownController = TextEditingController();
  String? _hoveredPreviewData;
  List<Map<String, String>> _templates = [];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }
// some inbuilt templates
  void _loadTemplates() {
    final stored = hiveHandler.getWsTemplates();
    if (stored != null && stored is List) {
      _templates = stored.map((e) => Map<String, String>.from(e)).toList();
    } else {
      _templates = [
        {"name": "Ping Message", "data": '{\n  "type": "ping",\n  "timestamp": 12345\n}'},
        {"name": "Auth Message", "data": '{\n  "type": "auth",\n  "token": "Bearer YOUR_TOKEN_HERE"\n}'},
        {"name": "Binance BTC", "data": '{\n  "method": "SUBSCRIBE",\n  "params": ["btcusdt@ticker"],\n  "id": 1\n}'}
      ];
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
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref.watch(selectedRequestModelProvider);
    final wsModel = requestModel?.wsRequestModel;

    if (wsModel == null) return kSizedBoxEmpty;

    final sentHistory = wsModel.messageHistory
        .where((m) => m.outgoing && m.messageType == WebSocketMessageType.sent && m.payload != "Heartbeat ping")
        .map((m) => m.payload)
        .toList()
        .reversed
        .take(10)
        .toList();

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: "Message"),
              Tab(text: "Params"),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              ..._templates.asMap().entries
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
                                )
                              );
                              }),
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
                                        if (title != null) ...[
                                          Text(
                                            title,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                        ],
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
                ),
                // ── Params Tab ───────────────────────────────────
                const EditRequestURLParams(),
                // ── Headers Tab ──────────────────────────────────
                const EditRequestHeaders(),
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
                        subtitle: const Text("Send periodic keep-alive pings"),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          enabled: wsModel.enableHeartbeat,
                          initialValue: wsModel.heartbeatInterval.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Ping Interval (seconds)",
                          ),
                          onChanged: (val) {
                            final parsed = int.tryParse(val);
                            if (parsed != null) {
                              ref
                                  .read(collectionStateNotifierProvider.notifier)
                                  .update(
                                    wsRequestModel: wsModel.copyWith(
                                        heartbeatInterval: parsed),
                                  );
                            }
                          },
                        ),
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
