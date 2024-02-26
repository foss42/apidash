import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/websocket_service.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResponsePane extends ConsumerWidget {
  const ResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));
    final requestModel = ref.watch(selectedRequestModelProvider);
    if (sentRequestId != null && sentRequestId == selectedId) {
      return const SendingWidget();
    }
    if (responseStatus == null &&
        requestModel?.protocol != Protocol.websocket) {
      return const NotSentWidget();
    }
    if (responseStatus == -1) {
      return ErrorMessage(message: '$message. $kUnexpectedRaiseIssue');
    }

    return const ResponseDetails();
  }
}

IconData _getIconForMessageType(WebSocketMessageType messageType) {
  switch (messageType) {
    case WebSocketMessageType.info:
      return Icons.info;
    case WebSocketMessageType.server:
      return Icons.arrow_downward;
    case WebSocketMessageType.client:
      return Icons.arrow_upward;
    case WebSocketMessageType.error:
      return Icons.error;
  }
}

Color _getColorForMessageType(WebSocketMessageType messageType) {
  switch (messageType) {
    case WebSocketMessageType.info:
      return Colors.blue;
    case WebSocketMessageType.server:
      return Colors.orange;
    case WebSocketMessageType.client:
      return Colors.lightGreen;
    case WebSocketMessageType.error:
      return Colors.red;
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
    final responseModel = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseModel));
    final requestModel = ref.watch(selectedRequestModelProvider);

    if (requestModel?.protocol == Protocol.websocket) {
      return Consumer(
        builder: (context, ref, child) {
          final requestModel = ref.watch(selectedRequestModelProvider);
          final messages = requestModel!.webSocketMessages;
          final collection = ref.read(collectionStateNotifierProvider.notifier);

          return Stack(
            children: [
              if (messages != null)
                ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        messages[index].message,
                        style: TextStyle(
                            color:
                                _getColorForMessageType(messages[index].type)),
                      ),
                      subtitle: Text(messages[index].timestamp.toString()),
                      leading: Icon(
                        _getIconForMessageType(messages[index].type),
                        color: _getColorForMessageType(messages[index].type),
                      ),
                    );
                  },
                ),
              Positioned(
                right: 0,
                child: DeleteMessagesButton(
                  onTap: collection.deleteWebSocketMessages,
                ),
              ),
            ],
          );
        },
      );
    }
    return Column(
      children: [
        ResponsePaneHeader(
          responseStatus: responseStatus,
          message: message,
          time: responseModel?.time,
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
    final requestHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.responseModel?.requestHeaders)) ??
        {};
    final responseHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.responseModel?.headers)) ??
        {};
    return ResponseHeaders(
      responseHeaders: responseHeaders,
      requestHeaders: requestHeaders,
    );
  }
}
