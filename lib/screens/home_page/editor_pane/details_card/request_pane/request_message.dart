import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditRequestMessage extends ConsumerWidget {
  const EditRequestMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref
        .watch(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!);

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        margin: kPt5o10,
        child: Column(
          children: [
            Expanded(
              child: TextFieldEditor(
                key: Key("$selectedId-message"),
                fieldKey: "$selectedId-message-editor",
                initialValue: requestModel?.message,
                onChanged: (String value) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(selectedId, message: value);
                },
              ),
            )
          ],
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: ElevatedButton.icon(
            onPressed: () => ref
                .read(collectionStateNotifierProvider.notifier)
                .sendWebSocketRequest(selectedId),
            icon: const Icon(Icons.send),
            label: const Text(
              kLabelSend,
              style: kTextStyleButton,
            ),
          ),
        ),
      ),
    ]);
  }
}
