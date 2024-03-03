import 'package:apidash/providers/collection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class MQTTResponsePane extends ConsumerWidget {
  const MQTTResponsePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    final connectionState = ref.watch(realtimeConnectionStateProvider);
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));
    print(
        "Current connection State: $connectionState\nCurrent sentRequestID: $sentRequestId");
    if (connectionState == RealtimeConnectionState.connecting ||
        connectionState == RealtimeConnectionState.disconnecting) {
      return const SendingWidget();
    }
    if (sentRequestId == null) {
      return const NotSentWidget();
    }

    return const MQTTResponseDetails();
  }
}

class MQTTResponseDetails extends ConsumerWidget {
  const MQTTResponseDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));
    final responseModel = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseModel));
    return Column(
      children: [
        Padding(
          padding: kPh20v10,
          child: SizedBox(
            height: kHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Response",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // FilledButton.tonalIcon(
                //   onPressed: widget.onPressedCodeButton,
                //   icon: Icon(
                //     widget.codePaneVisible
                //         ? Icons.code_off_rounded
                //         : Icons.code_rounded,
                //   ),
                //   label: SizedBox(
                //     width: 75,
                //     child: Text(
                //         widget.codePaneVisible ? "Hide Code" : "View Code"),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        Expanded(child: MQTTResponseView()),
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

class MQTTResponseView extends ConsumerWidget {
  const MQTTResponseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(realtimeHistoryStateProvider);
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: history[index]['direction'] == 'receive'
              ? const Icon(
                  Icons.arrow_downward,
                  color: Colors.green,
                )
              : history[index]['direction'] == 'send'
                  ? const Icon(
                      Icons.arrow_upward,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
          title: Text(history[index]['message'] ?? ''),
        );
      },
    );
  }
}
