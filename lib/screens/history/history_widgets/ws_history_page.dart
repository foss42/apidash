import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

/// Read-only view of the connection settings used by a WebSocket history entry.
///
/// Mirrors [HisAIRequestConfigSection] (see `ai_history_page.dart`): a read-only
/// `SingleChildScrollView > Column`, keyed by `historyId`, over the fields that
/// the live editor's `_WsConnectionSettings` tab exposes (see
/// `request_pane_ws.dart`). Every control here is disabled — switches use
/// `onChanged: null` and interval/message values are shown as read-only
/// `ListTile`s — so a past connection's settings can be inspected but not
/// changed.
///
/// The model is read DIRECTLY off `selectedHistoryRequestModelProvider`
/// (`wsRequestModel`), never via a request-model conversion.
class HisWebSocketConfigSection extends ConsumerWidget {
  const HisWebSocketConfigSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHistoryModel = ref.watch(
      selectedHistoryRequestModelProvider,
    )!;
    final wsReqM = selectedHistoryModel.wsRequestModel;
    if (wsReqM == null) {
      return kSizedBoxEmpty;
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        key: ValueKey(selectedHistoryModel.historyId),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Auto reconnect ──────────────────────────
          SwitchListTile(
            title: const Text("Auto Reconnect"),
            subtitle: const Text(
              "Automatically reconnect when the server closes the connection",
            ),
            value: wsReqM.autoReconnect,
            onChanged: null,
          ),
          // ── Group A: Automatic ping ─────────────────
          SwitchListTile(
            title: const Text("Send automatic pings"),
            subtitle: const Text(
              "Low-level keep-alive most servers understand. You won't see these in the messages.",
            ),
            value: wsReqM.enableHeartbeat,
            onChanged: null,
          ),
          if (wsReqM.enableHeartbeat)
            ListTile(
              title: const Text("Ping every (seconds)"),
              trailing: Text("${wsReqM.heartbeatInterval}"),
            ),
          kVSpacer10,
          const Divider(),
          kVSpacer10,
          // ── Group B: Repeating message ──────────────
          SwitchListTile(
            title: const Text("Send a repeating message"),
            subtitle: const Text(
              "Send your own text/JSON on a schedule. Some servers need this instead of pings.",
            ),
            value: wsReqM.enableMessageHeartbeat,
            onChanged: null,
          ),
          if (wsReqM.enableMessageHeartbeat) ...[
            ListTile(
              title: const Text("Message"),
              subtitle: Text(wsReqM.messageHeartbeatPayload, style: kCodeStyle),
            ),
            ListTile(
              title: const Text("Send every (seconds)"),
              trailing: Text("${wsReqM.messageHeartbeatInterval}"),
            ),
          ],
        ],
      ),
    );
  }
}
