import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class ResponsePane extends ConsumerWidget {
  const ResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWorking =
        ref.watch(
          selectedRequestModelProvider.select((value) => value?.isWorking),
        ) ??
        false;
    final startSendingTime = ref.watch(
      selectedRequestModelProvider.select((value) => value?.sendingTime),
    );
    final responseStatus = ref.watch(
      selectedRequestModelProvider.select((value) => value?.responseStatus),
    );
    final message = ref.watch(
      selectedRequestModelProvider.select((value) => value?.message),
    );

    if (isWorking) {
      return SendingWidget(startSendingTime: startSendingTime);
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
          : ErrorMessage(message: '$message. $kUnexpectedRaiseIssue');
    }
    return const ResponseDetails();
  }
}

class ResponseDetails extends ConsumerWidget {
  const ResponseDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseStatus = ref.watch(
      selectedRequestModelProvider.select((value) => value?.responseStatus),
    );
    final message = ref.watch(
      selectedRequestModelProvider.select((value) => value?.message),
    );
    final responseModel = ref.watch(
      selectedRequestModelProvider.select((value) => value?.httpResponseModel),
    );

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
        const Expanded(child: ResponseTabs()),
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
        ResponseAssertionsTab(),
      ],
    );
  }
}

class ResponseBodyTab extends ConsumerWidget {
  const ResponseBodyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequestModel = ref.watch(selectedRequestModelProvider);
    return ResponseBody(selectedRequestModel: selectedRequestModel);
  }
}

class ResponseHeadersTab extends ConsumerWidget {
  const ResponseHeadersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestHeaders =
        ref.watch(
          selectedRequestModelProvider.select((value) {
            return value?.httpResponseModel!.requestHeaders;
          }),
        ) ??
        {};

    final responseHeaders =
        ref.watch(
          selectedRequestModelProvider.select((value) {
            return value?.httpResponseModel!.headers;
          }),
        ) ??
        {};

    return ResponseHeaders(
      responseHeaders: responseHeaders,
      requestHeaders: requestHeaders,
    );
  }
}

class ResponseAssertionsTab extends ConsumerWidget {
  const ResponseAssertionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final responseModel = ref.watch(
      selectedRequestModelProvider.select((v) => v?.httpResponseModel),
    );
    final requestUrl = ref.watch(
      selectedRequestModelProvider.select(
        (v) => v?.httpRequestModel?.url ?? '',
      ),
    );

    if (selectedId == null) return const SizedBox.shrink();

    return AssertionPanel(
      requestId: selectedId,
      httpResponseModel: responseModel,
      requestUrl: requestUrl,
    );
  }
}
