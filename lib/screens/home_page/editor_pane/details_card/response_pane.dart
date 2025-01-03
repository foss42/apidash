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
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    final httpresponseModel = ref.watch(selectedRequestModelProvider
        .select((value) => 
        value?.httpResponseModel
        ));
    final graphqlresponseModel = ref.watch(selectedRequestModelProvider
        .select((value) => 
        value?.graphqlResponseModel
        ));
    final responseModel = apiType == APIType.rest ? httpresponseModel : graphqlresponseModel;
    return Column(
      children: [
        ResponsePaneHeader(
          responseStatus: responseStatus,
          message: message,
          time: apiType == APIType.rest ? httpresponseModel?.time : graphqlresponseModel?.time,
          onClearResponse: () {
            final selectedRequest = ref.read(selectedRequestModelProvider);
            ref
                .read(collectionStateNotifierProvider.notifier)
                .clearResponse(selectedRequest?.id);
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
    final apiType = ref.watch(selectedRequestModelProvider
            .select((value) => value?.apiType)) ??
        {};
    final httpRequestHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpResponseModel?.requestHeaders)) ??
        {};
    final httpResponseHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpResponseModel?.headers)) ??
        {};
    final graphqlRequestHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.graphqlResponseModel?.requestHeaders)) ??
        {};
    final graphqlResponseHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.graphqlResponseModel?.headers)) ??
        {};
    return ResponseHeaders(
      responseHeaders:apiType == APIType.rest ? httpResponseHeaders : graphqlResponseHeaders,
      requestHeaders: apiType == APIType.rest ? httpRequestHeaders : graphqlRequestHeaders,
    );
  }
}
