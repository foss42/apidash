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
  String _filterQuery = "";

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestModel = widget.historyMessages == null ? ref.watch(selectedRequestModelProvider) : null;
    final wsModel = requestModel?.wsRequestModel;
    final history = widget.historyMessages ?? wsModel?.messageHistory ?? [];

    final settings = ref.watch(settingsProvider);
    final maxEvents = settings.maxWebSocketEvents;

    final filteredHistory = _filterQuery.isEmpty
        ? history
        : history.where((msg) => msg.payload.toLowerCase().contains(_filterQuery.toLowerCase())).toList();

    var displayHistory = filteredHistory;
    if (displayHistory.length > maxEvents) {
      displayHistory = displayHistory.sublist(displayHistory.length - maxEvents);
    }

    return Column(
      children: [
        if (history.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
              controller: _filterController,
              decoration: InputDecoration(
                hintText: "Filter messages...",
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                prefixIcon: const Icon(Icons.filter_list, size: 18),
                suffixIcon: _filterQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () {
                          _filterController.clear();
                          setState(() {
                            _filterQuery = "";
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() {
                  _filterQuery = val;
                });
              },
            ),
          ),
          if (widget.historyMessages == null) ...[
            kHSpacer5,
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              tooltip: "Clear messages",
              onPressed: () {
                if (wsModel != null) {
                  ref.read(collectionStateNotifierProvider.notifier).update(
                        wsRequestModel:
                            wsModel.copyWith(messageHistory: []),
                      );
                }
              },
            ),
          ],
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
    return ListView.builder(
      itemCount: history.length,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemBuilder: (context, index) {
        final msg = history[history.length - 1 - index];
        return _LogEntry(msg: msg);
      },
    );
  }
}


class _LogEntry extends StatefulWidget {
  const _LogEntry({required this.msg});
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
        Colors.teal.shade400,
        "Connected",
        Icons.link,
      ),
      WebSocketMessageType.sent => (
        Colors.blue.shade400,
        "Sent",
        Icons.arrow_upward,
      ),
      WebSocketMessageType.received => (
        Colors.green.shade400,
        "Received",
        Icons.arrow_downward,
      ),
      WebSocketMessageType.error => (
        Colors.red.shade400,
        "Error",
        Icons.error_outline,
      ),
      WebSocketMessageType.disconnected => (
        Colors.orange.shade400,
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
