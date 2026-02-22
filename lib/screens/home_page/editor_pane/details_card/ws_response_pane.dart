import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Chat-style response panel for WebSocket conversations.
class WsResponsePane extends ConsumerWidget {
  const WsResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) {
      return const Center(child: Text('No request selected'));
    }

    final wsState = ref.watch(wsStateProvider(selectedId));
    final messages = wsState.messages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---- Status bar ----
        _WsStatusBar(selectedId: selectedId, status: wsState.status),
        const Divider(height: 1),
        // ---- Message list ----
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Text(
                    wsState.status == WsConnectionStatus.idle
                        ? 'Not connected yet.\nEnter a ws:// URL and press Connect.'
                        : wsState.isConnecting
                            ? 'Connecting…'
                            : 'No messages yet.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _WsMessageBubble(message: messages[index]);
                  },
                ),
        ),
        // ---- Actions ----
        if (messages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () =>
                    ref.read(wsStateProvider(selectedId).notifier).clearMessages(),
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear'),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Status bar
// ---------------------------------------------------------------------------

class _WsStatusBar extends ConsumerWidget {
  const _WsStatusBar({required this.selectedId, required this.status});
  final String selectedId;
  final WsConnectionStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (label, color) = switch (status) {
      WsConnectionStatus.connected => ('Connected', Colors.green),
      WsConnectionStatus.connecting => ('Connecting…', Colors.orange),
      WsConnectionStatus.disconnected => ('Disconnected', Colors.grey),
      WsConnectionStatus.error => ('Error', Colors.red),
      WsConnectionStatus.idle => ('Idle', Colors.grey),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: color),
          kHSpacer8,
          Text(label, style: TextStyle(color: color, fontSize: 12)),
          const Spacer(),
          if (status == WsConnectionStatus.connected)
            TextButton(
              onPressed: () =>
                  ref.read(wsStateProvider(selectedId).notifier).disconnect(),
              child: const Text('Disconnect',
                  style: TextStyle(fontSize: 12, color: Colors.red)),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Message bubble
// ---------------------------------------------------------------------------

class _WsMessageBubble extends StatelessWidget {
  const _WsMessageBubble({required this.message});
  final WsMessage message;

  @override
  Widget build(BuildContext context) {
    final bool isRight = message.isSent;
    final Color bubbleColor;
    final Color textColor;
    final String prefix;

    if (message.isStatus) {
      // Status messages span full width, centre-aligned.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: Text(
            message.content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      );
    }

    if (message.isError) {
      bubbleColor = Colors.red.shade50;
      textColor = Colors.red.shade800;
      prefix = '⚠ ';
    } else if (message.isSent) {
      bubbleColor = Theme.of(context).colorScheme.primary.withOpacity(0.15);
      textColor = Theme.of(context).colorScheme.onSurface;
      prefix = '';
    } else {
      bubbleColor =
          Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4);
      textColor = Theme.of(context).colorScheme.onSurface;
      prefix = '';
    }

    final timeStr =
        DateFormat('HH:mm:ss').format(message.timestamp.toLocal());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Card(
            color: bubbleColor,
            margin: EdgeInsets.zero,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: isRight
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    '$prefix${message.content}',
                    style: TextStyle(color: textColor),
                  ),
                  kVSpacer3,
                  Text(
                    '${isRight ? "You" : "Server"}  $timeStr',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor.withOpacity(0.6),
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
