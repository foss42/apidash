import 'dart:convert';

import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/message_log_view.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Topic color palette for automatic color-coding per unique topic.
const _topicColorPalette = <Color>[
  Colors.teal,
  Colors.indigo,
  Colors.deepOrange,
  Colors.purple,
  Colors.cyan,
  Colors.amber,
  Colors.pink,
  Colors.green,
  Colors.blueGrey,
  Colors.brown,
];

/// Professional message-log response panel for MQTT conversations.
///
/// Replaces the old chat-bubble UI with a compact, searchable, filterable
/// message timeline with topic-based color-coding inspired by MQTTX.
class MqttResponsePane extends ConsumerStatefulWidget {
  const MqttResponsePane({super.key});

  @override
  ConsumerState<MqttResponsePane> createState() => _MqttResponsePaneState();
}

class _MqttResponsePaneState extends ConsumerState<MqttResponsePane> {
  DateTime? _connectedSince;

  /// Assign a stable colour to each unique topic.
  final Map<String, Color> _topicColors = {};

  Color _colorForTopic(String topic) {
    return _topicColors.putIfAbsent(
      topic,
      () => _topicColorPalette[_topicColors.length % _topicColorPalette.length],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) {
      return const Center(child: Text('No request selected'));
    }

    final connectionInfo = ref.watch(mqttConnectionProvider(selectedId));
    final messages = ref.watch(mqttMessagesProvider(selectedId));

    // Track connection start time
    if (connectionInfo.state == MqttConnectionState.connected &&
        _connectedSince == null) {
      _connectedSince = DateTime.now();
    } else if (connectionInfo.state == MqttConnectionState.disconnected ||
        connectionInfo.state == MqttConnectionState.error) {
      _connectedSince = null;
    }

    // Convert MqttMessageModel → LogMessage with topic colors
    final logMessages = messages.map((m) {
      final topicColor = _colorForTopic(m.topic);
      return LogMessage(
        content: m.payload,
        direction: m.isPublished
            ? MessageDirection.sent
            : MessageDirection.received,
        timestamp: m.timestamp,
        label: m.topic,
        badge: m.qos.label,
        retained: m.retained,
        topicColor: topicColor,
      );
    }).toList();

    final (statusLabel, statusColor) = switch (connectionInfo.state) {
      MqttConnectionState.connected => ('Connected', Colors.green),
      MqttConnectionState.connecting => ('Connecting…', Colors.orange),
      MqttConnectionState.error => ('Error', Colors.red),
      MqttConnectionState.disconnected => ('Disconnected', Colors.grey),
    };

    // Compute stats
    final pubCount = messages.where((m) => m.isPublished).length;
    final subCount = messages.length - pubCount;
    int totalBytes = 0;
    for (final m in messages) {
      totalBytes += utf8.encode(m.payload).length;
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyL, meta: true): () =>
            ref.read(mqttMessagesProvider(selectedId).notifier).clear(),
        const SingleActivator(LogicalKeyboardKey.keyL, control: true): () =>
            ref.read(mqttMessagesProvider(selectedId).notifier).clear(),
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
              sentCount: pubCount,
              receivedCount: subCount,
              totalBytes: totalBytes,
            ),
            // ── Message log or empty state ──
            Expanded(
              child: connectionInfo.state ==
                          MqttConnectionState.disconnected &&
                      messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_off_outlined,
                              size: 48,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant),
                          kVSpacer10,
                          Text(
                            'Not connected yet.\nEnter a broker host and press Connect.',
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
                  : connectionInfo.state == MqttConnectionState.error
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline,
                                    size: 48,
                                    color:
                                        Theme.of(context).colorScheme.error),
                                kVSpacer10,
                                Text(
                                  'Connection Error',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                ),
                                if (connectionInfo.errorMessage != null) ...[
                                  kVSpacer5,
                                  Text(
                                    connectionInfo.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      : MessageLogView(
                          messages: logMessages,
                          showTopicFilter: true,
                          onClear: () => ref
                              .read(
                                  mqttMessagesProvider(selectedId).notifier)
                              .clear(),
                          onExport: () =>
                              _exportMessages(context, logMessages),
                          onResend: (msg) {
                            // Re-publish by setting the topic and payload,
                            // then triggering publish via the collection notifier.
                            if (msg.label != null) {
                              ref
                                  .read(mqttPublishTopicProvider(selectedId)
                                      .notifier)
                                  .state = msg.label!;
                            }
                            ref
                                .read(mqttPublishPayloadProvider(selectedId)
                                    .notifier)
                                .state = msg.content;
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
        content: Text('Messages exported to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
