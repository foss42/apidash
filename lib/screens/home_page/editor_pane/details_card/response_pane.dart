import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class ResponsePane extends ConsumerStatefulWidget {
  const ResponsePane({super.key});

  @override
  ConsumerState<ResponsePane> createState() => _ResponsePaneState();
}

class _ResponsePaneState extends ConsumerState<ResponsePane> {
  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    final responseStatus = ref.watch(
        activeRequestModelProvider.select((value) => value?.responseStatus));
    final message =
        ref.watch(activeRequestModelProvider.select((value) => value?.message));
    if (sentRequestId != null && sentRequestId == activeId) {
      return const SendingWidget();
    }
    if (responseStatus == null) {
      return const NotSentWidget();
    }
    if (responseStatus == -1) {
      return ErrorMessage(message: '$message. $kUnexpectedRaiseIssue');
    }
    return const ResponseDetails();
  }
}

class ResponseDetails extends ConsumerStatefulWidget {
  const ResponseDetails({super.key});

  @override
  ConsumerState<ResponseDetails> createState() => _ResponseDetailsState();
}

class _ResponseDetailsState extends ConsumerState<ResponseDetails> {
  @override
  Widget build(BuildContext context) {
    final responseStatus = ref.watch(
        activeRequestModelProvider.select((value) => value?.responseStatus));
    final message =
        ref.watch(activeRequestModelProvider.select((value) => value?.message));
    final responseModel = ref.watch(
        activeRequestModelProvider.select((value) => value?.responseModel));
    return Column(
      children: [
        ResponsePaneHeader(
          responseStatus: responseStatus,
          message: message,
          time: responseModel?.time,
          bytes: responseModel?.bodyBytes?.length,
        ),
        const Expanded(
          child: ResponseTabs(),
        ),
      ],
    );
  }
}

class ResponseTabs extends ConsumerStatefulWidget {
  const ResponseTabs({super.key});

  @override
  ConsumerState<ResponseTabs> createState() => _ResponseTabsState();
}

class _ResponseTabsState extends ConsumerState<ResponseTabs> {
  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    return ResponseTabView(
      activeId: activeId,
      children: const [
        ResponseBodyTab(),
        ResponseHeadersTab(),
      ],
    );
  }
}

class ResponseBodyTab extends ConsumerStatefulWidget {
  const ResponseBodyTab({super.key});

  @override
  ConsumerState<ResponseBodyTab> createState() => _ResponseBodyTabState();
}

class _ResponseBodyTabState extends ConsumerState<ResponseBodyTab> {
  @override
  Widget build(BuildContext context) {
    final activeRequestModel = ref.watch(activeRequestModelProvider);
    return ResponseBody(
      activeRequestModel: activeRequestModel,
    );
  }
}

class ResponseHeadersTab extends ConsumerStatefulWidget {
  const ResponseHeadersTab({super.key});

  @override
  ConsumerState<ResponseHeadersTab> createState() => _ResponseHeadersTabState();
}

class _ResponseHeadersTabState extends ConsumerState<ResponseHeadersTab> {
  @override
  Widget build(BuildContext context) {
    final requestHeaders = ref.watch(activeRequestModelProvider
            .select((value) => value?.responseModel?.requestHeaders)) ??
        {};
    final responseHeaders = ref.watch(activeRequestModelProvider
            .select((value) => value?.responseModel?.headers)) ??
        {};
    return ResponseHeaders(
      responseHeaders: responseHeaders,
      requestHeaders: requestHeaders,
    );
  }
}
