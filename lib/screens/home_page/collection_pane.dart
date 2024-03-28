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
    final overlayWidget = OverlayWidgetTemplate(context: context);
    final collection = ref.watch(collectionStateNotifierProvider);
    final savingData = ref.watch(saveDataStateProvider);
    final deleteMultiple = ref.watch(deleteMultipleRequestsProvider);

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
            padding: kPe8,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: savingData
                      ? null
                      : () async {
                          overlayWidget.show(
                              widget:
                                  const SavingOverlay(saveCompleted: false));

                          await ref
                              .read(collectionStateNotifierProvider.notifier)
                              .saveData();
                          overlayWidget.hide();
                          overlayWidget.show(
                              widget: const SavingOverlay(saveCompleted: true));
                          await Future.delayed(const Duration(seconds: 1));
                          overlayWidget.hide();
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
          kVSpacer10,
          Container(
            height: 30,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: kBorderRadius8,
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
            child: Row(
              children: [
                kHSpacer5,
                Icon(
                  Icons.filter_alt,
                  size: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                kHSpacer5,
                Expanded(
                  child: RawTextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    hintText: "Filter by name or URL",
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state =
                          value.toLowerCase();
                    },
                  ),
                ),
              ],
            ),
          ),
          kVSpacer8,
          if (deleteMultiple.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected(${deleteMultiple.length})',
                  ),
                  ElevatedButton(
                    onPressed: (){
                      ref.read(collectionStateNotifierProvider.notifier).deleteSelected();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        maximumSize: const Size(40, 40),
                        minimumSize: const Size(40, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        )
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          if(deleteMultiple.isNotEmpty)
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
    final filterQuery = ref.watch(searchQueryProvider).trim();

    return Scrollbar(
      controller: controller,
      thumbVisibility: alwaysShowCollectionPaneScrollbar ? true : null,
      radius: const Radius.circular(12),
      child: filterQuery.isEmpty
          ? ReorderableListView.builder(
              padding: kPe8,
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
          : ListView(
              padding: kPe8,
              controller: controller,
              children: requestSequence.map((id) {
                var item = requestItems[id]!;
                if (item.url.toLowerCase().contains(filterQuery) ||
                    item.name.toLowerCase().contains(filterQuery)) {
                  return Padding(
                    padding: kP1,
                    child: RequestItem(
                      id: id,
                      requestModel: item,
                    ),
                  );
                }
                return const SizedBox();
              }).toList(),
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
    final deleteMultiple = ref.watch(deleteMultipleRequestsProvider);

    return Row(
      children: [
        if (deleteMultiple.isNotEmpty)
          SizedBox(
            width: 30,
            child: CheckBox(
              keyId: requestModel.id,
              value: deleteMultiple.contains(requestModel.id),
              onChanged: (checked) {
                if (checked ?? false) {
                  deleteMultiple.add(requestModel.id);
                } else {
                  deleteMultiple.remove(requestModel.id);
                }

                ref.read(deleteMultipleRequestsProvider.notifier).state = [
                  ...deleteMultiple
                ];
              },
            ),
          ),
        Expanded(
          child: SidebarRequestCard(
            id: id,
            method: requestModel.method,
            name: requestModel.name,
            url: requestModel.url,
            selectedId: selectedId,
            editRequestId: editRequestId,
            onTap: () {
              ref.read(selectedIdStateProvider.notifier).state = id;
            },
            onLongPress: () {
              if (!deleteMultiple.contains(requestModel.id)) {
                deleteMultiple.add(requestModel.id);
                ref.read(deleteMultipleRequestsProvider.notifier).state = [
                  ...deleteMultiple
                ];
              }
            },
            disableMenu: deleteMultiple.isNotEmpty,
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
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .duplicate(id);
              }

              if(item==RequestItemMenuOption.multiple){
                if (!deleteMultiple.contains(requestModel.id)) {
                  deleteMultiple.add(requestModel.id);
                  ref.read(deleteMultipleRequestsProvider.notifier).state = [
                    ...deleteMultiple
                  ];
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
