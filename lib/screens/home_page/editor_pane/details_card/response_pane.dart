import 'dart:convert';

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
    final selectedId = ref.watch(selectedIdStateProvider)!;
    final isWorking = ref.watch(
            selectedRequestModelProvider.select((value) => value?.isWorking)) ??
        false;
    final startSendingTime = ref.watch(
        selectedRequestModelProvider.select((value) => value?.sendingTime));
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));
    final sseFramesNotifier =  ref.watch(sseFramesProvider.select((state) => state[selectedId] ?? []));

    
    if (isWorking && sseFramesNotifier.isEmpty) {
      print("inside sending widget"+sseFramesNotifier.isEmpty.toString());
      return SendingWidget(
        startSendingTime: startSendingTime,
      );

    }

    if (responseStatus == null && sseFramesNotifier.isEmpty) {
      return const NotSentWidget();
    }
    if (responseStatus == -1 && sseFramesNotifier.isEmpty) {
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
    final selectedId = ref.watch(selectedIdStateProvider)!;
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));

    return ResponseTabView(
      selectedId: selectedId,
      children: [
        if (apiType == APIType.rest || apiType == APIType.graphql) ...const[
           ResponseBodyTab(),
           ResponseHeadersTab(),
        ]else ...[
          SSEView(requestId: selectedId),
          const ResponseHeadersTab(),
        ]
      
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
   
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    switch (apiType!) {
     
      case APIType.rest:
        return ResponseHeaders(
          responseHeaders: responseHttpHeaders,
          requestHeaders: requestHttpHeaders,
        );
      case _:
        return ResponseHeaders(
          responseHeaders: responseHttpHeaders,
          requestHeaders: requestHttpHeaders,
        );
    }
      
  }
}



class SSEView extends ConsumerStatefulWidget {
  final String requestId;
  const SSEView({super.key, required this.requestId});

  @override
  ConsumerState<SSEView> createState() => _SSEViewState();
}

class _SSEViewState extends ConsumerState<SSEView> {
  final ScrollController _controller = ScrollController();
  bool _isAtBottom = true;
  List<SSEEventModel> _pausedFrames = [];

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.hasClients) {
        final isAtBottom = _controller.position.pixels >= _controller.position.maxScrollExtent;
        setState(() {
          _isAtBottom = isAtBottom;
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
    final frames = ref.watch(sseFramesProvider.select((state) => state[widget.requestId] ?? []));

    if (_isAtBottom) {
      _pausedFrames = List.from(frames);
    }
    final displayFrames = _isAtBottom ? frames : _pausedFrames;

    return Scaffold(
      appBar: AppBar(title: Text("SSE Stream - ${widget.requestId}")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: displayFrames.length,
              itemBuilder: (context, index) {
                final event = displayFrames[displayFrames.length - index - 1];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (event.event.isEmpty) _buildTag("Event", "message", Colors.blue),
                          _buildData(event.data),
                          if (event.id != null && event.id!.isNotEmpty) _buildTag("ID", event.id!, Colors.orange),
                          if (event.retry != null) _buildTag("Retry", "${event.retry} ms", Colors.purple),
                          if (event.customFields != null && event.customFields!.isNotEmpty)
                            ...event.customFields!.entries.map(
                              (e) => _buildTag(e.key, e.value, Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!_isAtBottom)
            ElevatedButton(
              onPressed: () {
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: const Text("Scroll to Bottom"),
            ),
        ],
      ),
    );
  }

  Widget _buildTag(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
            ],
          ),
        ),
        const Divider(height: 10, thickness: 0.5), // Add a subtle separator line
      ],
    );
  }

  Widget _buildData(String data) {
    bool _isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        try {
          final jsonData = json.decode(data);
          final formattedJson = const JsonEncoder.withIndent('  ').convert(jsonData);
          final bool shouldCollapse = formattedJson.length > 2;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Data", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                  const Spacer(),
                  if (shouldCollapse)
                    IconButton(
                      icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () => setState(() => _isExpanded = !_isExpanded),
                      iconSize: 18,
                    ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _isExpanded || !shouldCollapse ? formattedJson : "${formattedJson.substring(0, 100)}...",
                  style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
                ),
              ),
              const Divider(height: 10, thickness: 0.5),
            ],
          );
        } catch (_) {
          return _buildTag("Data", data, Colors.green);
        }
      },
    );
  }
}