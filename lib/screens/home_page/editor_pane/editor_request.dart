import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'details_card/details_card.dart';
import 'url_card.dart';

class RequestEditor extends StatelessWidget {
  const RequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        RequestEditorTopBar(),
        EditorPaneRequestURLCard(),
        kVSpacer10,
        Expanded(
          child: EditorPaneRequestDetailsCard(),
        ),
      ],
    );
  }
}

class RequestEditorTopBar extends ConsumerWidget {
  const RequestEditorTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedIdStateProvider);
    final name =
        ref.watch(selectedRequestModelProvider.select((value) => value?.name));
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        top: 4.0,
        right: 8.0,
        bottom: 4.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          SizedBox(
            width: 90,
            height: 24,
            child: FilledButton.tonalIcon(
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      final controller =
                          TextEditingController(text: name ?? "");
                      controller.selection = TextSelection(
                          baseOffset: 0, extentOffset: controller.text.length);
                      return AlertDialog(
                        title: const Text('Rename Request'),
                        content: TextField(
                          autofocus: true,
                          controller: controller,
                          decoration:
                              const InputDecoration(hintText: "Enter new name"),
                        ),
                        actions: <Widget>[
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('CANCEL')),
                          FilledButton(
                              onPressed: () {
                                final val = controller.text.trim();
                                ref
                                    .read(collectionStateNotifierProvider
                                        .notifier)
                                    .update(id!, name: val);
                                Navigator.pop(context);
                                controller.dispose();
                              },
                              child: const Text('OK')),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.edit,
                size: 12,
              ),
              label: Text(
                "Rename",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          )
        ],
      ),
    );
  }
}
