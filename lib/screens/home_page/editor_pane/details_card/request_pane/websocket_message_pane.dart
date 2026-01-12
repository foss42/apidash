import 'package:apidash/consts.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebSocketSendPane extends ConsumerStatefulWidget {
  const WebSocketSendPane({super.key});

  @override
  ConsumerState<WebSocketSendPane> createState() => _WebSocketSendPaneState();
}

class _WebSocketSendPaneState extends ConsumerState<WebSocketSendPane> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conn = ref.watch(
      selectedRequestModelProvider.select(
        (m) => m?.websocketConnectionModel,
      ),
    );

    final isConnected = conn?.isConnected == true;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              controller: _controller,
              enabled: isConnected,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: isConnected
                    ? kHintEnterWSMessage
                    : kHintConnectWSToSendMessage,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: isConnected
                ? () async {
                    final text = _controller.text.trim();
                    final success = await ref
                        .read(collectionStateNotifierProvider.notifier)
                        .sendWebSocketMessage(text);

                    if (success) {
                      _controller.clear();
                    }
                  }
                : null,
            icon: const Icon(Icons.send),
            label: const Text("Send"),
          ),
        ],
      ),
    );
  }
}
