import 'package:apidash/consts.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/widget_sending.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WebSocketMessagesPane extends ConsumerWidget {
  const WebSocketMessagesPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(
      selectedRequestModelProvider.select(
        (m) => m?.websocketConnectionModel?.messages ?? const [],
      ),
    );
    final isWorking = ref.watch(
            selectedRequestModelProvider.select((value) => value?.isWorking)) ??
        false;
    final startSendingTime = ref.watch(
        selectedRequestModelProvider.select((value) => value?.sendingTime));

    if (isWorking) {
      return SendingWidget(
        startSendingTime: startSendingTime,
      );
    }

    if (messages.isEmpty) {
      return const Center(
        child: Text(kMsgNoWSActiviy),
      );
    }

    return ListView.builder(
      reverse: true,
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final reversedIndex = messages.length - 1 - index;
        return WebSocketMessageTile(message: messages[reversedIndex]);
      },
    );
  }
}

class WebSocketMessageTile extends StatelessWidget {
  final WebSocketMessageModel message;
  const WebSocketMessageTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final color = switch (message.type) {
      WebSocketMessageType.connect => Colors.green,
      WebSocketMessageType.sent => Colors.blue,
      WebSocketMessageType.received => Colors.orange,
      WebSocketMessageType.error => Colors.red,
      WebSocketMessageType.disconnect => Colors.grey,
      WebSocketMessageType.info => Colors.amber
    };

    String formatTimestamp(DateTime? ts) {
      return ts == null ? "" : DateFormat('yyyy-MM-dd HH:mm:ss').format(ts);
    }

    final label = message.type.name.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label • ${formatTimestamp(message.timestamp)}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          if (message.payload?.isNotEmpty == true)
            SelectableText(
              message.payload!,
              style: const TextStyle(fontSize: 13),
            ),
          if (message.message?.isNotEmpty == true)
            SelectableText(
              message.message!,
              style: const TextStyle(fontSize: 13),
            ),
        ],
      ),
    );
  }
}
