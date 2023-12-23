import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

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

    return Scrollbar(
      controller: controller,
      thumbVisibility: alwaysShowCollectionPaneScrollbar ? true : null,
      radius: const Radius.circular(12),
      child: requestSequence.isNotEmpty
          ? ReorderableListView.builder(
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
            )
          : const Center(
              child: Text("No Requests found"),
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
    final activeRequestId = ref.watch(activeIdStateProvider);
    final editRequestId = ref.watch(activeIdEditStateProvider);

    return SidebarRequestCard(
      id: id,
      method: requestModel.method,
      name: requestModel.name,
      url: requestModel.url,
      activeRequestId: activeRequestId,
      editRequestId: editRequestId,
      onTap: () {
        ref.read(activeIdStateProvider.notifier).state = id;
      },
      // onDoubleTap: () {
      //   ref.read(activeIdStateProvider.notifier).state = id;
      //   ref.read(activeIdEditStateProvider.notifier).state = id;
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
        ref.read(activeIdEditStateProvider.notifier).state = null;
      },
      onMenuSelected: (RequestItemMenuOption item) {
        if (item == RequestItemMenuOption.edit) {
          // var controller =
          //     ref.read(nameTextFieldControllerProvider.notifier).state;
          // controller.text = requestModel.name;
          // controller.selection = TextSelection.fromPosition(
          //   TextPosition(offset: controller.text.length),
          // );
          ref.read(activeIdEditStateProvider.notifier).state = id;
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
