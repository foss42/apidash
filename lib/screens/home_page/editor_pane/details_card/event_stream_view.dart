import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/protocols/websocket_model.dart';
import 'package:apidash/models/protocols/mqtt_model.dart';
import 'package:apidash/models/protocols/grpc_model.dart';

/// A log-style event stream view 
class EventStreamView extends ConsumerWidget {
  const EventStreamView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestModel = ref.watch(selectedRequestModelProvider);
    final apiType = requestModel?.apiType;

    if (apiType == APIType.websocket) {
      final protocolModel = requestModel?.protocolModel;
      final wsModel = protocolModel is WebSocketRequestModel ? protocolModel : null;
      final history = wsModel?.messageHistory ?? [];

      return Column(
        children: [
          // Header bar: connection status + clear button
          _StreamStatusBar(
            title: "Connected to WebSocket server",
            hasMessages: history.isNotEmpty,
            onClear: () {
              if (wsModel != null) {
                ref.read(collectionStateNotifierProvider.notifier).update(
                      protocolModel: wsModel.copyWith(messageHistory: []),
                    );
              }
            },
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
                : _buildLogView(context, history),
          ),
        ],
      );
    }

    if (apiType == APIType.mqtt) {
      final protocolModel = requestModel?.protocolModel;
      final mqttModel = protocolModel is MQTTRequestModel ? protocolModel : null;
      final history = mqttModel?.messageHistory ?? [];

      return Column(
        children: [
          _StreamStatusBar(
            title: "Connected to MQTT Broker",
            hasMessages: history.isNotEmpty,
            onClear: () {
              if (mqttModel != null) {
                ref.read(collectionStateNotifierProvider.notifier).update(
                      protocolModel: mqttModel.copyWith(messageHistory: []),
                    );
              }
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: history.isEmpty
                ? const Center(
                    child: Text(
                      "No messages yet. Connect to start.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : _buildLogView(context, history),
          ),
        ],
      );
    }

    if (apiType == APIType.grpc) {
      final protocolModel = requestModel?.protocolModel;
      final grpcModel = protocolModel is GrpcRequestModel ? protocolModel : null;
      final history = grpcModel?.messageHistory ?? [];

      return Column(
        children: [
          _StreamStatusBar(
            title: "gRPC Invocation Status",
            hasMessages: history.isNotEmpty,
            onClear: () {
              if (grpcModel != null) {
                ref.read(collectionStateNotifierProvider.notifier).update(
                      protocolModel: grpcModel.copyWith(messageHistory: []),
                    );
              }
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: history.isEmpty
                ? const Center(
                    child: Text(
                      "No call made yet.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : _buildLogView(context, history),
          ),
        ],
      );
    }

    return kSizedBoxEmpty;
  }

  Widget _buildLogView(BuildContext context, List<WebSocketMessage> history) {
    return ListView.builder(
      itemCount: history.length,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemBuilder: (context, index) {
        final msg = history[index];
        return _WsLogEntry(msg: msg);
      },
    );
  }
}

class _StreamStatusBar extends StatelessWidget {
  const _StreamStatusBar({
    required this.title,
    required this.hasMessages,
    required this.onClear,
  });
  final String title;
  final bool hasMessages;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.green.shade400),
          kHSpacer5,
          Text(
            title,
            style: kCodeStyle.copyWith(
              fontSize: 13,
              color: Colors.green.shade400,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (hasMessages)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              tooltip: "Clear messages",
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}

class _WsLogEntry extends StatelessWidget {
  const _WsLogEntry({required this.msg});
  final WebSocketMessage msg;

  @override
  Widget build(BuildContext context) {
    final time = msg.timestamp != null
        ? "${msg.timestamp!.hour.toString().padLeft(2, '0')}:"
          "${msg.timestamp!.minute.toString().padLeft(2, '0')}:"
          "${msg.timestamp!.second.toString().padLeft(2, '0')}"
        : "";

    final (Color labelColor, String labelText, IconData dirIcon) =
        switch (msg.messageType) {
      WebSocketMessageType.connected => (Colors.teal.shade400, "Connected", Icons.link),
      WebSocketMessageType.sent     => (Colors.blue.shade400,  "Sent",      Icons.arrow_upward),
      WebSocketMessageType.received => (Colors.green.shade400, "Received",  Icons.arrow_downward),
      WebSocketMessageType.error    => (Colors.red.shade400,   "Error",     Icons.error_outline),
    };

    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: msg.payload));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Copied to clipboard"), duration: Duration(milliseconds: 600)),
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
                style: kCodeStyle.copyWith(fontSize: 12, color: Colors.grey),
              ),
              TextSpan(
                text: "[$labelText] - ",
                style: kCodeStyle.copyWith(
                  fontSize: 12,
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: msg.payload,
                style: kCodeStyle.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
