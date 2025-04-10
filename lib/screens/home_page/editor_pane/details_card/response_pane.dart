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
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));

    return ResponseTabView(
      selectedId: selectedId,
      children: [
        if (apiType == APIType.rest || apiType == APIType.graphql) ...const [
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
    final requestHttpHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpResponseModel?.requestHeaders)) ??
        {};
    final responseHttpHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpResponseModel?.headers)) ??
        {};
    final requestWebSocketHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.webSocketResponseModel?.requestHeaders)) ??
        {};
    final responseWebSocketHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.webSocketResponseModel?.headers)) ??
        {};
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    switch (apiType!) {
      case APIType.rest || APIType.graphql:
        return ResponseHeaders(
          responseHeaders: responseHttpHeaders,
          requestHeaders: requestHttpHeaders,
        );
      case APIType.webSocket:
        return ResponseHeaders(
          responseHeaders: responseWebSocketHeaders,
          requestHeaders: requestWebSocketHeaders,
        );
    }
      
  }
}



class WebsocketResponseView extends ConsumerStatefulWidget {
  const WebsocketResponseView({super.key});

  @override
  ConsumerState<WebsocketResponseView> createState() => _WebsocketResponseViewState();
}

class _WebsocketResponseViewState extends ConsumerState<WebsocketResponseView> {
  final ScrollController _controller = ScrollController();
  bool _isAtTop = true;
  List<WebSocketFrameModel> _pausedFrames = [];

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.minScrollExtent,
          duration: const Duration(milliseconds: 500), // Adjust for speed
          curve: Curves.easeOut, // Smooth effect
        );
      }
    });
    _controller.addListener(() {
      if (_controller.hasClients) {
      setState(() {
        _isAtTop = _controller.position.atEdge == true;
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

     if (_isAtTop) {
      _pausedFrames = List.from(frames);
    }

    final displayFrames = _isAtTop ? frames : _pausedFrames;
    return ListView.builder(
      controller: _controller,
      itemCount: displayFrames.length,
      itemBuilder: (context, index) {
        return WebsocketFrame(
          websocketFrame: displayFrames[displayFrames.length-index-1],
          ref: ref,
        );
      },
    );
  }
}
