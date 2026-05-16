import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/protocols/websocket_model.dart';
import 'package:apidash/models/protocols/mqtt_model.dart';
import 'package:apidash/models/protocols/grpc_model.dart';
import 'event_stream_view.dart';

class ResponsePane extends ConsumerWidget {
  const ResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiType = ref.watch(
            selectedRequestModelProvider.select((value) => value?.apiType));
    final isWorking = ref.watch(
            selectedRequestModelProvider.select((value) => value?.isWorking)) ??
        false;
    final isStreaming = ref.watch(
            selectedRequestModelProvider.select((value) => value?.isStreaming)) ??
        false;
    final startSendingTime = ref.watch(
        selectedRequestModelProvider.select((value) => value?.sendingTime));
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));

    if (apiType == APIType.websocket ||
        apiType == APIType.mqtt ||
        apiType == APIType.grpc) {
      if (isWorking) {
        return SendingWidget(startSendingTime: startSendingTime);
      }
      
      final protocolModel = ref.watch(selectedRequestModelProvider.select((value) => value?.protocolModel));
      bool hasMessages = false;
      if (protocolModel is WebSocketRequestModel) {
        hasMessages = protocolModel.messageHistory.isNotEmpty;
      } else if (protocolModel is MQTTRequestModel) {
        hasMessages = protocolModel.messageHistory.isNotEmpty;
      } else if (protocolModel is GrpcRequestModel) {
        hasMessages = protocolModel.messageHistory.isNotEmpty;
      }

      if (isStreaming || hasMessages) {
        return const _WsResponsePanel();
      }
     
      return const NotSentWidget();
    }

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

class _WsResponsePanel extends ConsumerWidget {
  const _WsResponsePanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: "Response Body"),
              Tab(text: "Headers"),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                EventStreamView(),
                _WsNoHeadersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WsNoHeadersTab extends StatelessWidget {
  const _WsNoHeadersTab();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No response headers for WebSocket connection."),
    );
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
    return ResponseBody(
      selectedRequestModel: selectedRequestModel,
    );
  }
}

class ResponseHeadersTab extends ConsumerWidget {
  const ResponseHeadersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestHeaders =
        ref.watch(selectedRequestModelProvider.select((value) {
              return value?.httpResponseModel!.requestHeaders;
            })) ??
            {};

    final responseHeaders =
        ref.watch(selectedRequestModelProvider.select((value) {
              return value?.httpResponseModel!.headers;
            })) ??
            {};

    return ResponseHeaders(
      responseHeaders: responseHeaders,
      requestHeaders: requestHeaders,
    );
  }
}
