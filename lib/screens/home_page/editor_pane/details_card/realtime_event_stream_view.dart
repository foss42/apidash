import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/ws_request_model.dart';
/// A real-time, log-style view of WebSocket messages.
///
/// Each entry shows direction (sent / received), a timestamp, and the
/// payload. Tapping an entry copies the payload to the clipboard.
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

    final logContent = InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: msg.payload));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Copied to clipboard"),
            duration: Duration(milliseconds: 600),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: SelectableText.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(dirIcon, size: 14, color: labelColor),
              ),
              const TextSpan(text: " "),
              TextSpan(
                text: "[$time] ",
                style: kCodeStyle.copyWith(
                    fontSize: 12, color: Colors.grey),
              ),
              const TextSpan(text: " - "),
              TextSpan(
                text: displayPayload,
                style: kCodeStyle.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: logContent),
        if (isLongMessage)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, right: 12.0),
            child: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, size: 18),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              tooltip: _isExpanded ? "Collapse" : "Expand",
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 16,
            ),
          ),
      ],
    );
  }
}
