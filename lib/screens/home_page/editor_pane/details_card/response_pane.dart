import 'package:apidash/models/ws_request_model.dart';
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

      // Watch only this boolean so URL keystrokes (which replace
      // wsRequestModel) don't rebuild the pane.
      final hasMessages = ref.watch(selectedRequestModelProvider.select(
              (value) =>
                  value?.wsRequestModel?.messageHistory.isNotEmpty)) ??
          false;

      if (isStreaming || hasMessages) {
        return const _WsResponsePanel();
      }
      return const NotSentWidget();
    }

    // ── gRPC response: stream view if multiple ───────────────────────
    if (apiType == APIType.grpc) {
      // While the request is in flight (connecting / awaiting the first
      // response) show the same "sending" animation HTTP uses — for every
      // streaming type. `isWorking` is cleared on the first received message
      // (see _connectGrpc), at which point we fall through to the stream view
      // (streaming) or the single-response view (unary).
      if (isWorking) {
        return SendingWidget(
          startSendingTime: startSendingTime,
        );
      }
      final grpcModel = ref.watch(selectedRequestModelProvider.select((value) => value?.grpcRequestModel));
      final receivedCount = grpcModel?.messageHistory.where((m) => m.messageType == WebSocketMessageType.received).length ?? 0;
      final httpModel = ref.watch(selectedRequestModelProvider.select((value) => value?.httpResponseModel));
      final hasClearedStream = responseStatus == 200 && receivedCount == 0 && httpModel == null;
      if (isStreaming || receivedCount > 1 || hasClearedStream) {
        return const _WsResponsePanel();
      }
    }

    // ── HTTP / GraphQL / AI / gRPC (single) response ─────────────────
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

/// Panel showing the WS event log.
class _WsResponsePanel extends ConsumerStatefulWidget {
  const _WsResponsePanel();

  @override
  ConsumerState<_WsResponsePanel> createState() => _WsResponsePanelState();
}

class _WsResponsePanelState extends ConsumerState<_WsResponsePanel> {
  bool _showMetadata = false;

  @override
  Widget build(BuildContext context) {
    // Keyed by request id (stable across URL edits) so each request keeps its
    // own event-stream State; mirrors ResponseTabView on the HTTP side.
    final selectedId = ref.watch(selectedIdStateProvider);
    if (_showMetadata) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _showMetadata = false),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text("Back to Stream"),
              ),
            ),
          ),
          const Expanded(child: ResponseHeadersTab()),
        ],
      );
    }

    return RealtimeEventStreamView(
      key: ValueKey(selectedId),
      onViewMetadata: () => setState(() => _showMetadata = true),
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
    final apiType = ref.watch(selectedRequestModelProvider.select((value) => value?.apiType));

    return ResponseTabView(
      selectedId: selectedId,
      headersTitle: apiType == APIType.grpc ? "Metadata" : kLabelHeaders,
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
              return value?.httpResponseModel?.requestHeaders;
            })) ??
            {};

    final responseHeaders =
        ref.watch(selectedRequestModelProvider.select((value) {
              return value?.httpResponseModel?.headers;
            })) ??
            {};

    return ResponseHeaders(
      responseHeaders: responseHeaders,
      requestHeaders: requestHeaders,
    );
  }
}
