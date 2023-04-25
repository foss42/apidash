import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class CollectionPane extends ConsumerStatefulWidget {
  const CollectionPane({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CollectionPane> createState() => _CollectionPaneState();
}

class _CollectionPaneState extends ConsumerState<CollectionPane> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    final collection = ref.watch(collectionStateNotifierProvider);
    final savingData = ref.watch(saveDataStateProvider);
    if (collection == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: kP8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  ref
                      .read(activeIdStateProvider.notifier)
                      .update((state) => null);
                },
                icon: const Icon(
                  Icons.home,
                  size: 20,
                ),
                label: const Text(
                  'Home',
                  style: kTextStyleButton,
                ),
              ),
              TextButton.icon(
                onPressed: savingData
                    ? null
                    : () async {
                        ref
                            .read(saveDataStateProvider.notifier)
                            .update((state) => true);
                        await ref
                            .read(collectionStateNotifierProvider.notifier)
                            .saveData();
                        ref
                            .read(saveDataStateProvider.notifier)
                            .update((state) => false);

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
                  String newId =
                      ref.read(collectionStateNotifierProvider.notifier).add();
                  ref
                      .read(activeIdStateProvider.notifier)
                      .update((state) => newId);
                },
                child: const Text(
                  kLabelPlusNew,
                  style: kTextStyleButton,
                ),
              ),
            ],
          ),
          kVSpacer8,
          const Expanded(
            child: SingleChildScrollView(
              child: RequestList(),
            ),
          ),
        ],
      ),
    );
  }
}

class RequestList extends ConsumerStatefulWidget {
  const RequestList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RequestList> createState() => _RequestListState();
}

class _RequestListState extends ConsumerState<RequestList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final requestItems = ref.watch(collectionStateNotifierProvider)!;
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      itemCount: requestItems.length,
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
        return ReorderableDragStartListener(
          key: Key(requestItems[index].id),
          index: index,
          child: Padding(
            padding: kP1,
            child: RequestItem(
              id: requestItems[index].id,
              requestModel: requestItems[index],
            ),
          ),
        );
      },
    );
  }
}

class RequestItem extends ConsumerStatefulWidget {
  const RequestItem({
    required this.id,
    required this.requestModel,
    Key? key,
  }) : super(key: key);

  final String id;
  final RequestModel requestModel;

  @override
  ConsumerState<RequestItem> createState() => _RequestItemState();
}

class _RequestItemState extends ConsumerState<RequestItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeRequestId = ref.watch(activeIdStateProvider);
    final editRequestId = ref.watch(activeIdEditStateProvider);

    return SidebarRequestCard(
      id: widget.id,
      method: widget.requestModel.method,
      name: widget.requestModel.name,
      url: widget.requestModel.url,
      activeRequestId: activeRequestId,
      editRequestId: editRequestId,
      onTap: () {
        ref.read(activeIdStateProvider.notifier).update((state) => widget.id);
      },
      onDoubleTap: () {
        ref.read(activeIdStateProvider.notifier).update((state) => widget.id);
        ref
            .read(activeIdEditStateProvider.notifier)
            .update((state) => widget.id);
      },
      onChangedNameEditor: (value) {
        value = value.trim();
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(editRequestId!, name: value);
      },
      onTapOutsideNameEditor: () {
        ref.read(activeIdEditStateProvider.notifier).update((state) => null);
      },
      onMenuSelected: (RequestItemMenuOption item) {
        if (item == RequestItemMenuOption.delete) {
          ref.read(activeIdStateProvider.notifier).update((state) => null);
          ref.read(collectionStateNotifierProvider.notifier).remove(widget.id);
        }
        if (item == RequestItemMenuOption.duplicate) {
          ref
              .read(collectionStateNotifierProvider.notifier)
              .duplicate(widget.id);
        }
      },
    );
  }
}
