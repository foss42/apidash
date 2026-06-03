import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'realtime_event_stream_view.dart';
//TODO : A better way to handle the logic for showing different panes
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

    // ── WebSocket response: event-stream view ────────────────────────
    if (apiType == APIType.websocket) {
      if (isWorking) {
        return SendingWidget(startSendingTime: startSendingTime);
      }

      final wsModel = ref.watch(selectedRequestModelProvider
          .select((value) => value?.wsRequestModel));
      final hasMessages = (wsModel?.messageHistory.isNotEmpty) ?? false;

      if (isStreaming || hasMessages) {
        return const _WsResponsePanel();
      }

      return const NotSentWidget();
    }

    // ── HTTP / GraphQL / AI response ─────────────────────────────────
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

/// Two-tab panel showing the WS event log and any response headers.
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
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: "Response Body"),
              Tab(text: "Headers"),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                RealtimeEventStreamView(),
                Center(
                  child: Text(
                    "WebSocket headers are only available at handshake time.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
