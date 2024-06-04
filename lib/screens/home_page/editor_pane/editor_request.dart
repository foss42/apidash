import 'package:apidash/consts.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/widgets/cards.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequestEditorTopBar(),
        kVSpacer5,
        EditorPaneRequestURLCard(),
        kVSpacer10,
        Expanded(
          child: EditorPaneRequestDetailsCard(),
        ),
      ],
    );
  }
}

class RequestTabView extends ConsumerStatefulWidget {
  const RequestTabView({super.key});

  @override
  ConsumerState<RequestTabView> createState() => _RequestTabViewState();
}

class _RequestTabViewState extends ConsumerState<RequestTabView> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, ) {
    final tabSequence = ref.watch(requestTabSequenceProvider);
    final requestItems = ref.watch(collectionStateNotifierProvider)!;
    final alwaysShowCollectionPaneScrollbar = ref.watch(settingsProvider
        .select((value) => value.alwaysShowCollectionPaneScrollbar));

    return Scrollbar(
      controller: controller,
      thumbVisibility: alwaysShowCollectionPaneScrollbar ? true : null,
      thickness: 5,
      radius: const Radius.circular(12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(
          maxHeight: 42,
          minHeight: 42,
        ),
        padding: const EdgeInsets.only(bottom: 7),
        child: ReorderableListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollController: controller,
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
            } else if (length < dimensions.viewportMainAxisExtent / 8) {
              return dimensions.viewportMainAxisExtent / 8;
            } else {
              return length;
            }
          },
          itemBuilder: (context, index) {
            var id = tabSequence[index];
            return ReorderableDragStartListener(
              key: ValueKey(id),
              index: index,
              child: TabItem(
                id: id,
                requestModel: requestItems[id]!,
              ),
            );
          },
        ),
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
