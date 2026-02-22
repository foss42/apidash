import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';

class MqttResponsePane extends ConsumerWidget {
  const MqttResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final connectionInfo = ref.watch(mqttConnectionProvider(selectedId));
    final messages = ref.watch(mqttMessagesProvider(selectedId));

    return Column(
      children: [
        // Connection status header
        MqttConnectionStatusHeader(
          connectionInfo: connectionInfo,
          onClear: () {
            ref.read(mqttMessagesProvider(selectedId).notifier).clear();
          },
        ),
        // Message feed
        Expanded(
          child: connectionInfo.state == MqttConnectionState.disconnected &&
                  messages.isEmpty
              ? const MqttNotConnectedWidget()
              : connectionInfo.state == MqttConnectionState.error
                  ? MqttErrorWidget(
                      errorMessage: connectionInfo.errorMessage)
                  : MqttMessageFeed(messages: messages),
        ),
      ],
    );
  }
}

class MqttConnectionStatusHeader extends StatelessWidget {
  const MqttConnectionStatusHeader({
    super.key,
    required this.connectionInfo,
    this.onClear,
  });

  final MqttConnectionInfo connectionInfo;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (connectionInfo.state) {
      MqttConnectionState.connected => Colors.green,
      MqttConnectionState.connecting => Colors.orange,
      MqttConnectionState.error => Colors.red,
      MqttConnectionState.disconnected => Colors.grey,
    };

    final statusText = switch (connectionInfo.state) {
      MqttConnectionState.connected => kLabelMqttConnected,
      MqttConnectionState.connecting => kLabelMqttConnecting,
      MqttConnectionState.error => "Error",
      MqttConnectionState.disconnected => kLabelMqttDisconnected,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
          kHSpacer8,
          Text(
            statusText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            tooltip: kTooltipClearResponse,
            onPressed: onClear,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class MqttNotConnectedWidget extends StatelessWidget {
  const MqttNotConnectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          kVSpacer10,
          Text(
            kLabelMqttNotConnected,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
          ),
          kVSpacer5,
          Text(
            "Enter a broker host and click Connect",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class MqttErrorWidget extends StatelessWidget {
  const MqttErrorWidget({super.key, this.errorMessage});
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            kVSpacer10,
            Text(
              "Connection Error",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            if (errorMessage != null) ...[
              kVSpacer5,
              Text(
                errorMessage!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MqttMessageFeed extends StatelessWidget {
  const MqttMessageFeed({super.key, required this.messages});
  final List<MqttMessageModel> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          "No messages yet",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
        ),
      );
    }

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[messages.length - 1 - index];
        return MqttMessageBubble(message: msg);
      },
    );
  }
}

class MqttMessageBubble extends StatelessWidget {
  const MqttMessageBubble({super.key, required this.message});
  final MqttMessageModel message;

  @override
  Widget build(BuildContext context) {
    final isPublished = message.isPublished;
    final brightness = Theme.of(context).brightness;
    final bubbleColor = isPublished
        ? (brightness == Brightness.dark
            ? Colors.teal.shade900
            : Colors.teal.shade50)
        : (brightness == Brightness.dark
            ? Colors.blueGrey.shade900
            : Colors.blueGrey.shade50);
    final labelColor = isPublished
        ? getAPIColor(APIType.mqtt, brightness: brightness)
        : Colors.blueGrey;

    return Align(
      alignment: isPublished ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: labelColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.topic,
                  style: kCodeStyle.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                  ),
                ),
                kHSpacer8,
                Text(
                  isPublished
                      ? kLabelPublishedMessage
                      : kLabelSubscribedMessage,
                  style: TextStyle(
                    fontSize: 10,
                    color: labelColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SelectableText(
              message.payload,
              style: kCodeStyle.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}:${message.timestamp.second.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                kHSpacer5,
                Text(
                  message.qos.label,
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                if (message.retained) ...[
                  kHSpacer5,
                  Text(
                    "Retained",
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
