import 'dart:convert';

import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/message_log_view.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Professional message-log response panel for WebSocket conversations.
///
/// Replaces the old chat-bubble UI with a compact, searchable, filterable
/// message timeline inspired by Postman's WebSocket interface.
class WsResponsePane extends ConsumerStatefulWidget {
  const WsResponsePane({super.key});

  @override
  ConsumerState<WsResponsePane> createState() => _WsResponsePaneState();
}

class _WsResponsePaneState extends ConsumerState<WsResponsePane> {
  DateTime? _connectedSince;

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) {
      return const Center(child: Text('No request selected'));
    }

    final wsState = ref.watch(wsStateProvider(selectedId));
    final messages = wsState.messages;

    // Track connection start time
    if (wsState.isConnected && _connectedSince == null) {
      _connectedSince = DateTime.now();
    } else if (!wsState.isConnected && !wsState.isConnecting) {
      _connectedSince = null;
    }

    // Convert WsMessage → LogMessage
    final logMessages = messages.map((m) => LogMessage(
          content: m.content,
          direction: switch (m.type) {
            WsMessageType.sent => MessageDirection.sent,
            WsMessageType.received => MessageDirection.received,
            WsMessageType.error => MessageDirection.error,
            _ => MessageDirection.status,
          },
          timestamp: m.timestamp,
        )).toList();

    final (statusLabel, statusColor) = switch (wsState.status) {
      WsConnectionStatus.connected => ('Connected', Colors.green),
      WsConnectionStatus.connecting => ('Connecting…', Colors.orange),
      WsConnectionStatus.disconnected => ('Disconnected', Colors.grey),
      WsConnectionStatus.error => ('Error', Colors.red),
      WsConnectionStatus.idle => ('Idle', Colors.grey),
    };

    // Compute stats
    final sentCount = messages.where((m) => m.isSent).length;
    final recvCount = messages.where((m) => m.isReceived).length;
    int totalBytes = 0;
    for (final m in messages) {
      if (!m.isStatus) totalBytes += utf8.encode(m.content).length;
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyL, meta: true): () =>
            ref.read(wsStateProvider(selectedId).notifier).clearMessages(),
        const SingleActivator(LogicalKeyboardKey.keyL, control: true): () =>
            ref.read(wsStateProvider(selectedId).notifier).clearMessages(),
      },
      child: Focus(
        autofocus: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Connection stats bar ──
            ConnectionStatsBar(
              statusLabel: statusLabel,
              statusColor: statusColor,
              connectedSince: _connectedSince,
              sentCount: sentCount,
              receivedCount: recvCount,
              totalBytes: totalBytes,
            ),
            // ── Message log or empty state ──
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cable_outlined,
                              size: 48,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant),
                          kVSpacer10,
                          Text(
                            wsState.status == WsConnectionStatus.idle
                                ? 'Not connected yet.\nEnter a ws:// URL and press Connect.'
                                : wsState.isConnecting
                                    ? 'Connecting…'
                                    : 'No messages yet.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant),
                          ),
                        ],
                      ),
                    )
                  : MessageLogView(
                      messages: logMessages,
                      onClear: () => ref
                          .read(wsStateProvider(selectedId).notifier)
                          .clearMessages(),
                      onExport: () => _exportMessages(context, logMessages),
                      onResend: (msg) {
                        ref
                            .read(wsStateProvider(selectedId).notifier)
                            .updateMessageInput(msg.content);
                        ref.read(wsStateProvider(selectedId).notifier).send();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportMessages(BuildContext context, List<LogMessage> messages) {
    final json = MessageExporter.toJson(messages);
    Clipboard.setData(ClipboardData(text: json));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Messages exported to clipboard as JSON'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
