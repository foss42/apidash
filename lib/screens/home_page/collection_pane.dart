import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/importer/import_dialog.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import '../common_widgets/common_widgets.dart';

class CollectionPane extends ConsumerWidget {
  const CollectionPane({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(collectionStateNotifierProvider);
    var sm = ScaffoldMessenger.of(context);
    if (collection == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: (!context.isMediumWindow && kIsMacOS ? kPt24l4 : kPt8l4) +
          (context.isMediumWindow ? kPb70 : EdgeInsets.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SidebarHeader(
            onAddNew: () {
              ref.read(collectionStateNotifierProvider.notifier).add();
            },
            onImport: () {
              importToCollectionPane(context, ref, sm);
            },
          ),
          if (context.isMediumWindow) kVSpacer6,
          if (context.isMediumWindow)
            Padding(
              padding: kPh8,
              child: EnvironmentDropdown(),
            ),
          kVSpacer10,
          SidebarFilter(
            filterHintText: "Filter by name or url",
            onFilterFieldChanged: (value) {
              ref.read(collectionSearchQueryProvider.notifier).state =
                  value.toLowerCase();
            },
          ),
          kVSpacer10,
          const Expanded(
            child: RequestList(),
          ),
          kVSpacer5
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
    final filterQuery = ref.watch(collectionSearchQueryProvider).trim();

    return Scrollbar(
      controller: controller,
      thumbVisibility: alwaysShowCollectionPaneScrollbar ? true : null,
      radius: const Radius.circular(12),
      child: filterQuery.isEmpty
          ? ReorderableListView.builder(
              padding: context.isMediumWindow
                  ? EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom,
                      right: 8,
                    )
                  : kPe8,
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
                if (kIsMobile) {
                  return ReorderableDelayedDragStartListener(
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
                }
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
              padding: context.isMediumWindow
                  ? EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom,
                      right: 8,
                    )
                  : kPe8,
              controller: controller,
              children: requestSequence.map((id) {
                var item = requestItems[id]!;
                if (item.httpRequestModel!.url
                        .toLowerCase()
                        .contains(filterQuery) ||
                    item.name.toLowerCase().contains(filterQuery)) {
                  return Padding(
                    padding: kP1,
                    child: RequestItem(
                      id: id,
                      requestModel: item,
                    ),
                  );
                }
                return kSizedBoxEmpty;
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

    return SidebarRequestCard(
      id: id,
      apiType: requestModel.apiType,
      method: requestModel.httpRequestModel!.method,
      name: requestModel.name,
      url: requestModel.httpRequestModel?.url,
      selectedId: selectedId,
      editRequestId: editRequestId,
      onTap: () {
        ref.read(selectedIdStateProvider.notifier).state = id;
        kHomeScaffoldKey.currentState?.closeDrawer();
      },
      onSecondaryTap: () {
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
            .update(id: editRequestId!, name: value);
      },
      onTapOutsideNameEditor: () {
        ref.read(selectedIdEditStateProvider.notifier).state = null;
      },
      onMenuSelected: (ItemMenuOption item) {
        if (item == ItemMenuOption.edit) {
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
        if (item == ItemMenuOption.delete) {
          ref.read(collectionStateNotifierProvider.notifier).remove(id: id);
        }
        if (item == ItemMenuOption.duplicate) {
          ref.read(collectionStateNotifierProvider.notifier).duplicate(id: id);
        }
      },
    );
  }
}
