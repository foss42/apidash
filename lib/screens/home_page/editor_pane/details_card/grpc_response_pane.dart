import 'dart:convert';

import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/message_log_view.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';

/// Professional gRPC response pane using the shared message-log view.
///
/// Each [GrpcCallResult] is flattened into one or more [LogMessage] entries:
///   - A status log entry (direction: status)
///   - Each response message (direction: received)
///   - Error entries when the call failed
///
/// Metadata (headers / trailers) is shown in a collapsible section above.
class GrpcResponsePane extends ConsumerStatefulWidget {
  const GrpcResponsePane({super.key});

  @override
  ConsumerState<GrpcResponsePane> createState() => _GrpcResponsePaneState();
}

class _GrpcResponsePaneState extends ConsumerState<GrpcResponsePane> {
  DateTime? _connectedSince;
  bool _showMetadata = false;

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) {
      return const Center(child: Text('No request selected'));
    }

    final connectionInfo = ref.watch(grpcConnectionProvider(selectedId));
    final results = ref.watch(grpcResponseProvider(selectedId));

    // Track connection start time
    if (connectionInfo.state == GrpcConnectionState.connected &&
        _connectedSince == null) {
      _connectedSince = DateTime.now();
    } else if (connectionInfo.state == GrpcConnectionState.disconnected ||
        connectionInfo.state == GrpcConnectionState.error) {
      _connectedSince = null;
    }

    // Flatten GrpcCallResult list → LogMessage list
    final logMessages = <LogMessage>[];
    for (final result in results) {
      final isSuccess = result.statusCode == 0;
      final statusLabel = isSuccess ? 'OK' : 'Error ${result.statusCode}';
      final durationStr = result.duration != null
          ? ' (${result.duration!.inMilliseconds}ms)'
          : '';

      // Status entry for each call
      logMessages.add(LogMessage(
        content:
            '$statusLabel$durationStr${result.statusMessage != null && result.statusMessage!.isNotEmpty ? " – ${result.statusMessage}" : ""}',
        direction: result.isError
            ? MessageDirection.error
            : MessageDirection.status,
        timestamp: DateTime.now(),
        label: statusLabel,
      ));

      // Response messages
      for (final msgBytes in result.responseMessages) {
        String displayText;
        try {
          displayText = utf8.decode(msgBytes);
        } catch (_) {
          displayText = msgBytes
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join(' ');
        }
        logMessages.add(LogMessage(
          content: displayText,
          direction: MessageDirection.received,
          timestamp: DateTime.now(),
        ));
      }

      // Error entry
      if (result.error != null) {
        logMessages.add(LogMessage(
          content: result.error!,
          direction: MessageDirection.error,
          timestamp: DateTime.now(),
        ));
      }
    }

    final (statusLabel, statusColor) = switch (connectionInfo.state) {
      GrpcConnectionState.connected => ('Connected', Colors.green),
      GrpcConnectionState.connecting => ('Connecting…', Colors.orange),
      GrpcConnectionState.error => ('Error', Colors.red),
      GrpcConnectionState.disconnected => ('Disconnected', Colors.grey),
    };

    final totalMessages =
        results.fold<int>(0, (sum, r) => sum + r.responseMessages.length);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyL, meta: true): () =>
            ref.read(grpcResponseProvider(selectedId).notifier).clear(),
        const SingleActivator(LogicalKeyboardKey.keyL, control: true): () =>
            ref.read(grpcResponseProvider(selectedId).notifier).clear(),
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
              sentCount: results.length,
              receivedCount: totalMessages,
              totalBytes: logMessages
                  .where((m) => m.isReceived)
                  .fold<int>(0, (sum, m) => sum + m.sizeBytes),
              extraInfo: connectionInfo.services.isNotEmpty
                  ? '${connectionInfo.services.length} service${connectionInfo.services.length != 1 ? "s" : ""}'
                  : null,
            ),
            // ── Metadata toggle ──
            if (results.isNotEmpty &&
                (results.last.responseHeaders.isNotEmpty ||
                    results.last.responseTrailers.isNotEmpty))
              _GrpcMetadataToggle(
                isExpanded: _showMetadata,
                onToggle: () =>
                    setState(() => _showMetadata = !_showMetadata),
                headers: results.last.responseHeaders,
                trailers: results.last.responseTrailers,
              ),
            // ── Message log or empty state ──
            Expanded(
              child: connectionInfo.state ==
                          GrpcConnectionState.disconnected &&
                      results.isEmpty
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
                            kLabelGrpcNotConnected,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant),
                          ),
                          kVSpacer5,
                          Text(
                            kMsgGrpcConnectFirst,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant),
                          ),
                        ],
                      ),
                    )
                  : connectionInfo.state == GrpcConnectionState.error &&
                          results.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline,
                                    size: 48,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error),
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
                                if (connectionInfo.errorMessage !=
                                    null) ...[
                                  kVSpacer5,
                                  SelectableText(
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
                      : results.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_outlined,
                                      size: 48,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant),
                                  kVSpacer10,
                                  Text(
                                    'Select a method and click Invoke',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
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
                                  .read(grpcResponseProvider(selectedId)
                                      .notifier)
                                  .clear(),
                              onExport: () =>
                                  _exportMessages(context, logMessages),
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

/// Collapsible metadata section for gRPC response headers / trailers.
class _GrpcMetadataToggle extends StatelessWidget {
  const _GrpcMetadataToggle({
    required this.isExpanded,
    required this.onToggle,
    required this.headers,
    required this.trailers,
  });

  final bool isExpanded;
  final VoidCallback onToggle;
  final Map<String, String> headers;
  final Map<String, String> trailers;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: cs.surfaceContainerHighest)),
            ),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 14,
                  color: cs.outline,
                ),
                kHSpacer4,
                Text(
                  'Metadata',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.outline),
                ),
                kHSpacer8,
                Text(
                  '${headers.length + trailers.length} entries',
                  style: TextStyle(fontSize: 12, color: cs.outline),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              border: Border(
                  bottom: BorderSide(color: cs.surfaceContainerHighest)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (headers.isNotEmpty) ...[
                  Text('Response Headers',
                      style: Theme.of(context).textTheme.labelSmall),
                  kVSpacer3,
                  ...headers.entries.map((e) => _MetadataRow(
                      keyText: e.key, valueText: e.value)),
                ],
                if (trailers.isNotEmpty) ...[
                  kVSpacer5,
                  Text('Trailers',
                      style: Theme.of(context).textTheme.labelSmall),
                  kVSpacer3,
                  ...trailers.entries.map((e) => _MetadataRow(
                      keyText: e.key, valueText: e.value)),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.keyText, required this.valueText});
  final String keyText;
  final String valueText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: kPv2,
      child: Row(
        children: [
          Text(
            '$keyText: ',
            style: kCodeStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: cs.outline),
          ),
          Expanded(
            child: Text(
              valueText,
              style: kCodeStyle.copyWith(fontSize: 12, color: cs.outline),
            ),
          ),
        ],
      ),
    );
  }
}
