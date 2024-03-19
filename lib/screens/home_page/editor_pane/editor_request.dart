import 'package:apidash/consts.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'details_card/details_card.dart';
import 'url_card.dart';

class RequestEditor extends StatelessWidget {
  const RequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequestTabView(),
        // RequestEditorTopBar(),
        EditorPaneRequestURLCard(),
        kVSpacer10,
        Expanded(
          child: EditorPaneRequestDetailsCard(),
        ),
      ],
    );
  }
}

class RequestTabView extends ConsumerWidget {
  const RequestTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabSequence = ref.watch(requestTabSequenceProvider);
    final requestItems = ref.watch(collectionStateNotifierProvider)!;

    return Container(
      // color: Colors.blue,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      constraints: const BoxConstraints(
        maxHeight: 30,
        minHeight: 30,
      ),
      child: ReorderableListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        itemCount: tabSequence.length,
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          if (oldIndex != newIndex) {
            ref
                .read(collectionStateNotifierProvider.notifier)
                .reorderTab(oldIndex, newIndex);
          }
        },
        itemExtentBuilder: (index, dimensions) {
          final length = dimensions.viewportMainAxisExtent / tabSequence.length;
          if (length > dimensions.viewportMainAxisExtent / 6) {
            return dimensions.viewportMainAxisExtent / 6;
          } else if (length < dimensions.viewportMainAxisExtent / 12) {
            return dimensions.viewportMainAxisExtent / 12;
          } else {
            return length;
          }
        },
        itemBuilder: (context, index) {
          var id = tabSequence[index];
          return ReorderableDragStartListener(
            key: ValueKey(id),
            index: index,
            child: Padding(
              padding: kP1,
              child: TabItem(
                id: id,
                requestModel: requestItems[id]!,
              ),
            ),
          );
        },
      ),
    );
  }
}

class TabItem extends ConsumerWidget {
  const TabItem({
    super.key,
    required this.id,
    required this.requestModel,
  });

  final String id;
  final RequestModel requestModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final editRequestId = ref.watch(selectedIdEditStateProvider);

    return TabRequestCard(
      id: id,
      method: requestModel.method,
      name: requestModel.name,
      url: requestModel.url,
      selectedId: selectedId,
      editRequestId: editRequestId,
      onTap: () {
        ref.read(selectedIdStateProvider.notifier).state = id;
      },
      onClose: () {
        final tabs = ref.read(requestTabSequenceProvider);
        final idx = tabs.indexOf(id);
        tabs.remove(id);
        ref.read(requestTabSequenceProvider.notifier).state = [...tabs];

        String? newId;
        if (idx > 0) {
          newId = tabs[idx - 1];
        } else if (tabs.isNotEmpty) {
          newId = tabs.first;
        } else {
          newId = null;
        }

        ref.read(selectedIdStateProvider.notifier).state = newId;
      },
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
