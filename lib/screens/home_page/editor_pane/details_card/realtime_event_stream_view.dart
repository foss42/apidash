import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash/widgets/button_copy.dart';
/// A real-time, log-style view of WebSocket messages.
///
/// Each entry shows direction (sent / received), a timestamp, a label, and
/// the payload. An always-visible "Copy" button copies the full payload to
/// the clipboard. Long messages are truncated; tapping a collapsed message
/// expands it (works with mouse and touch), and once expanded the text is
/// selectable so part of it can be copied. "Show less" collapses it again.
class RealtimeEventStreamView extends ConsumerStatefulWidget {
  const RealtimeEventStreamView({super.key, this.historyMessages});

  final List<WebSocketMessage>? historyMessages;

  @override
  ConsumerState<RealtimeEventStreamView> createState() => _RealtimeEventStreamViewState();
}

class _RealtimeEventStreamViewState extends ConsumerState<RealtimeEventStreamView> {
  final TextEditingController _filterController = TextEditingController();
  TextEditingController? _autocompleteController;
  String _filterQuery = "";
  final List<String> _selectedTopics = [];

  /// Set by [Autocomplete.onSelected] so the field's submit handler can tell
  /// whether Enter was consumed by selecting the highlighted dropdown option
  /// (via RawAutocomplete's onFieldSubmitted, which selects the highlighted
  /// entry iff the options view is showing and is a no-op otherwise).
  bool _submitHandledBySelection = false;

  @override
  void dispose() {
    _filterController.dispose();
    _autocompleteController = null;
    super.dispose();
  }

  bool _isTopicMatch(String filterTopic, String actualTopic) {
    if (filterTopic == actualTopic) return true;

    List<String> filterLevels = filterTopic.split('/');
    List<String> topicLevels = actualTopic.split('/');

    for (int i = 0; i < filterLevels.length; i++) {
      if (filterLevels[i] == '#') {
        return true;
      }
      if (i >= topicLevels.length) {
        return false;
      }
      if (filterLevels[i] != '+' && filterLevels[i] != topicLevels[i]) {
        return false;
      }
    }
    return filterLevels.length == topicLevels.length;
  }

