import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditWebsocketMessage extends ConsumerWidget {
  const EditWebsocketMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      margin: kPt5o10,
      child: Column(
        children: [
          Expanded(
            child: TextFieldEditor(
              key: Key("$selectedId-body"),
              fieldKey: "$selectedId-body-editor",
              initialValue: requestModel?.websocketMessageBody,
              onChanged: (String value) {
                ref
                    .watch(collectionStateNotifierProvider.notifier)
                    .update(selectedId, websocketMessageBody: value);
              },
            ),
          ),
          const SendWebsocketMessageButton()
        ],
      ),
    );
  }
}

class SendWebsocketMessageButton extends ConsumerWidget {
  const SendWebsocketMessageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    final message = ref
        .watch(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)
        ?.websocketMessageBody;
    return SendRequestButton(
      selectedId: selectedId,
      sentRequestId: sentRequestId,
      onTap: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .sendWebSocketMessage(selectedId, message!);
      },
    );
  }
}
