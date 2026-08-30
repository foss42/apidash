import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';

/// Connection settings tab. Stateless; watches only the specific
/// `wsRequestModel` fields it displays, and reads the latest model
/// inside callbacks when writing updates.
class WsConnectionSettings extends ConsumerWidget {
  const WsConnectionSettings({super.key});

  void _updateWsModel(
    WidgetRef ref,
    WebSocketRequestModel Function(WebSocketRequestModel) updater,
  ) {
    final wsModel = ref.read(selectedRequestModelProvider)?.wsRequestModel;
    if (wsModel == null) return;
    ref
        .read(activeCollectionProvider.notifier)
        .update(wsRequestModel: updater(wsModel));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoReconnect = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.autoReconnect)) ??
        false;
    final enableHeartbeat = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.enableHeartbeat)) ??
        false;
    final heartbeatInterval = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.heartbeatInterval)) ??
        30;
    final enableMessageHeartbeat = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.enableMessageHeartbeat)) ??
        false;
    final messageHeartbeatInterval = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.messageHeartbeatInterval)) ??
        30;
    final messageHeartbeatPayload = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.messageHeartbeatPayload)) ??
        "ping";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text("Auto Reconnect"),
            subtitle: const Text(
                "Automatically reconnect when the server closes the connection"),
            value: autoReconnect,
            onChanged: (val) {
              _updateWsModel(ref, (ws) => ws.copyWith(autoReconnect: val));
            },
          ),
          // ── Group A: Automatic ping ─────────────────
          SwitchListTile(
            title: const Text("Send automatic pings"),
            subtitle: const Text(
                "Low-level keep-alive most servers understand. You won't see these in the messages."),
            value: enableHeartbeat,
            onChanged: (val) {
              _updateWsModel(ref, (ws) => ws.copyWith(enableHeartbeat: val));
            },
          ),
          if (enableHeartbeat)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                initialValue: heartbeatInterval.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Ping every (seconds)",
                ),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null) {
                    _updateWsModel(
                        ref, (ws) => ws.copyWith(heartbeatInterval: parsed));
                  }
                },
              ),
            ),
          kVSpacer10,
          const Divider(),
          kVSpacer10,
          // ── Group B: Repeating message ──────────────
          SwitchListTile(
            title: const Text("Send a repeating message"),
            subtitle: const Text(
                "Send your own text/JSON on a schedule. Some servers need this instead of pings."),
            value: enableMessageHeartbeat,
            onChanged: (val) {
              _updateWsModel(
                  ref, (ws) => ws.copyWith(enableMessageHeartbeat: val));
            },
          ),
          if (enableMessageHeartbeat) ...[
            kVSpacer10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ADOutlinedTextField(
                initialValue: messageHeartbeatPayload,
                maxLines: 3,
                hintText: "ping",
                onChanged: (val) {
                  _updateWsModel(
                      ref, (ws) => ws.copyWith(messageHeartbeatPayload: val));
                },
              ),
            ),
            kVSpacer10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                initialValue: messageHeartbeatInterval.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Send every (seconds)",
                ),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null) {
                    _updateWsModel(ref,
                        (ws) => ws.copyWith(messageHeartbeatInterval: parsed));
                  }
                },
              ),
            ),
            kVSpacer10,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "These appear in the messages as Sent.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