  @override
  Widget build(BuildContext context) {
    final requestModel = widget.historyMessages == null ? ref.watch(selectedRequestModelProvider) : null;
    final wsModel = requestModel?.wsRequestModel;
    final mqttModel = requestModel?.mqttRequestModel;

    final history = widget.historyMessages ??
        (requestModel?.apiType == APIType.mqtt
            ? (mqttModel?.messageHistory ?? [])
            : (wsModel?.messageHistory ?? []));

    final settings = ref.watch(settingsProvider);
    final maxEvents = settings.maxConnectionMessages;

    final availableTopics = history
        .map((e) => e.metadata)
        .whereType<String>()
        .toSet()
        .toList();

    final filteredHistory = history.where((msg) {
      bool matchesTopics = true;
      if (_selectedTopics.isNotEmpty) {
        matchesTopics = msg.metadata != null && 
            _selectedTopics.any((filter) => _isTopicMatch(filter, msg.metadata!));
      }
      
      bool matchesQuery = true;
      if (_filterQuery.isNotEmpty) {
        matchesQuery = msg.payload.toLowerCase().contains(_filterQuery.toLowerCase());
      }
      
      return matchesTopics && matchesQuery;
    }).toList();

    var displayHistory = filteredHistory;
    if (displayHistory.length > maxEvents) {
      displayHistory = displayHistory.sublist(displayHistory.length - maxEvents);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (history.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedTopics.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _selectedTopics.map((topic) {
                        return InputChip(
                          label: Text(topic, style: const TextStyle(fontSize: 12)),
                          visualDensity: VisualDensity.compact,
                          onDeleted: () {
                            setState(() {
                              _selectedTopics.remove(topic);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            // Empty field: offer every known topic so users
                            // can browse and pick one instead of typing it.
                            return availableTopics;
                          }
                          return availableTopics.where((String option) {
                            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          _submitHandledBySelection = true;
                          setState(() {
                            if (!_selectedTopics.contains(selection)) {
                              _selectedTopics.add(selection);
                            }
                            _filterQuery = "";
                          });
                          // Autocomplete automatically updates the controller with the selection,
                          // so we need to clear it in the next frame.
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _autocompleteController?.clear();
                          });
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          _autocompleteController = controller;
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: requestModel?.apiType == APIType.mqtt
                                  ? "Select a topic to filter..."
                                  : "Filter messages...",
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              prefixIcon: const Icon(Icons.filter_list, size: 18),
                              suffixIcon: controller.text.isNotEmpty || _selectedTopics.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 16),
                                      onPressed: () {
                                        controller.clear();
                                        setState(() {
                                          _filterQuery = "";
                                          _selectedTopics.clear();
                                        });
                                      },
                                    )
                                  : null,
                            ),
                            onSubmitted: (val) {
                              if (requestModel?.apiType != APIType.mqtt) {
                                return;
                              }
                              // Dropdown open: Enter picks the highlighted
                              // option — exactly like tapping it. The
                              // RawAutocomplete-provided onFieldSubmitted
                              // selects the highlighted entry only while the
                              // options view is showing (no-op otherwise);
                              // onSelected sets the flag when it runs. This
                              // works because the done action's unfocus is
                              // applied asynchronously by the FocusManager,
                              // so the options view is still "showing" here.
                              _submitHandledBySelection = false;
                              onFieldSubmitted();
                              if (_submitHandledBySelection) {
                                // Undo the pending unfocus so the dropdown
                                // re-opens after the post-frame clear and the
                                // user can keep picking topics — same flow as
                                // tap-selection.
                                focusNode.requestFocus();
                                return;
                              }
                              // No visible options: fall back to validated
                              // Enter on the typed text.
                              final topic = val.trim();
                              if (topic.isNotEmpty) {
                                // Only apply the filter when the text matches a
                                // topic actually seen in this request's message
                                // history (exact, or an MQTT +/# wildcard that
                                // matches at least one known topic). A mistyped
                                // Enter must not silently filter everything out.
                                final isKnownTopic = availableTopics
                                    .any((actual) => _isTopicMatch(topic, actual));
                                if (!isKnownTopic) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("No such topic"),
                                      duration: Duration(milliseconds: 1000),
                                    ),
                                  );
                                  // Keep the text and focus so the user can fix it.
                                  focusNode.requestFocus();
                                  return;
                                }
                                setState(() {
                                  if (!_selectedTopics.contains(topic)) {
                                    _selectedTopics.add(topic);
                                  }
                                  controller.clear();
                                  _filterQuery = "";
                                });
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                _filterQuery = val;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    if (widget.historyMessages == null) ...[
                      kHSpacer5,
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        tooltip: "Clear messages",
                        onPressed: () {
                          if (requestModel?.apiType == APIType.websocket &&
                              wsModel != null) {
                            ref
                                .read(collectionStateNotifierProvider.notifier)
                                .update(
                                  wsRequestModel:
                                      wsModel.copyWith(messageHistory: []),
                                );
                          } else if (requestModel?.apiType == APIType.mqtt &&
                              mqttModel != null) {
                            ref
                                .read(collectionStateNotifierProvider.notifier)
                                .update(
                                  mqttRequestModel:
                                      mqttModel.copyWith(messageHistory: []),
                                );
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        const Divider(height: 1),
        // Log content
        Expanded(
          child: history.isEmpty
              ? const Center(
                  child: Text(
                    "No messages yet. Connect to start.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : _buildLogView(context, displayHistory),
        ),
      ],
    );
  }

  Widget _buildLogView(
      BuildContext context, List<WebSocketMessage> history) {
    // Key by message identity so _LogEntry expand state follows its message,
    // not its list slot (the list is rendered newest-first).
    Key keyFor(WebSocketMessage m) =>
        ValueKey((m.timestamp, m.messageType, m.payload));

    return ListView.builder(
      itemCount: history.length,
      padding: const EdgeInsets.symmetric(vertical: 4),
      // Appends shift every newest-first slot by one; map keys back to
      // indices so keyed children keep their State instead of being
      // rebuilt by position.
      findChildIndexCallback: (key) {
        final valueKey = key as ValueKey;
        for (var i = 0; i < history.length; i++) {
          if (keyFor(history[history.length - 1 - i]) == valueKey) return i;
        }
        return null;
      },
      itemBuilder: (context, index) {
        final msg = history[history.length - 1 - index];
        return _LogEntry(key: keyFor(msg), msg: msg);
      },
    );
  }
}


class _LogEntry extends StatefulWidget {
  const _LogEntry({super.key, required this.msg});
  final WebSocketMessage msg;

  @override
  State<_LogEntry> createState() => _LogEntryState();
}

class _LogEntryState extends State<_LogEntry> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final msg = widget.msg;
    final isLongMessage = msg.payload.length > 300;
    final displayPayload = (_isExpanded || !isLongMessage)
        ? msg.payload
        : "${msg.payload.substring(0, 300)}...";
    final time = msg.timestamp != null
        ? "${msg.timestamp!.hour.toString().padLeft(2, '0')}:"
          "${msg.timestamp!.minute.toString().padLeft(2, '0')}:"
          "${msg.timestamp!.second.toString().padLeft(2, '0')}"
        : "";

    final (Color labelColor, String labelText, IconData dirIcon) =
        switch (msg.messageType) {
      WebSocketMessageType.connected => (
        kColorWsConnected,
        "Connected",
        Icons.link,
      ),
      WebSocketMessageType.sent => (
        kColorWsSent,
        "Sent",
        Icons.arrow_upward,
      ),
      WebSocketMessageType.received => (
        kColorWsReceived,
        "Received",
        Icons.arrow_downward,
      ),
      WebSocketMessageType.error => (
        kColorWsError,
        "Error",
        Icons.error_outline,
      ),
      WebSocketMessageType.disconnected => (
        kColorWsDisconnected,
        "Disconnected",
        Icons.link_off,
      ),
    };

    final theme = Theme.of(context);

    // Payload section — works for both desktop (mouse) and Android (touch):
    //  • Collapsed long message: non-selectable Text inside an InkWell, so a
    //    tap/click expands it (ripple feedback on touch, hover on desktop).
    //    No SelectableText here means tap-to-expand never fights selection.
    //  • Short message OR expanded long message: SelectableText, so users can
    //    drag-select (desktop) or long-press-select (Android) to copy part of
    //    it. Collapsing uses the explicit "Show less" button so the selection
    //    gesture is never hijacked.
    final Widget payloadSection;
    if (isLongMessage && !_isExpanded) {
      payloadSection = InkWell(
        onTap: () => setState(() => _isExpanded = true),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayPayload,
                style: kCodeStyle.copyWith(fontSize: 12),
              ),
              if (msg.metadata != null && msg.metadata!.isNotEmpty)
                Text(
                  "Topic: ${msg.metadata}",
                  style: kCodeStyle.copyWith(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              kVSpacer3,
              Text(
                "Show more",
                style: kCodeStyle.copyWith(
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      payloadSection = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            displayPayload,
            style: kCodeStyle.copyWith(fontSize: 12),
          ),
          if (msg.metadata != null && msg.metadata!.isNotEmpty)
            Text(
              "Topic: ${msg.metadata}",
              style: kCodeStyle.copyWith(
                fontSize: 11,
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),
          if (isLongMessage)
            TextButton(
              onPressed: () => setState(() => _isExpanded = false),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 0),
                // 48dp min tap target so it's comfortable on touch screens.
                tapTargetSize: MaterialTapTargetSize.padded,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text("Show less"),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: direction icon, [time], label, and an always-visible
          // Copy button. The Copy button copies the FULL payload, never the
          // truncated preview, regardless of expand state.
          Row(
            children: [
              Icon(dirIcon, size: 14, color: labelColor),
              kHSpacer5,
              Text(
                "[$time]",
                style: kCodeStyle.copyWith(fontSize: 12, color: Colors.grey),
              ),
              kHSpacer5,
              Text(
                labelText,
                style: kCodeStyle.copyWith(fontSize: 12, color: labelColor),
              ),
              const Spacer(),
              CopyButton(toCopy: msg.payload, showLabel: false),
            ],
          ),
          kVSpacer3,
          payloadSection,
        ],
      ),
    );
  }
}
