import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class ResponsePane extends ConsumerWidget{
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
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    
    if (isWorking) {
      // if(apiType == APIType.webSocket ){
      //   return const SendingWidget(
      //     startSendingTime: null,
      //   );
      // }else{

      // }
     return const ResponseDetails();
      // return SendingWidget(
      //   startSendingTime: startSendingTime,
      // );
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
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    return ResponseTabView(
      selectedId: selectedId,
      children: [
        if (apiType == APIType.rest || apiType == APIType.webSocket) ...const [
          ResponseBodyTab(),
          ResponseHeadersTab(),
        ] else if (apiType == APIType.webSocket) ...const [
          WebsocketResponseView(),
          ResponseHeadersTab(),
        ],
      
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



class WebsocketResponseView extends ConsumerStatefulWidget {
  const WebsocketResponseView({super.key});

  @override
  ConsumerState<WebsocketResponseView> createState() => _WebsocketResponseViewState();
}

class _WebsocketResponseViewState extends ConsumerState<WebsocketResponseView> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge && _controller.position.pixels != 0) {
        setState(() {
          _controller.jumpTo(_controller.position.maxScrollExtent);
        });
      }else{
        setState(() {
          _controller.jumpTo(_controller.offset);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frames = ref.watch(selectedRequestModelProvider
            .select((value) => value?.webSocketResponseModel?.frames)) ??
        <WebSocketFrameModel>[];  

    return ListView.builder(
      controller: _controller,
      itemCount: frames.length,
      itemBuilder: (context, index) {
        return WebsocketFrame(
          websocketFrame: frames[frames.length-index-1],
          ref: ref,
        );
      },
    );
  }
}
