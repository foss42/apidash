import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../../../../services/mqtt_service.dart' show MQTTConnectionState, MQTTEventType;

class ResponsePane extends ConsumerWidget {
  const ResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWorking = ref.watch(
            selectedRequestModelProvider.select((value) => value?.isWorking)) ??
        false;
    final startSendingTime = ref.watch(
        selectedRequestModelProvider.select((value) => value?.sendingTime));
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));

    if (isWorking) {
      return SendingWidget(
        startSendingTime: startSendingTime,
      );
    }
    if (responseStatus == null) {
      return const NotSentWidget();
    }
    if (responseStatus == -1) {
      return message == kMsgRequestCancelled
          ? ErrorMessage(
              message: message,
              icon: Icons.cancel,
              showIssueButton: false,
            )
          : ErrorMessage(
              message: '$message. $kUnexpectedRaiseIssue',
            );
    }
    return const ResponseDetails();
  }
}

class ResponseDetails extends ConsumerWidget {
  const ResponseDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));
    final responseModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpResponseModel));

    return Column(
      children: [
        ResponsePaneHeader(
          responseStatus: responseStatus,
          message: message,
          time: responseModel?.time,
          onClearResponse: () {
            ref.read(collectionStateNotifierProvider.notifier).clearResponse();
          },
        ),
        const Expanded(
          child: ResponseTabs(),
        ),
      ],
    );
  }
}

class ResponseTabs extends ConsumerWidget {
  const ResponseTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    return ResponseTabView(
      selectedId: selectedId,
      children: const [
        ResponseBodyTab(),
        ResponseHeadersTab(),
      ],
    );
  }
}

class ResponseBodyTab extends ConsumerWidget {
  const ResponseBodyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequestModel = ref.watch(selectedRequestModelProvider);
    if (selectedRequestModel?.apiType == APIType.mqtt) {
      final mqttState = selectedRequestModel?.mqttConnectionState;
      if (mqttState == null) {
        return const Center(child: Text('No MQTT connection info.'));
      }
      // Show event log
      final eventLog = mqttState.eventLog;
      if (eventLog.isEmpty) {
        return const Center(child: Text('No MQTT events yet.'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: eventLog.length,
        itemBuilder: (context, index) {
          final event = eventLog[index];
          IconData icon;
          Color color;
          switch (event.type) {
            case MQTTEventType.connect:
              icon = Icons.link;
              color = Colors.green;
              break;
            case MQTTEventType.disconnect:
              icon = Icons.link_off;
              color = Colors.red;
              break;
            case MQTTEventType.subscribe:
              icon = Icons.subscriptions;
              color = Colors.blue;
              break;
            case MQTTEventType.unsubscribe:
              icon = Icons.unsubscribe;
              color = Colors.orange;
              break;
            case MQTTEventType.send:
              icon = Icons.arrow_upward;
              color = Colors.blue;
              break;
            case MQTTEventType.receive:
              icon = Icons.arrow_downward;
              color = Colors.green;
              break;
            case MQTTEventType.error:
              icon = Icons.error;
              color = Colors.red;
              break;
            default:
              icon = Icons.info;
              color = Colors.grey;
          }
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(icon, color: color),
              title: Row(
                children: [
                  if (event.topic != null && event.topic!.isNotEmpty)
                    Text(
                      event.topic!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (event.topic != null && event.topic!.isNotEmpty)
                    const SizedBox(width: 8),
                  if (event.type == MQTTEventType.send)
                    const Text('Sent'),
                  if (event.type == MQTTEventType.receive)
                    const Text('Received'),
                  if (event.type == MQTTEventType.connect)
                    const Text('Connected'),
                  if (event.type == MQTTEventType.disconnect)
                    const Text('Disconnected'),
                  if (event.type == MQTTEventType.subscribe)
                    const Text('Subscribed'),
                  if (event.type == MQTTEventType.unsubscribe)
                    const Text('Unsubscribed'),
                  if (event.type == MQTTEventType.error)
                    const Text('Error'),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.type == MQTTEventType.send || event.type == MQTTEventType.receive)
                    if (event.payload != null && event.payload!.isNotEmpty)
                      Text(event.payload!),
                  if (event.type != MQTTEventType.send && event.type != MQTTEventType.receive)
                    if (event.description != null && event.description!.isNotEmpty)
                      Text(event.description!, style: const TextStyle(color: Colors.grey)),
                  Text(
                    '${event.timestamp.hour.toString().padLeft(2, '0')}:${event.timestamp.minute.toString().padLeft(2, '0')}:${event.timestamp.second.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return ResponseBody(
      selectedRequestModel: selectedRequestModel,
    );
  }
}

class ResponseHeadersTab extends ConsumerWidget {
  const ResponseHeadersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpResponseModel?.requestHeaders)) ??
        {};
    final responseHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpResponseModel?.headers)) ??
        {};
    return ResponseHeaders(
      responseHeaders: responseHeaders,
      requestHeaders: requestHeaders,
    );
  }
}
