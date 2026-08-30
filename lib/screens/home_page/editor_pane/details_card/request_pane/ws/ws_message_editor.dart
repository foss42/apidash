import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:apidash/widgets/widgets.dart';
import 'ws_recently_sent.dart';

/// Message composer tab. Owns all ephemeral UI state (message draft,
/// template search, hover preview, loaded templates) so it survives
/// rebuilds of the surrounding pane. Watches nothing itself; the
/// `messageHistory` watch lives in the `WsRecentlySent` child so incoming
/// WS frames rebuild only the strip, never the composer (whose draft is
/// mirrored to a plain String to stay stable across any rebuild).
// templates are temporary for now. They should be stored in database.
class WsMessageEditor extends ConsumerStatefulWidget {
  const WsMessageEditor({super.key});

  @override
  ConsumerState<WsMessageEditor> createState() => _WsMessageEditorState();
}

class _WsMessageEditorState extends ConsumerState<WsMessageEditor> {
  String _draft = "";
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
                  SizedBox(
                    height: 400,
                    child: TextFieldEditor(
                      fieldKey: "ws-template-json-${index ?? 'new'}",
                      initialValue: dataController.text,
                      hintText: "JSON Payload",
                      onChanged: (value) {
                        dataController.text = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ADTextButton(
              label: kLabelCancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
            ADFilledButton(
              label: kLabelSave,
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
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                    setState(() {
                                      _draft = t["data"] ?? "";
                                    });
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
                      return ADTextButton(
                        icon: Icons.bookmark_outline,
                        iconSize: 16,
                        label: "Templates",
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
                  ADIconButton(
                    icon: Icons.save_outlined,
                    iconSize: 20,
                    tooltip: "Save as template",
                    onPressed: () {
                      final payload = _draft.trim();
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
              ADFilledButton(
                icon: Icons.send,
                iconSize: 16,
                label: kLabelSend,
                onPressed: () {
                  final value = _draft;
                  final selectedId = ref.read(selectedIdStateProvider);
                  if (value.isNotEmpty && selectedId != null) {
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .sendWebSocketMessage(selectedId, value);
                    setState(() {
                      _draft = "";
                    });
                  }
                },
              ),
            ],
          ),
          kVSpacer10,
          Expanded(
            child: TextFieldEditor(
              fieldKey: "ws-message-composer",
              initialValue: _draft,
              hintText: "Enter message to send...",
              onChanged: (value) {
                _draft = value; // assign ONLY — no setState (avoids cursor jumps)
              },
            ),
          ),
          kVSpacer10,
          WsRecentlySent(
            templates: _templates,
            onReuse: (payload) => setState(() {
              _draft = payload;
            }),
            onSaveTemplate: (name, payload) {
              if (name.isNotEmpty) {
                setState(() {
                  _templates.add({"name": name, "data": payload});
                  _saveTemplates();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Saved to Templates"), duration: Duration(milliseconds: 1000)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
