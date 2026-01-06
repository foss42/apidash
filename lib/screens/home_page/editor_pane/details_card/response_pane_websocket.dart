import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebSocketResponsePane extends ConsumerWidget {
  const WebSocketResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWorking = ref.watch(
            selectedRequestModelProvider.select((value) => value?.isWorking)) ??
        false;
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));

    // Connected if responseStatus is 101 (Switching Protocols)
    final isConnected = responseStatus == 101;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: kHeaderHeight,
            child: Row(
              children: [
                if (message != null && responseStatus == -1)
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Failed",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: kColorStatusCode400,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        kHSpacer10,
                        Tooltip(
                          message: message,
                          child: Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: kColorStatusCode400,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      isConnected
                          ? "Connected ($responseStatus)"
                          : (isWorking ? "Connecting..." : "Disconnected"),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isConnected
                                ? kColorStatusCode200
                                : (isWorking
                                    ? Colors.amber
                                    : kColorStatusCode400),
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                const Spacer(),
              ],
            ),
          ),
        ),
        const Divider(),
        const Expanded(
          child: WebSocketMessageList(),
        ),
        const Divider(),
        const WebSocketMessageInput(),
      ],
    );
  }
}

class WebSocketMessageList extends ConsumerWidget {
  const WebSocketMessageList({super.key, this.messages});

  final List<WebSocketMessageModel>? messages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = this.messages ??
        ref.watch(selectedRequestModelProvider
            .select((value) => value?.webSocketRequestModel?.messages));

    if (messages == null || messages.isEmpty) {
      return Center(
        child: Text(
          "No messages",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: messages.length,
      padding: kP10,
      itemBuilder: (context, index) {
        final message = messages[index];
        return WebSocketMessageItem(message: message);
      },
    );
  }
}

class WebSocketMessageItem extends StatelessWidget {
  const WebSocketMessageItem({
    super.key,
    required this.message,
  });

  final WebSocketMessageModel message;

  @override
  Widget build(BuildContext context) {
    final isSent = message.isSent;
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSent
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              message.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              message.time.toString().split('.').first,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebSocketMessageInput extends HookConsumerWidget {
  const WebSocketMessageInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final selectedId = ref.watch(selectedIdStateProvider);
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final isConnected = responseStatus == 101;

    return Padding(
      padding: kP10.copyWith(right: 70),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller, // Use the proper controller
              decoration: const InputDecoration(
                hintText: "Enter message...",
                border: OutlineInputBorder(),
              ),
              enabled: isConnected,
              onSubmitted: (value) {
                if (value.isNotEmpty && selectedId != null && isConnected) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .sendWebSocketMessage(selectedId, value);
                  controller.clear();
                }
              },
            ),
          ),
          kHSpacer10,
          IconButton.filled(
            onPressed: isConnected
                ? () {
                    final text = controller.text;
                    if (text.isNotEmpty && selectedId != null) {
                      ref
                          .read(collectionStateNotifierProvider.notifier)
                          .sendWebSocketMessage(selectedId, text);
                      controller.clear();
                    }
                  }
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
