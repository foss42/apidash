import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionPane extends ConsumerWidget {
  const CollectionPane({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sm = ScaffoldMessenger.of(context);
    final collection = ref.watch(collectionStateNotifierProvider);
    final savingData = ref.watch(saveDataStateProvider);

    if (collection == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: kIsMacOS ? kP24CollectionPane : kP8CollectionPane,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 35,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: kBorderRadius8,
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceVariant,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 18,
                ),
                kHSpacer5,
                Expanded(
                  child: SizedBox(
                    height: 35,
                    child: TextField(
                      onChanged: (value) => ref
                          .read(collectionStateNotifierProvider.notifier)
                          .filter(value.trim()),
                      decoration: const InputDecoration(
                        constraints: BoxConstraints(
                          maxHeight: 35,
                          minHeight: 35,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          bottom: 16,
                          right: 5,
                          left: 5,
                        ),
                        counterText: '',
                      ),
                      // cursorHeight: 12,
                      maxLines: 1,
                      maxLength: 150,
                      style: const TextStyle(
                        fontSize: 12,
                        // height: 0.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          kVSpacer8,
          Padding(
            padding: kPr8CollectionPane,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: savingData
                      ? null
                      : () async {
                          await ref
                              .read(collectionStateNotifierProvider.notifier)
                              .saveData();

                          sm.hideCurrentSnackBar();
                          sm.showSnackBar(getSnackBar("Saved"));
                        },
                  icon: const Icon(
                    Icons.save,
                    size: 20,
                  ),
                  label: const Text(
                    kLabelSave,
                    style: kTextStyleButton,
                  ),
                ),
                //const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    ref.read(collectionStateNotifierProvider.notifier).add();
                  },
                  child: const Text(
                    kLabelPlusNew,
                    style: kTextStyleButton,
                  ),
                ),
              ],
            ),
          ),
          kVSpacer8,
          const Expanded(
            child: RequestList(),
          ),
        ],
      ),
    );
  }
}

class RequestList extends ConsumerStatefulWidget {
  const RequestList({
    super.key,
  });

  @override
  ConsumerState<RequestList> createState() => _RequestListState();
}

class _RequestListState extends ConsumerState<RequestList> {
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
  Widget build(BuildContext context) {
    final requestSequence = ref.watch(requestSequenceProvider);
    final requestItems = ref.watch(collectionStateNotifierProvider)!;
    final alwaysShowCollectionPaneScrollbar = ref.watch(settingsProvider
        .select((value) => value.alwaysShowCollectionPaneScrollbar));

    if (requestItems.isNotEmpty && requestSequence.isEmpty) {
      return Center(
        child: Text(
          'Request not found!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return Scrollbar(
      controller: controller,
      thumbVisibility: alwaysShowCollectionPaneScrollbar ? true : null,
      radius: const Radius.circular(12),
      child: ReorderableListView.builder(
        padding: kPr8CollectionPane,
        scrollController: controller,
        buildDefaultDragHandles: false,
        itemCount: requestSequence.length,
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          if (oldIndex != newIndex) {
            ref
                .read(collectionStateNotifierProvider.notifier)
                .reorder(oldIndex, newIndex);
          }
        },
        itemBuilder: (context, index) {
          var id = requestSequence[index];
          return ReorderableDragStartListener(
            key: ValueKey(id),
            index: index,
            child: Padding(
              padding: kP1,
              child: RequestItem(
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

class RequestItem extends ConsumerWidget {
  const RequestItem({
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

    return SidebarRequestCard(
      id: id,
      method: requestModel.method,
      name: requestModel.name,
      url: requestModel.url,
      selectedId: selectedId,
      editRequestId: editRequestId,
      onTap: () {
        ref.read(selectedIdStateProvider.notifier).state = id;
      },
      // onDoubleTap: () {
      //   ref.read(selectedIdStateProvider.notifier).state = id;
      //   ref.read(selectedIdEditStateProvider.notifier).state = id;
      // },
      // controller: ref.watch(nameTextFieldControllerProvider),
      focusNode: ref.watch(nameTextFieldFocusNodeProvider),
      onChangedNameEditor: (value) {
        value = value.trim();
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(editRequestId!, name: value);
      },
      onTapOutsideNameEditor: () {
        ref.read(selectedIdEditStateProvider.notifier).state = null;
      },
      onMenuSelected: (RequestItemMenuOption item) {
        if (item == RequestItemMenuOption.edit) {
          // var controller =
          //     ref.read(nameTextFieldControllerProvider.notifier).state;
          // controller.text = requestModel.name;
          // controller.selection = TextSelection.fromPosition(
          //   TextPosition(offset: controller.text.length),
          // );
          ref.read(selectedIdEditStateProvider.notifier).state = id;
          Future.delayed(
            const Duration(milliseconds: 150),
            () => ref
                .read(nameTextFieldFocusNodeProvider.notifier)
                .state
                .requestFocus(),
          );
        }
        if (item == RequestItemMenuOption.delete) {
          ref.read(collectionStateNotifierProvider.notifier).remove(id);
        }
        if (item == RequestItemMenuOption.duplicate) {
          ref.read(collectionStateNotifierProvider.notifier).duplicate(id);
        }
      },
    );
  }
}
